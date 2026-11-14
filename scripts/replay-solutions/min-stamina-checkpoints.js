class Solution {
    minStaminaToFinish(cost) {
        let twoBack = 0, oneBack = 0;
        for (let i = 2; i <= cost.length; i++) {
            [twoBack, oneBack] = [oneBack, Math.min(oneBack + cost[i - 1], twoBack + cost[i - 2])];
        }
        return oneBack;
    }
}
