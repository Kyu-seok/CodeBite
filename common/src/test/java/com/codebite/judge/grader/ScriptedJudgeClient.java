package com.codebite.judge.grader;

import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * An in-memory {@link JudgeClient} for grader tests. Each stdin is scripted to one terminal
 * {@link JudgeResponse}, returned on the first poll, and the submit calls are counted so a test
 * can tell a batch from a sequence of single submissions.
 */
class ScriptedJudgeClient implements JudgeClient {

    private final Map<String, JudgeResponse> responsesByStdin = new HashMap<>();
    private final Map<String, JudgeResponse> responsesByToken = new HashMap<>();
    private final List<JudgeRequest> submitted = new ArrayList<>();
    private RuntimeException failure;
    private int submitCalls;
    private int submitBatchCalls;

    static JudgeResponse accepted(String stdout) {
        return accepted(stdout, "0.01", 1024);
    }

    static JudgeResponse accepted(String stdout, String time, Integer memoryKb) {
        return new JudgeResponse(null, new JudgeResponse.Status(3, "Accepted"), stdout, null, null, time, memoryKb);
    }

    static JudgeResponse compilationError(String compileOutput) {
        return new JudgeResponse(null, new JudgeResponse.Status(6, "Compilation Error"), null, null, compileOutput, null, null);
    }

    static JudgeResponse runtimeError(String stderr) {
        return new JudgeResponse(null, new JudgeResponse.Status(11, "Runtime Error (NZEC)"), null, stderr, null, null, null);
    }

    ScriptedJudgeClient respond(String stdin, JudgeResponse response) {
        responsesByStdin.put(stdin, response);
        return this;
    }

    /** Every submit (single or batch) throws this instead of accepting the program. */
    ScriptedJudgeClient failSubmissionsWith(RuntimeException failure) {
        this.failure = failure;
        return this;
    }

    int submitCalls() {
        return submitCalls;
    }

    int submitBatchCalls() {
        return submitBatchCalls;
    }

    /** Every request handed to submit or submitBatch, in order. */
    List<JudgeRequest> submitted() {
        return submitted;
    }

    @Override
    public JudgeResponse submit(JudgeRequest request) {
        submitCalls++;
        if (failure != null) throw failure;
        return token(request);
    }

    @Override
    public JudgeResponse getSubmission(String token) {
        return result(token);
    }

    @Override
    public List<JudgeResponse> submitBatch(List<JudgeRequest> requests) {
        submitBatchCalls++;
        if (failure != null) throw failure;
        return requests.stream().map(this::token).toList();
    }

    @Override
    public List<JudgeResponse> getBatch(List<String> tokens) {
        return tokens.stream().map(this::result).toList();
    }

    private JudgeResponse token(JudgeRequest request) {
        JudgeResponse scripted = responsesByStdin.get(request.stdin());
        if (scripted == null) {
            throw new IllegalStateException("No scripted response for stdin: " + request.stdin());
        }
        submitted.add(request);
        String token = "t" + submitted.size();
        responsesByToken.put(token, scripted);
        return new JudgeResponse(token, null, null, null, null, null, null);
    }

    private JudgeResponse result(String token) {
        JudgeResponse scripted = responsesByToken.get(token);
        return new JudgeResponse(token, scripted.status(), scripted.stdout(), scripted.stderr(),
                scripted.compileOutput(), scripted.time(), scripted.memory());
    }
}
