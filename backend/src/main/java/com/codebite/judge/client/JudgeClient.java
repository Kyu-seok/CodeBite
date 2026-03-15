package com.codebite.judge.client;

import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;

public interface JudgeClient {

    JudgeResponse submit(JudgeRequest request);
}
