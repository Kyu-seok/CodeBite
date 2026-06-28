package com.codebite.judge.client;

import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;

import java.util.List;

public interface JudgeClient {

    JudgeResponse submit(JudgeRequest request);

    JudgeResponse getSubmission(String token);

    List<JudgeResponse> submitBatch(List<JudgeRequest> requests);

    List<JudgeResponse> getBatch(List<String> tokens);
}
