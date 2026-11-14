class Solution {
    public List<List<Integer>> listTabCombos(int[] pastries, int tab) {
        int[] prices = pastries.clone();
        Arrays.sort(prices);
        List<List<Integer>> combos = new ArrayList<>();
        pick(prices, 0, tab, new ArrayList<>(), combos);
        return combos;
    }

    private void pick(int[] prices, int start, int remaining, List<Integer> chosen, List<List<Integer>> combos) {
        if (remaining == 0) {
            combos.add(new ArrayList<>(chosen));
            return;
        }
        for (int i = start; i < prices.length && prices[i] <= remaining; i++) {
            if (i > start && prices[i] == prices[i - 1]) continue;
            chosen.add(prices[i]);
            pick(prices, i + 1, remaining - prices[i], chosen, combos);
            chosen.remove(chosen.size() - 1);
        }
    }
}
