class Solution {
    public List<List<Integer>> listVoucherSums(int[] prices, int voucher) {
        int[] sorted = prices.clone();
        Arrays.sort(sorted);
        List<List<Integer>> baskets = new ArrayList<>();
        build(sorted, 0, voucher, new ArrayList<>(), baskets);
        return baskets;
    }

    private void build(int[] prices, int start, int remaining, List<Integer> basket, List<List<Integer>> baskets) {
        if (remaining == 0) {
            baskets.add(new ArrayList<>(basket));
            return;
        }
        for (int i = start; i < prices.length && prices[i] <= remaining; i++) {
            basket.add(prices[i]);
            build(prices, i, remaining - prices[i], basket, baskets);
            basket.remove(basket.size() - 1);
        }
    }
}
