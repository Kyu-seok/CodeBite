package com.codebite.solution.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.common.exception.UnsupportedValueException;
import com.codebite.judge.service.JudgeService;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TagRepository;
import com.codebite.solution.dto.CreateSolutionRequest;
import com.codebite.solution.dto.SolutionDetail;
import com.codebite.solution.dto.SolutionListItem;
import com.codebite.solution.dto.SortField;
import com.codebite.solution.dto.UpdateSolutionRequest;
import com.codebite.solution.entity.Solution;
import com.codebite.solution.entity.SolutionVote;
import com.codebite.solution.entity.VoteDirection;
import com.codebite.solution.repository.SolutionRepository;
import com.codebite.solution.repository.SolutionVoteRepository;
import com.codebite.submission.entity.Submission;
import com.codebite.submission.repository.SubmissionRepository;
import com.codebite.user.entity.User;
import com.codebite.user.repository.UserRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.Set;

@Service
public class SolutionService {

    private final SolutionRepository solutionRepository;
    private final SolutionVoteRepository voteRepository;
    private final ProblemRepository problemRepository;
    private final TagRepository tagRepository;
    private final UserRepository userRepository;
    private final SubmissionRepository submissionRepository;
    private final JudgeService judgeService;

    public SolutionService(SolutionRepository solutionRepository,
                           SolutionVoteRepository voteRepository,
                           ProblemRepository problemRepository,
                           TagRepository tagRepository,
                           UserRepository userRepository,
                           SubmissionRepository submissionRepository,
                           JudgeService judgeService) {
        this.solutionRepository = solutionRepository;
        this.voteRepository = voteRepository;
        this.problemRepository = problemRepository;
        this.tagRepository = tagRepository;
        this.userRepository = userRepository;
        this.submissionRepository = submissionRepository;
        this.judgeService = judgeService;
    }

    @Transactional(readOnly = true)
    public Page<SolutionListItem> list(String problemSlug, String language, String tagSlug,
                                       String search, SortField sort, Pageable pageable) {
        Specification<Solution> spec = SolutionSpecifications.publishedAndProblemSlug(problemSlug);
        if (language != null && !language.isBlank()) {
            spec = spec.and(SolutionSpecifications.hasLanguage(language));
        }
        if (tagSlug != null && !tagSlug.isBlank()) {
            spec = spec.and(SolutionSpecifications.hasTagSlug(tagSlug));
        }
        if (search != null && !search.isBlank()) {
            spec = spec.and(SolutionSpecifications.titleContains(search));
        }

        Pageable sortedPageable = PageRequest.of(
                pageable.getPageNumber(), pageable.getPageSize(), sortFor(sort));

        return solutionRepository.findAll(spec, sortedPageable).map(SolutionMapper::toListItem);
    }

    @Transactional
    public SolutionDetail get(Long id, Long viewerId) {
        Solution s = solutionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", id));
        s.setViewsCount(s.getViewsCount() + 1);
        VoteDirection viewerVote = viewerVoteFor(s, viewerId);
        return SolutionMapper.toDetail(s, viewerVote, viewerId);
    }

    @Transactional
    public SolutionDetail create(String problemSlug, CreateSolutionRequest request, Long userId) {
        Problem problem = problemRepository.findBySlug(problemSlug)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFound", problemSlug));
        User author = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("error.user.notFound", userId));

        validateLanguages(request.languages());

        Solution s = new Solution();
        s.setProblem(problem);
        s.setAuthor(author);
        s.setTitle(request.title());
        s.setContent(request.content());
        s.setLanguages(new HashSet<>(request.languages()));
        s.setTags(loadTags(request.tagIds()));

        if (request.fromSubmissionId() != null) {
            Submission src = submissionRepository.findById(request.fromSubmissionId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "error.submission.notFound", request.fromSubmissionId()));
            if (src.getUser() != null && userId.equals(src.getUser().getId())) {
                s.setSourceSubmission(src);
            }
        }

        Solution saved = solutionRepository.save(s);
        return SolutionMapper.toDetail(saved, null, userId);
    }

    @Transactional
    public SolutionDetail update(Long id, UpdateSolutionRequest request, Long userId, boolean isAdmin) {
        Solution s = solutionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", id));
        if (!isAdmin && !userId.equals(s.getAuthor().getId())) {
            throw new AccessDeniedException("error.solution.access.denied");
        }

        validateLanguages(request.languages());

        s.setTitle(request.title());
        s.setContent(request.content());
        s.setLanguages(new HashSet<>(request.languages()));
        s.setTags(loadTags(request.tagIds()));

        VoteDirection viewerVote = viewerVoteFor(s, userId);
        return SolutionMapper.toDetail(s, viewerVote, userId);
    }

    @Transactional
    public void delete(Long id, Long userId, boolean isAdmin) {
        Solution s = solutionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", id));
        if (!isAdmin && !userId.equals(s.getAuthor().getId())) {
            throw new AccessDeniedException("error.solution.access.denied");
        }
        solutionRepository.delete(s);
    }

    @Transactional
    public void setPublished(Long id, boolean published) {
        Solution s = solutionRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.solution.notFound", id));
        s.setPublished(published);
    }

    private Set<Tag> loadTags(Set<Long> tagIds) {
        if (tagIds == null || tagIds.isEmpty()) return new HashSet<>();
        return new HashSet<>(tagRepository.findAllById(tagIds));
    }

    private void validateLanguages(Set<String> languages) {
        for (String lang : languages) {
            if (!judgeService.isLanguageSupported(lang)) {
                throw new UnsupportedValueException("error.language.unsupported", lang);
            }
        }
    }

    private VoteDirection viewerVoteFor(Solution s, Long viewerId) {
        if (viewerId == null) return null;
        return voteRepository.findBySolutionIdAndUserId(s.getId(), viewerId)
                .map(SolutionVote::getDirection)
                .orElse(null);
    }

    private Sort sortFor(SortField field) {
        return switch (field == null ? SortField.NET_SCORE : field) {
            case NET_SCORE -> Sort.by(Sort.Order.desc("netScore"), Sort.Order.desc("createdAt"));
            case RECENT -> Sort.by(Sort.Order.desc("createdAt"));
            case COMMENTS -> Sort.by(Sort.Order.desc("commentsCount"), Sort.Order.desc("createdAt"));
            case OLDEST -> Sort.by(Sort.Order.asc("createdAt"));
        };
    }
}
