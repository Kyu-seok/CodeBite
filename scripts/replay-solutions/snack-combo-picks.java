class Solution {
    public List<List<Integer>> listSnackCombos(int[] snacks) {
        int[] sorted = snacks.clone();
        Arrays.sort(sorted);
        List<List<Integer>> combos = new ArrayList<>();
        build(sorted, 0, new ArrayList<>(), combos);
        return combos;
    }

    private void build(int[] sorted, int start, List<Integer> combo, List<List<Integer>> combos) {
        combos.add(new ArrayList<>(combo));
        for (int i = start; i < sorted.length; i++) {
            if (i > start && sorted[i] == sorted[i - 1]) continue;
            combo.add(sorted[i]);
            build(sorted, i + 1, combo, combos);
            combo.remove(combo.size() - 1);
        }
    }
}
