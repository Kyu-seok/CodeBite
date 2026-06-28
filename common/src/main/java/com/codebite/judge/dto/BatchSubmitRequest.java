package com.codebite.judge.dto;

import java.util.List;

public record BatchSubmitRequest(List<JudgeRequest> submissions) {
}
