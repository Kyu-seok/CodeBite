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
import com.codebite.problem.entity.TestCase;
import com.codebite.problem.repository.ProblemRepository;
import com.codebite.problem.repository.TestCaseRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class ProblemService {

    private final ProblemRepository problemRepository;
    private final TestCaseRepository testCaseRepository;

    public ProblemService(ProblemRepository problemRepository, TestCaseRepository testCaseRepository) {
        this.problemRepository = problemRepository;
        this.testCaseRepository = testCaseRepository;
    }

    @Transactional(readOnly = true)
    public Page<ProblemListItem> listPublishedProblems(Difficulty difficulty, Pageable pageable) {
        Page<Problem> page;
        if (difficulty != null) {
            page = problemRepository.findByPublishedTrueAndDifficulty(difficulty, pageable);
        } else {
            page = problemRepository.findByPublishedTrue(pageable);
        }
        return page.map(this::toListItem);
    }

    @Transactional(readOnly = true)
    public ProblemDetail getProblemBySlug(String slug) {
        Problem problem = problemRepository.findBySlug(slug)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found: " + slug));
        if (!problem.isPublished()) {
            throw new ResourceNotFoundException("Problem not found: " + slug);
        }
        List<TestCase> sampleCases = testCaseRepository
                .findByProblemIdAndSampleTrueOrderByOrderIndexAsc(problem.getId());
        return toDetail(problem, sampleCases);
    }

    @Transactional
    public ProblemDetail createProblem(CreateProblemRequest request) {
        Problem problem = new Problem();
        problem.setTitle(request.title());
        problem.setSlug(slugify(request.title()));
        problem.setDescription(request.description());
        problem.setDifficulty(request.difficulty());
        problem.setStarterCode(request.starterCode());
        problem.setConstraints(request.constraints());
        problem.setPublished(request.published() != null && request.published());

        problem = problemRepository.save(problem);
        return toDetail(problem, List.of());
    }

    @Transactional
    public ProblemDetail updateProblem(Long id, UpdateProblemRequest request) {
        Problem problem = problemRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found with id: " + id));

        if (request.title() != null) {
            problem.setTitle(request.title());
            problem.setSlug(slugify(request.title()));
        }
        if (request.description() != null) {
            problem.setDescription(request.description());
        }
        if (request.difficulty() != null) {
            problem.setDifficulty(request.difficulty());
        }
        if (request.starterCode() != null) {
            problem.setStarterCode(request.starterCode());
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
        return toDetail(problem, sampleCases);
    }

    @Transactional
    public TestCaseDto addTestCase(Long problemId, CreateTestCaseRequest request) {
        Problem problem = problemRepository.findById(problemId)
                .orElseThrow(() -> new ResourceNotFoundException("Problem not found with id: " + problemId));

        TestCase testCase = new TestCase();
        testCase.setProblem(problem);
        testCase.setInput(request.input());
        testCase.setExpectedOutput(request.expectedOutput());
        testCase.setSample(request.sample() != null && request.sample());
        testCase.setOrderIndex(request.orderIndex() != null ? request.orderIndex() : 0);

        testCase = testCaseRepository.save(testCase);
        return toTestCaseDto(testCase);
    }

    private String slugify(String title) {
        String base = title.toLowerCase()
                .replaceAll("[^a-z0-9\\s-]", "")
                .replaceAll("\\s+", "-")
                .replaceAll("-+", "-")
                .replaceAll("^-|-$", "");

        String slug = base;
        int suffix = 2;
        while (problemRepository.existsBySlug(slug)) {
            slug = base + "-" + suffix;
            suffix++;
        }
        return slug;
    }

    private ProblemListItem toListItem(Problem problem) {
        return new ProblemListItem(
                problem.getId(),
                problem.getTitle(),
                problem.getSlug(),
                problem.getDifficulty()
        );
    }

    private ProblemDetail toDetail(Problem problem, List<TestCase> sampleCases) {
        return new ProblemDetail(
                problem.getId(),
                problem.getTitle(),
                problem.getSlug(),
                problem.getDescription(),
                problem.getDifficulty(),
                problem.getStarterCode(),
                problem.getConstraints(),
                problem.isPublished(),
                sampleCases.stream().map(this::toTestCaseDto).toList(),
                problem.getCreatedAt(),
                problem.getUpdatedAt()
        );
    }

    private TestCaseDto toTestCaseDto(TestCase tc) {
        return new TestCaseDto(
                tc.getId(),
                tc.getInput(),
                tc.getExpectedOutput(),
                tc.isSample(),
                tc.getOrderIndex()
        );
    }
}
