package com.codebite.problem.guarantee;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * find-battery-peak: {@code readings} with no two neighbours equal; any index whose reading beats
 * each neighbour that exists (the ends sit beside -infinity) is accepted. The Driver checks the
 * returned index and prints {@code VALID} for a peak. An input the constraints allow always has a
 * peak (its largest reading is one), so VALID is its one correct output.
 */
class FindBatteryPeakGuarantee implements ProblemGuarantee {

    @Override
    public String slug() {
        return "find-battery-peak";
    }

    @Override
    public List<String> inputViolations(CaseInput input) {
        long[] readings = input.integers(0);
        List<String> violations = new ArrayList<>();
        if (readings.length < 1 || readings.length > 2_000) {
            violations.add("readings.length " + readings.length + " outside 1..2000");
        }
        for (int i = 0; i < readings.length; i++) {
            if (Math.abs(readings[i]) > 100_000_000) violations.add("readings[" + i + "] = " + readings[i] + " outside ±10^8");
            if (i + 1 < readings.length && readings[i] == readings[i + 1]) {
                violations.add("readings[" + i + "] = readings[" + (i + 1) + "] = " + readings[i]);
            }
        }
        return violations;
    }

    @Override
    public Set<String> correctOutputs(CaseInput input) {
        return Set.of("VALID");
    }
}
