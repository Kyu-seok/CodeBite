package com.codebite.user.controller;

import com.codebite.auth.jwt.JwtUserPrincipal;
import com.codebite.user.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PatchMapping("/settings")
    public ResponseEntity<Void> updateSettings(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @RequestBody Map<String, String> body) {
        if (body.containsKey("editorSettings")) {
            userService.updateEditorSettings(principal.id(), body.get("editorSettings"));
        }
        if (body.containsKey("themePreference")) {
            userService.updateThemePreference(principal.id(), body.get("themePreference"));
        }
        if (body.containsKey("locale")) {
            userService.updateLocale(principal.id(), body.get("locale"));
        }
        if (body.containsKey("curation")) {
            userService.updateCuration(principal.id(), body.get("curation"));
        }
        if (body.containsKey("singlePage")) {
            userService.updateSinglePage(principal.id(), Boolean.valueOf(body.get("singlePage")));
        }
        return ResponseEntity.noContent().build();
    }
}
