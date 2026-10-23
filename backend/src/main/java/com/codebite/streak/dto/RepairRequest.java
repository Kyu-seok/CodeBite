package com.codebite.streak.dto;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDate;

public record RepairRequest(@NotNull LocalDate date) {
}
