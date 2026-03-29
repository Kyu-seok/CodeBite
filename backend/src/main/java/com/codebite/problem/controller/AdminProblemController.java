package com.codebite.problem.controller;

import com.codebite.problem.dto.CreateProblemRequest;
import com.codebite.problem.dto.CreateTestCaseRequest;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.TestCaseDto;
import com.codebite.problem.dto.UpdateProblemRequest;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.entity.Tag;
import com.codebite.problem.repository.TagRepository;
import com.codebite.problem.service.ProblemService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/admin/problems")
@PreAuthorize("hasRole('ADMIN')")
public class AdminProblemController {

    private final ProblemService problemService;
    private final TagRepository tagRepository;

    public AdminProblemController(ProblemService problemService, TagRepository tagRepository) {
        this.problemService = problemService;
        this.tagRepository = tagRepository;
    }

    @GetMapping
    public Page<ProblemListItem> listProblems(
            @RequestParam(required = false) Difficulty difficulty,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) Boolean published,
            @PageableDefault(size = 50, sort = "id", direction = Sort.Direction.DESC) Pageable pageable) {
        return problemService.listAllProblems(difficulty, search, published, pageable);
    }

    @GetMapping("/{id}")
    public ProblemDetail getProblem(@PathVariable Long id) {
        return problemService.getAdminProblemById(id);
    }

    @PostMapping
    public ResponseEntity<ProblemDetail> createProblem(@Valid @RequestBody CreateProblemRequest request) {
        ProblemDetail created = problemService.createProblem(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}")
    public ResponseEntity<ProblemDetail> updateProblem(
            @PathVariable Long id,
            @RequestBody UpdateProblemRequest request) {
        return ResponseEntity.ok(problemService.updateProblem(id, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProblem(@PathVariable Long id) {
        problemService.deleteProblem(id);
        return ResponseEntity.noContent().build();
    }

    // ── Test cases ──

    @GetMapping("/{id}/test-cases")
    public List<TestCaseDto> getTestCases(@PathVariable Long id) {
        return problemService.getTestCases(id);
    }

    @PostMapping("/{id}/test-cases")
    public ResponseEntity<TestCaseDto> addTestCase(
            @PathVariable Long id,
            @Valid @RequestBody CreateTestCaseRequest request) {
        TestCaseDto created = problemService.addTestCase(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @PutMapping("/{id}/test-cases/{testCaseId}")
    public TestCaseDto updateTestCase(
            @PathVariable Long id,
            @PathVariable Long testCaseId,
            @Valid @RequestBody CreateTestCaseRequest request) {
        return problemService.updateTestCase(id, testCaseId, request);
    }

    @DeleteMapping("/{id}/test-cases/{testCaseId}")
    public ResponseEntity<Void> deleteTestCase(
            @PathVariable Long id,
            @PathVariable Long testCaseId) {
        problemService.deleteTestCase(id, testCaseId);
        return ResponseEntity.noContent().build();
    }

    // ── Tags ──

    @GetMapping("/tags")
    public List<Tag> listTags() {
        return tagRepository.findAllByOrderByNameAsc();
    }

    @GetMapping("/{id}/tags")
    public List<String> getProblemTags(@PathVariable Long id) {
        return problemService.getProblemTags(id);
    }

    @PutMapping("/{id}/tags")
    public List<String> updateProblemTags(
            @PathVariable Long id,
            @RequestBody List<Long> tagIds) {
        return problemService.updateProblemTags(id, tagIds);
    }
}
