package com.codebite.judge.service;

import com.codebite.common.exception.JudgeExecutionException;
import com.codebite.judge.client.JudgeClient;
import com.codebite.judge.dto.JudgeRequest;
import com.codebite.judge.dto.JudgeResponse;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

class JudgeServiceExecuteBatchTest {

    private static final int LANGUAGE_ID = 62;
    private static final String SOURCE = "class Solution {}";

    private static JudgeResponse token(String t) {
        return new JudgeResponse(t, null, null, null, null, null, null);
    }

    private static JudgeResponse running(String t) {
        return new JudgeResponse(t, new JudgeResponse.Status(2, "Processing"), null, null, null, null, null);
    }

    private static JudgeResponse done(String t, String stdout) {
        return new JudgeResponse(t, new JudgeResponse.Status(3, "Accepted"), stdout, null, null, "0.01", 1024);
    }

    @Test
    void returnsEmptyWhenNoStdins() {
        JudgeClient client = mock(JudgeClient.class);
        JudgeService service = new JudgeService(client, 1, 1000);

        List<JudgeResponse> results = service.executeBatch(SOURCE, LANGUAGE_ID, List.of());

        assertThat(results).isEmpty();
        verify(client, times(0)).submitBatch(anyList());
    }

    @Test
    void submitsBatchAndReturnsResultsWhenAllTerminalOnFirstPoll() {
        JudgeClient client = mock(JudgeClient.class);
        when(client.submitBatch(anyList())).thenReturn(List.of(token("t1"), token("t2")));
        when(client.getBatch(List.of("t1", "t2"))).thenReturn(List.of(done("t1", "a"), done("t2", "b")));

        JudgeService service = new JudgeService(client, 1, 1000);
        List<JudgeResponse> results = service.executeBatch(SOURCE, LANGUAGE_ID, List.of("in1", "in2"));

        assertThat(results).extracting(JudgeResponse::stdout).containsExactly("a", "b");
        verify(client, times(1)).submitBatch(anyList());
        verify(client, times(1)).getBatch(List.of("t1", "t2"));
    }

    @Test
    void pollsUntilEveryResultIsTerminal() {
        JudgeClient client = mock(JudgeClient.class);
        when(client.submitBatch(anyList())).thenReturn(List.of(token("t1"), token("t2")));
        when(client.getBatch(List.of("t1", "t2")))
                // First poll: t1 still running, t2 done -> keep polling
                .thenReturn(List.of(running("t1"), done("t2", "b")))
                // Second poll: both done -> return
                .thenReturn(List.of(done("t1", "a"), done("t2", "b")));

        JudgeService service = new JudgeService(client, 1, 1000);
        List<JudgeResponse> results = service.executeBatch(SOURCE, LANGUAGE_ID, List.of("in1", "in2"));

        assertThat(results).extracting(JudgeResponse::stdout).containsExactly("a", "b");
        verify(client, times(2)).getBatch(List.of("t1", "t2"));
    }

    @Test
    void throwsWhenSubmitReturnsFewerTokensThanRequested() {
        JudgeClient client = mock(JudgeClient.class);
        when(client.submitBatch(anyList())).thenReturn(List.of(token("t1")));

        JudgeService service = new JudgeService(client, 1, 1000);

        assertThatThrownBy(() -> service.executeBatch(SOURCE, LANGUAGE_ID, List.of("in1", "in2")))
                .isInstanceOf(JudgeExecutionException.class)
                .hasMessageContaining("Judge0 batch submit returned 1 tokens but 2 were requested");
    }

    @Test
    void throwsWhenPollingExceedsTimeout() {
        JudgeClient client = mock(JudgeClient.class);
        when(client.submitBatch(anyList())).thenReturn(List.of(token("t1")));
        when(client.getBatch(List.of("t1"))).thenReturn(List.of(running("t1")));

        // pollIntervalMs=1, pollTimeoutMs=5: a handful of polls then timeout
        JudgeService service = new JudgeService(client, 1, 5);

        assertThatThrownBy(() -> service.executeBatch(SOURCE, LANGUAGE_ID, List.of("in1")))
                .isInstanceOf(JudgeExecutionException.class)
                .hasMessageContaining("Judge0 batch timed out");
    }

    @Test
    void buildsBatchRequestsWithGivenSourceAndLanguageForEachStdin() {
        JudgeClient client = mock(JudgeClient.class);
        when(client.submitBatch(anyList())).thenReturn(List.of(token("t1"), token("t2"), token("t3")));
        when(client.getBatch(anyList())).thenReturn(
                List.of(done("t1", "a"), done("t2", "b"), done("t3", "c")));

        JudgeService service = new JudgeService(client, 1, 1000);
        service.executeBatch(SOURCE, LANGUAGE_ID, List.of("in1", "in2", "in3"));

        @SuppressWarnings("unchecked")
        org.mockito.ArgumentCaptor<List<JudgeRequest>> captor =
                org.mockito.ArgumentCaptor.forClass(List.class);
        verify(client).submitBatch(captor.capture());
        List<JudgeRequest> sent = captor.getValue();
        assertThat(sent).hasSize(3);
        assertThat(sent).allMatch(r -> r.sourceCode().equals(SOURCE) && r.languageId() == LANGUAGE_ID);
        assertThat(sent).extracting(JudgeRequest::stdin).containsExactly("in1", "in2", "in3");
    }
}
