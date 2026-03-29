package com.codebite.profile.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.profile.dto.ActivityDay;
import com.codebite.profile.dto.ProfileStats;
import com.codebite.profile.dto.RecentSubmission;
import com.codebite.profile.dto.TagProficiency;
import com.codebite.profile.service.ProfileService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/profile")
public class ProfileController {

    private final ProfileService profileService;

    public ProfileController(ProfileService profileService) {
        this.profileService = profileService;
    }

    @GetMapping("/stats")
    public ResponseEntity<ProfileStats> getStats(@AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(profileService.getStats(principal.id()));
    }

    @GetMapping("/activity")
    public ResponseEntity<List<ActivityDay>> getActivity(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @RequestParam(defaultValue = "12") int months) {
        return ResponseEntity.ok(profileService.getActivity(principal.id(), months));
    }

    @GetMapping("/tag-proficiency")
    public ResponseEntity<List<TagProficiency>> getTagProficiency(
            @AuthenticationPrincipal JwtUserPrincipal principal) {
        return ResponseEntity.ok(profileService.getTagProficiency(principal.id()));
    }

    @GetMapping("/recent-submissions")
    public ResponseEntity<Page<RecentSubmission>> getRecentSubmissions(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(profileService.getRecentSubmissions(
                principal.id(), PageRequest.of(page, Math.min(size, 50))));
    }
}
