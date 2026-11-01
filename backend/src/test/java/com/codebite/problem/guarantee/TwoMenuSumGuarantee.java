package com.codebite.problem.guarantee;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

/**
 * two-menu-sum: a sorted 1-indexed {@code menuPrice} and a {@code budget}; exactly one pair of
 * different items sums to the budget, printed {@code [item1,item2]} with item1 &lt; item2.
 */
class TwoMenuSumGuarantee implements ProblemGuarantee {

    @Override
    public String slug() {
        return "two-menu-sum";
    }

    @Override
    public List<String> inputViolations(CaseInput input) {
        long[] prices = input.integers(0);
        long budget = input.integer(1);
        List<String> violations = new ArrayList<>();
        if (prices.length < 2 || prices.length > 200_000) violations.add("menuPrice.length " + prices.length + " outside 2..2*10^5");
        for (int i = 0; i < prices.length; i++) {
            if (Math.abs(prices[i]) > 100_000_000) violations.add("menuPrice[" + i + "] = " + prices[i] + " outside ±10^8");
            if (i > 0 && prices[i] < prices[i - 1]) violations.add("menuPrice not sorted at index " + i);
        }
        if (Math.abs(budget) > 200_000_000) violations.add("budget " + budget + " outside ±2*10^8");
        return violations;
    }

    @Override
    public Set<String> correctOutputs(CaseInput input) {
        long[] prices = input.integers(0);
        long budget = input.integer(1);
        Set<String> outputs = new TreeSet<>();
        for (int i = 0; i < prices.length; i++) {
            for (int j = i + 1; j < prices.length; j++) {
                if (prices[i] + prices[j] == budget) outputs.add("[" + (i + 1) + "," + (j + 1) + "]");
            }
        }
        return outputs;
    }
}
