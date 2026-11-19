class Solution {
    public int maxProfit(int[] prices) {
        int holding = Integer.MIN_VALUE / 2, sold = 0, resting = 0;
        for (int price : prices) {
            int h = Math.max(holding, resting - price);
            int s = holding + price;
            int r = Math.max(resting, sold);
            holding = h; sold = s; resting = r;
        }
        return Math.max(sold, resting);
    }
}
