package com.codebite.solution.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.solution.dto.CommentResponse;
import com.codebite.solution.dto.CreateCommentRequest;
import com.codebite.solution.dto.UpdateCommentRequest;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionComment;
import com.codebite.solution.repository.SolutionCommentRepository;
import com.codebite.solution.repository.SolutionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommentService {

    private final SolutionCommentRepository commentRepository;
    private final SolutionRepository solutionRepository;
    private final UserRepository userRepository;

    public CommentService(SolutionCommentRepository commentRepository,
                          SolutionRepository solutionRepository,
                          UserRepository userRepository) {
        this.commentRepository = commentRepository;
        this.solutionRepository = solutionRepository;
        this.userRepository = userRepository;
    }

    @Transactional(readOnly = true)
    public Page<CommentResponse> list(Long solutionId, Long viewerId, Pageable pageable) {
        Page<SolutionComment> topLevel = commentRepository
                .findBySolutionIdAndParentCommentIsNullOrderByCreatedAtAsc(solutionId, pageable);
        if (topLevel.isEmpty()) {
            return new PageImpl<>(List.of(), pageable, topLevel.getTotalElements());
        }

        List<Long> parentIds = topLevel.getContent().stream()
                .map(SolutionComment::getId)
                .toList();
        List<SolutionComment> replies = commentRepository.findByParentCommentIdInOrderByCreatedAtAsc(parentIds);

        Map<Long, List<CommentResponse>> repliesByParent = replies.stream()
                .map(r -> SolutionMapper.toCommentResponse(r, viewerId, List.of()))
                .collect(Collectors.groupingBy(CommentResponse::parentCommentId));

        List<CommentResponse> mapped = topLevel.getContent().stream()
                .map(c -> SolutionMapper.toCommentResponse(
                        c, viewerId, repliesByParent.getOrDefault(c.getId(), List.of())))
                .toList();

        return new PageImpl<>(mapped, pageable, topLevel.getTotalElements());
    }

    @Transactional
    public CommentResponse create(Long solutionId, CreateCommentRequest request, Long userId) {
        Solution s = solutionRepository.findByIdForUpdate(solutionId)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", solutionId));
        User author = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));

        SolutionComment parent = null;
        if (request.parentCommentId() != null) {
            parent = commentRepository.findById(request.parentCommentId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "error.comment.notFound", request.parentCommentId()));
            if (!parent.getSolution().getId().equals(solutionId)) {
                throw new ResourceNotFoundException("error.comment.notFound", request.parentCommentId());
            }
            if (parent.getParentComment() != null) {
                throw new IllegalArgumentException("Replies cannot be nested further");
            }
        }

        SolutionComment c = new SolutionComment();
        c.setSolution(s);
        c.setAuthor(author);
        c.setContent(request.content());
        c.setParentComment(parent);
        SolutionComment saved = commentRepository.save(c);

        s.setCommentsCount(s.getCommentsCount() + 1);

        return SolutionMapper.toCommentResponse(saved, userId, List.of());
    }

    @Transactional
    public CommentResponse update(Long commentId, UpdateCommentRequest request, Long userId, boolean isAdmin) {
        SolutionComment c = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("error.comment.notFound", commentId));
        if (!isAdmin && !userId.equals(c.getAuthor().getId())) {
            throw new AccessDeniedException("error.comment.access.denied");
        }
        c.setContent(request.content());
        c.setEdited(true);
        return SolutionMapper.toCommentResponse(c, userId, List.of());
    }

    @Transactional
    public void delete(Long commentId, Long userId, boolean isAdmin) {
        SolutionComment c = commentRepository.findById(commentId)
                .orElseThrow(() -> new ResourceNotFoundException("error.comment.notFound", commentId));
        if (!isAdmin && !userId.equals(c.getAuthor().getId())) {
            throw new AccessDeniedException("error.comment.access.denied");
        }

        Solution s = solutionRepository.findByIdForUpdate(c.getSolution().getId())
                .orElseThrow(() -> new ResourceNotFoundException(
                        "error.solution.notFound", c.getSolution().getId()));

        // Count of itself + cascaded replies that will be deleted
        int decrement = 1;
        if (c.getParentComment() == null) {
            // top-level: replies will cascade
            decrement += commentRepository.findByParentCommentIdInOrderByCreatedAtAsc(List.of(c.getId())).size();
        }

        commentRepository.delete(c);
        s.setCommentsCount(Math.max(0, s.getCommentsCount() - decrement));
    }
}
