package com.codebite.problem.guarantee;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

/** Wrong find-battery-peak cases that {@link FindBatteryPeakGuarantee} rejects, one per way a case can go wrong. */
class FindBatteryPeakGuaranteeTest {

    private static final FindBatteryPeakGuarantee GUARANTEE = new FindBatteryPeakGuarantee();

    @ParameterizedTest(name = "{0}")
    @CsvSource(delimiter = '|', value = {
            "equal neighbours, so maybe no peak  | [4,4]",
            "a reading just above 10^8           | [1,100000001,2]",
            "a reading just below -10^8          | [-100000001,5]",
            "no readings                         | []",
    })
    void aBrokenInputIsCaught(String breakage, String input) {
        assertFalse(GUARANTEE.inputViolations(CaseInput.of(input)).isEmpty(), breakage);
    }

    @Test
    void moreThan2000ReadingsIsCaught() {
        StringBuilder readings = new StringBuilder("[0");
        for (int i = 1; i <= 2_000; i++) readings.append(',').append(i % 2);
        assertFalse(GUARANTEE.inputViolations(CaseInput.of(readings.append(']').toString())).isEmpty());
    }

    @Test
    void aCaseExpectingAnIndexIsCaught() {
        // ProblemGuaranteesTest accepts a case only when correctOutputs is exactly {expected}.
        assertNotEquals(Set.of("1"), GUARANTEE.correctOutputs(CaseInput.of("[1,3,1]")));
    }
}
