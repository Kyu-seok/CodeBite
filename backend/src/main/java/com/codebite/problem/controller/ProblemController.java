package com.codebite.problem.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.problem.dto.ProblemDetail;
import com.codebite.problem.dto.ProblemListItem;
import com.codebite.problem.dto.ProblemStats;
import com.codebite.problem.entity.Difficulty;
import com.codebite.problem.service.ProblemService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;
import java.util.Set;

@RestController
@RequestMapping("/api/problems")
public class ProblemController {

    private static final Set<String> ALLOWED_SORT_FIELDS = Set.of("id", "problemNumber", "title", "difficulty");

    private final ProblemService problemService;

    public ProblemController(ProblemService problemService) {
        this.problemService = problemService;
    }

    @GetMapping
    public ResponseEntity<Page<ProblemListItem>> listProblems(
            @RequestParam(required = false) Difficulty difficulty,
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String tag,
            @AuthenticationPrincipal JwtUserPrincipal principal,
            Pageable pageable) {
        if (pageable.getSort().isUnsorted()) {
            pageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), Sort.by("problemNumber").ascending());
        } else {
            for (Sort.Order order : pageable.getSort()) {
                if (!ALLOWED_SORT_FIELDS.contains(order.getProperty())) {
                    pageable = PageRequest.of(pageable.getPageNumber(), pageable.getPageSize(), Sort.by("problemNumber").ascending());
                    break;
                }
            }
        }
        Long userId = principal != null ? principal.id() : null;
        return ResponseEntity.ok(problemService.listPublishedProblems(difficulty, search, tag, userId, pageable));
    }

    @GetMapping("/random")
    public ResponseEntity<Map<String, String>> getRandomProblem(
            @RequestParam(required = false) Difficulty difficulty,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        Long userId = principal != null ? principal.id() : null;
        String slug = problemService.getRandomProblemSlug(difficulty, userId);
        return ResponseEntity.ok(Map.of("slug", slug));
    }

    @GetMapping("/stats")
    public ResponseEntity<ProblemStats> getStats(@AuthenticationPrincipal JwtUserPrincipal principal) {
        Long userId = principal != null ? principal.id() : null;
        return ResponseEntity.ok(problemService.getStats(userId));
    }

    @GetMapping("/{slug}")
    public ResponseEntity<ProblemDetail> getProblem(@PathVariable String slug) {
        return ResponseEntity.ok(problemService.getProblemBySlug(slug));
    }
}
