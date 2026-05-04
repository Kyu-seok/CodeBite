package com.codebite.solution.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.solution.dto.ReportListItem;
import com.codebite.solution.dto.ReportRequest;
import com.codebite.solution.dto.ResolveReportRequest;
import com.codebite.solution.entity.ContentReport;
import com.codebite.solution.entity.ReportStatus;
import com.codebite.solution.entity.ReportTargetType;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionComment;
import com.codebite.solution.repository.ContentReportRepository;
import com.codebite.solution.repository.SolutionCommentRepository;
import com.codebite.solution.repository.SolutionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReportService {

    private final ContentReportRepository reportRepository;
    private final SolutionRepository solutionRepository;
    private final SolutionCommentRepository commentRepository;
    private final UserRepository userRepository;

    public ReportService(ContentReportRepository reportRepository,
                         SolutionRepository solutionRepository,
                         SolutionCommentRepository commentRepository,
                         UserRepository userRepository) {
        this.reportRepository = reportRepository;
        this.solutionRepository = solutionRepository;
        this.commentRepository = commentRepository;
        this.userRepository = userRepository;
    }

    @Transactional
    public void fileReport(ReportTargetType type, Long targetId, ReportRequest request, Long reporterId) {
        // Verify target exists
        if (type == ReportTargetType.SOLUTION) {
            solutionRepository.findById(targetId)
                    .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", targetId));
        } else {
            commentRepository.findById(targetId)
                    .orElseThrow(() -> new ResourceNotFoundException("error.comment.notFound", targetId));
        }
        User reporter = userRepository.findById(reporterId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", reporterId));

        ContentReport report = new ContentReport();
        report.setTargetType(type);
        report.setTargetId(targetId);
        report.setReporter(reporter);
        report.setReason(request.reason());
        report.setStatus(ReportStatus.OPEN);
        reportRepository.save(report);
    }

    @Transactional(readOnly = true)
    public Page<ReportListItem> list(ReportStatus status, ReportTargetType type, Pageable pageable) {
        ReportStatus s = status != null ? status : ReportStatus.OPEN;
        Page<ContentReport> reports = type != null
                ? reportRepository.findByStatusAndTargetType(s, type, pageable)
                : reportRepository.findByStatus(s, pageable);
        return reports.map(r -> new ReportListItem(
                r.getId(),
                r.getTargetType(),
                r.getTargetId(),
                r.getReporter().getUsername(),
                r.getReason(),
                r.getStatus(),
                previewFor(r.getTargetType(), r.getTargetId()),
                r.getCreatedAt()
        ));
    }

    @Transactional
    public void resolve(Long reportId, ResolveReportRequest request) {
        ContentReport report = reportRepository.findById(reportId)
                .orElseThrow(() -> new ResourceNotFoundException("error.report.notFound", reportId));

        ResolveReportRequest.ResolveAction action = request.action();
        if (action == ResolveReportRequest.ResolveAction.DISMISS) {
            report.setStatus(ReportStatus.DISMISSED);
            return;
        }

        if (report.getTargetType() == ReportTargetType.SOLUTION) {
            Solution s = solutionRepository.findById(report.getTargetId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "error.solution.notFound", report.getTargetId()));
            if (action == ResolveReportRequest.ResolveAction.HIDE_CONTENT) {
                s.setPublished(false);
            } else {
                solutionRepository.delete(s);
            }
        } else {
            SolutionComment c = commentRepository.findById(report.getTargetId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "error.comment.notFound", report.getTargetId()));
            // For comments HIDE behaves like DELETE (we don't have a hidden flag on comments).
            commentRepository.delete(c);
        }
        report.setStatus(ReportStatus.RESOLVED);
    }

    private String previewFor(ReportTargetType type, Long id) {
        if (type == ReportTargetType.SOLUTION) {
            return solutionRepository.findById(id)
                    .map(s -> s.getTitle())
                    .orElse("(deleted)");
        }
        return commentRepository.findById(id)
                .map(c -> truncate(c.getContent()))
                .orElse("(deleted)");
    }

    private static String truncate(String content) {
        if (content == null) return "";
        return content.length() <= 200 ? content : content.substring(0, 197) + "...";
    }
}
