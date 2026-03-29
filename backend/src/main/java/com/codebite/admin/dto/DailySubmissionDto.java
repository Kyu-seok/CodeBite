package com.codebite.admin.dto;

import java.time.LocalDate;

public record DailySubmissionDto(LocalDate date, long count) {
}
