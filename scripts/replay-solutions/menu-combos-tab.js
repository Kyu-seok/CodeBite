class Solution {
    listTabCombos(pastries, tab) {
        const prices = pastries.slice().sort((a, b) => a - b);
        const combos = [];
        const chosen = [];
        const pick = (start, remaining) => {
            if (remaining === 0) {
                combos.push(chosen.slice());
                return;
            }
            for (let i = start; i < prices.length && prices[i] <= remaining; i++) {
                if (i > start && prices[i] === prices[i - 1]) continue;
                chosen.push(prices[i]);
                pick(i + 1, remaining - prices[i]);
                chosen.pop();
            }
        };
        pick(0, tab);
        return combos;
    }
}
