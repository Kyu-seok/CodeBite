package com.codebite.judge.parser;

import com.codebite.judge.dto.CodeError;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class UserCodeLineMapperTest {

    private final UserCodeLineMapper mapper = new UserCodeLineMapper();

    @Test
    void translatesInRangeCombinedLineToUserLine() {
        // Java driver: user code starts at combined line 3; buffer has 10 lines.
        CodeError input = new CodeError(5, 2, null, null, "msg", CodeError.Severity.ERROR, true);

        List<CodeError> out = mapper.mapToUserSpace(List.of(input), 3, 10);

        assertThat(out).hasSize(1);
        assertThat(out.get(0).line()).isEqualTo(3); // 5 - 3 + 1
        assertThat(out.get(0).column()).isEqualTo(2);
        assertThat(out.get(0).inUserCode()).isTrue();
    }

    @Test
    void collapsesAllDriverErrorsIntoSingleTemplateBanner() {
        // Both errors are above user-code start (driver territory).
        CodeError a = new CodeError(1, null, null, null, "a", CodeError.Severity.ERROR, true);
        CodeError b = new CodeError(2, null, null, null, "b", CodeError.Severity.ERROR, true);

        List<CodeError> out = mapper.mapToUserSpace(List.of(a, b), 3, 10);

        assertThat(out).hasSize(1);
        assertThat(out.get(0).inUserCode()).isFalse();
        assertThat(out.get(0).line()).isNull();
    }

    @Test
    void keepsUserErrorAndDropsDriverError() {
        CodeError driver = new CodeError(1, null, null, null, "driver", CodeError.Severity.ERROR, true);
        CodeError user = new CodeError(5, null, null, null, "user", CodeError.Severity.ERROR, true);

        List<CodeError> out = mapper.mapToUserSpace(List.of(driver, user), 3, 10);

        assertThat(out).hasSize(1);
        assertThat(out.get(0).message()).isEqualTo("user");
        assertThat(out.get(0).line()).isEqualTo(3);
    }

    @Test
    void returnsEmptyOnEmptyInput() {
        assertThat(mapper.mapToUserSpace(List.of(), 3, 10)).isEmpty();
        assertThat(mapper.mapToUserSpace(null, 3, 10)).isEmpty();
    }

    @Test
    void treatsErrorBeyondUserCodeAsDriver() {
        CodeError beyond = new CodeError(100, null, null, null, "late", CodeError.Severity.ERROR, true);

        List<CodeError> out = mapper.mapToUserSpace(List.of(beyond), 3, 10);

        assertThat(out).hasSize(1);
        assertThat(out.get(0).inUserCode()).isFalse();
    }
}
