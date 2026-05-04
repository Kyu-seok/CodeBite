package com.codebite.solution.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.solution.dto.CommentResponse;
import com.codebite.solution.dto.SolutionDetail;
import com.codebite.solution.dto.SolutionListItem;
import com.codebite.solution.dto.SortField;
import com.codebite.solution.service.CommentService;
import com.codebite.solution.service.SolutionService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class SolutionController {

    private final SolutionService solutionService;
    private final CommentService commentService;

    public SolutionController(SolutionService solutionService, CommentService commentService) {
        this.solutionService = solutionService;
        this.commentService = commentService;
    }

    @GetMapping("/problems/{slug}/solutions")
    public ResponseEntity<Page<SolutionListItem>> list(
            @PathVariable String slug,
            @RequestParam(required = false) String language,
            @RequestParam(required = false) String tag,
            @RequestParam(required = false) String search,
            @RequestParam(required = false, defaultValue = "NET_SCORE") String sort,
            Pageable pageable) {
        SortField sortField = SortField.fromString(sort);
        Pageable bounded = PageRequest.of(
                pageable.getPageNumber(),
                Math.min(Math.max(pageable.getPageSize(), 1), 50));
        return ResponseEntity.ok(solutionService.list(slug, language, tag, search, sortField, bounded));
    }

    @GetMapping("/solutions/{id}")
    public ResponseEntity<SolutionDetail> get(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        Long viewerId = principal != null ? principal.id() : null;
        return ResponseEntity.ok(solutionService.get(id, viewerId));
    }

    @GetMapping("/solutions/{id}/comments")
    public ResponseEntity<Page<CommentResponse>> listComments(
            @PathVariable Long id,
            @AuthenticationPrincipal JwtUserPrincipal principal,
            Pageable pageable) {
        Long viewerId = principal != null ? principal.id() : null;
        Pageable bounded = PageRequest.of(
                pageable.getPageNumber(),
                Math.min(Math.max(pageable.getPageSize(), 1), 50));
        return ResponseEntity.ok(commentService.list(id, viewerId, bounded));
    }
}
