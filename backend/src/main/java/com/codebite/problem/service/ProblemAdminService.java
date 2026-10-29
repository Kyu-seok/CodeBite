package com.codebite.problem.service;

import com.codebite.common.exception.ResourceNotFoundException;
import com.codebite.problem.dto.CreateProblemRequest;
import com.codebite.problem.dto.CreateTestCaseRequest;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.TestCaseDto;
import com.codebite.problem.dto.UpdateProblemRequest;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Problem;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TagRepository;
import com.codebite.problem.repository.TestCaseRepository;
import com.codebite.progress.ProblemPopularity;
import com.codebite.progress.ProblemPopularity.Rate;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Problem curation behind /api/admin/problems: creating, editing, publishing and deleting
 * problems, their test cases and tags, and the admin list (every problem, published or not, with
 * its Acceptance Rate). Nothing here depends on a user's Progress.
 */
@Service
public class ProblemAdminService {

    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;
    private final TagRepository tagRepository;
    private final ProblemPopularity problemPopularity;
    private final ProblemDtos dtos;

    public ProblemAdminService(ProblemRepository problemRepository,
                               TestCaseRepository testCaseRepository,
                               TagRepository tagRepository,
                               ProblemPopularity problemPopularity,
                               ProblemDtos dtos) {
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
        this.tagRepository = tagRepository;
        this.problemPopularity = problemPopularity;
        this.dtos = dtos;
    }

    @Transactional
    public ProblemDetail createProblem(CreateProblemRequest request) {
        Problem problem = new Problem();
        problem.setTitle(request.title());
        problem.setSlug(slugify(request.title()));
        problem.setDescription(request.description());
        problem.setDifficulty(request.difficulty());
        problem.setConstraints(request.constraints());
        problem.setPublished(request.published() != null && request.published());

        problem = problemRepository.save(problem);
        return dtos.toDetail(problem, List.of(), null);
    }

    @Transactional
    public ProblemDetail updateProblem(Long id, UpdateProblemRequest request) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",id));

        // The Slug stays: the Driver and Starter Code are filed under it, so only a Restatement
        // migration moves it.
        if (request.title() != null) {
            problem.setTitle(request.title());
        }
        if (request.description() != null) {
            problem.setDescription(request.description());
        }
        if (request.difficulty() != null) {
            problem.setDifficulty(request.difficulty());
        }
        if (request.constraints() != null) {
            problem.setConstraints(request.constraints());
        }
        if (request.published() != null) {
            problem.setPublished(request.published());
        }

        problem = problemRepository.save(problem);
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        return dtos.toDetail(problem, sampleCases, null);
    }

    @Transactional
    public TestCaseDto addTestCase(Long problemId, CreateTestCaseRequest request) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",problemId));

        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput(request.input());
        testCase.setExpectedOutput(request.expectedOutput());
        testCase.setSample(request.sample() != null && request.sample());
        testCase.setOrderIndex(request.orderIndex() != null ? request.orderIndex() : 0);

        testCase = testCaseRepository.save(testCase);
        return dtos.toTestCaseDto(testCase);
    }

    @Transactional(readOnly = true)
    public Page<ProblemListItem> listAllProblems(Difficulty difficulty, String search, Boolean published, Pageable pageable) {
        Specification<Problem> spec = Specification.where(null);
        if (published != null) {
            if (published) {
                spec = spec.and(ProblemSpecifications.isPublished());
            } else {
                spec = spec.and((root, query, cb) -> cb.isFalse(root.get("published")));
            }
        }
        if (difficulty != null) {
            spec = spec.and(ProblemSpecifications.hasDifficulty(difficulty));
        }
        if (search != null && !search.isBlank()) {
            spec = spec.and(ProblemSpecifications.titleContains(search));
        }

        Page<Problem> page = problemRepository.findAll(spec, pageable);
        Map<Long, Rate> acceptanceRates = problemPopularity.acceptanceRates(
                page.getContent().stream().map(Problem::getId).toList());
        return page.map(p -> dtos.toListItem(p, Map.of(), acceptanceRates, Map.of()));
    }

    @Transactional(readOnly = true)
    public ProblemDetail getAdminProblemById(Long id) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",id));
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        return dtos.toDetail(problem, sampleCases, null);
    }

    @Transactional
    public void deleteProblem(Long id) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",id));
        problemRepository.delete(problem);
    }

    @Transactional(readOnly = true)
    public List<TestCaseDto> getTestCases(Long problemId) {
        if (!problemRepository.existsById(problemId)) {
            throw new ResourceNotFoundException("error.problem.notFoundById",problemId);
        }
        return testCaseRepository.findByProblemIdOrderByOrderIndexAsc(problemId)
                .stream().map(dtos::toTestCaseDto).toList();
    }

    @Transactional
    public TestCaseDto updateTestCase(Long problemId, Long testCaseId, CreateTestCaseRequest request) {
        TestCase testCase = testCaseRepository.findById(testCaseId)
                .orElseThrow(() -> new ResourceNotFoundException("error.testcase.notFound",testCaseId));
        if (!testCase.getProblem().getId().equals(problemId)) {
            throw new ResourceNotFoundException("error.testcase.notFound",testCaseId);
        }
        testCase.setInput(request.input());
        testCase.setExpectedOutput(request.expectedOutput());
        if (request.sample() != null) testCase.setSample(request.sample());
        if (request.orderIndex() != null) testCase.setOrderIndex(request.orderIndex());
        return dtos.toTestCaseDto(testCaseRepository.save(testCase));
    }

    @Transactional
    public void deleteTestCase(Long problemId, Long testCaseId) {
        TestCase testCase = testCaseRepository.findById(testCaseId)
                .orElseThrow(() -> new ResourceNotFoundException("error.testcase.notFound",testCaseId));
        if (!testCase.getProblem().getId().equals(problemId)) {
            throw new ResourceNotFoundException("error.testcase.notFound",testCaseId);
        }
        testCaseRepository.delete(testCase);
    }

    @Transactional(readOnly = true)
    public List<String> getProblemTags(Long problemId) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",problemId));
        return problem.getTags().stream().map(Tag::getName).sorted().toList();
    }

    @Transactional
    public List<String> updateProblemTags(Long problemId, List<Long> tagIds) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("error.problem.notFoundById",problemId));
        Set<Tag> tags = new HashSet<>(tagRepository.findAllById(tagIds));
        problem.setTags(tags);
        problemRepository.save(problem);
        return problem.getTags().stream().map(Tag::getName).sorted().toList();
    }

    private String slugify(String title) {
        String base = title.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");

        String slug = base;
        int suffix = 2;
        while (problemRepository.isSlugTaken(slug)) {
            slug = base + "-" + suffix;
            suffix++;
        }
        return slug;
    }
}
