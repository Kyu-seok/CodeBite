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
    public ResponseEntity<Void> updateEditorSettings(
            @AuthenticationPrincipal JwtUserPrincipal principal,
            @RequestBody Map<String, String> body) {
        String editorSettings = body.get("editorSettings");
        userService.updateEditorSettings(principal.id(), editorSettings);
        return ResponseEntity.noContent().build();
    }
}
