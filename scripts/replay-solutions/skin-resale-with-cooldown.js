class Solution {
    maxProfit(prices) {
        let holding = -Infinity, sold = 0, resting = 0;
        for (const price of prices) {
            [holding, sold, resting] = [Math.max(holding, resting - price), holding + price, Math.max(resting, sold)];
        }
        return Math.max(sold, resting);
    }
}
