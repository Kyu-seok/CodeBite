package com.codebite.judge.dto;

import java.util.List;

public record BatchGetResponse(List<JudgeResponse> submissions) {
}
