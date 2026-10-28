package com.codebite.submission.event;

import com.codebite.submission.entity.SubmissionStatus;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;

import static org.assertj.core.api.Assertions.assertThat;

class ResultScopeTest {

    private static SubmissionResultEvent event(SubmissionStatus status, boolean admin) {
        return new SubmissionResultEvent(1L, 7L, 42L, status, 10, 100, "python", admin);
    }

    @Test
    void acceptedUsersTakesOnlyAcceptedNonAdminVerdicts() {
        assertThat(ResultScope.ACCEPTED_USERS.test(event(SubmissionStatus.ACCEPTED, false))).isTrue();
        assertThat(ResultScope.ACCEPTED_USERS.test(event(SubmissionStatus.ACCEPTED, true))).isFalse();
        assertThat(ResultScope.ACCEPTED_USERS.test(event(SubmissionStatus.WRONG_ANSWER, false))).isFalse();
    }

    @Test
    void acceptedAllTakesAdminsToo() {
        assertThat(ResultScope.ACCEPTED_ALL.test(event(SubmissionStatus.ACCEPTED, false))).isTrue();
        assertThat(ResultScope.ACCEPTED_ALL.test(event(SubmissionStatus.ACCEPTED, true))).isTrue();
        assertThat(ResultScope.ACCEPTED_ALL.test(event(SubmissionStatus.WRONG_ANSWER, true))).isFalse();
    }

    @ParameterizedTest
    @EnumSource(SubmissionStatus.class)
    void onlyAcceptedCountsAsAcceptedWhateverTheStatus(SubmissionStatus status) {
        boolean accepted = status == SubmissionStatus.ACCEPTED;

        assertThat(ResultScope.ACCEPTED_USERS.test(event(status, false))).isEqualTo(accepted);
        assertThat(ResultScope.ACCEPTED_ALL.test(event(status, true))).isEqualTo(accepted);
    }

    @ParameterizedTest
    @EnumSource(SubmissionStatus.class)
    void allTakesEveryVerdict(SubmissionStatus status) {
        assertThat(ResultScope.ALL.test(event(status, false))).isTrue();
        assertThat(ResultScope.ALL.test(event(status, true))).isTrue();
    }
}
