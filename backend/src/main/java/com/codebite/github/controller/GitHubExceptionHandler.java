package com.codebite.github.controller;

import com.codebite.common.exception.ApiError;
import com.codebite.github.gateway.GitHubAppNotConfiguredException;
import com.codebite.github.gateway.GitHubGatewayException;
import com.codebite.github.gateway.GitHubInstallationNotAccessibleException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * Turns {@code GitHubGateway} failures that reach a controller into API errors. Ordered ahead of
 * {@code GlobalExceptionHandler}, whose catch-all would otherwise answer them with a 500.
 */
@RestControllerAdvice
@Order(Ordered.HIGHEST_PRECEDENCE)
public class GitHubExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GitHubExceptionHandler.class);

    private final MessageSource messageSource;

    public GitHubExceptionHandler(MessageSource messageSource) {
        this.messageSource = messageSource;
    }

    @ExceptionHandler(GitHubInstallationNotAccessibleException.class)
    public ResponseEntity<ApiError> handleInstallationNotAccessible(GitHubInstallationNotAccessibleException ex) {
        log.warn("GitHub install callback rejected: {}", ex.getMessage());
        return error(HttpStatus.FORBIDDEN, "error.github.installationNotAccessible");
    }

    @ExceptionHandler(GitHubAppNotConfiguredException.class)
    public ResponseEntity<ApiError> handleAppNotConfigured(GitHubAppNotConfiguredException ex) {
        return error(HttpStatus.SERVICE_UNAVAILABLE, "error.github.notConfigured");
    }

    @ExceptionHandler(GitHubGatewayException.class)
    public ResponseEntity<ApiError> handleGateway(GitHubGatewayException ex) {
        log.error("GitHub call failed: {}", ex.getMessage(), ex);
        return error(HttpStatus.BAD_GATEWAY, "error.github.unavailable");
    }

    private ResponseEntity<ApiError> error(HttpStatus status, String messageCode) {
        String message = messageSource.getMessage(messageCode, null, messageCode, LocaleContextHolder.getLocale());
        return ResponseEntity.status(status).body(new ApiError(status.value(), message));
    }
}
