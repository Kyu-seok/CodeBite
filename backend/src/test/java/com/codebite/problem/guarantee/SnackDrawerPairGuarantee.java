package com.codebite.problem.guarantee;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

/**
 * snack-drawer-pair: an unsorted 0-indexed {@code snacks} and a {@code target}; exactly one pair of
 * different snacks sums to the target, printed {@code [i,j]} with i &lt; j (the Driver orders them).
 */
class SnackDrawerPairGuarantee implements ProblemGuarantee {

    @Override
    public String slug() {
        return "snack-drawer-pair";
    }

    @Override
    public List<String> inputViolations(CaseInput input) {
        long[] snacks = input.integers(0);
        long target = input.integer(1);
        List<String> violations = new ArrayList<>();
        if (snacks.length < 2 || snacks.length > 80_000) violations.add("snacks.length " + snacks.length + " outside 2..80000");
        for (int i = 0; i < snacks.length; i++) {
            if (Math.abs(snacks[i]) > 100_000_000) violations.add("snacks[" + i + "] = " + snacks[i] + " outside ±10^8");
        }
        if (Math.abs(target) > 100_000_000) violations.add("target " + target + " outside ±10^8");
        return violations;
    }

    @Override
    public Set<String> correctOutputs(CaseInput input) {
        long[] snacks = input.integers(0);
        long target = input.integer(1);
        Set<String> outputs = new TreeSet<>();
        for (int i = 0; i < snacks.length; i++) {
            for (int j = i + 1; j < snacks.length; j++) {
                if (snacks[i] + snacks[j] == target) outputs.add("[" + i + "," + j + "]");
            }
        }
        return outputs;
    }
}
