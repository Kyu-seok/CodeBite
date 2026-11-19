class Solution {
    public List<List<Integer>> listVisitOrders(int[] stops) {
        List<List<Integer>> out = new ArrayList<>();
        build(stops, new boolean[stops.length], new ArrayList<>(), out);
        return out;
    }

    private void build(int[] stops, boolean[] used, List<Integer> chosen, List<List<Integer>> out) {
        if (chosen.size() == stops.length) {
            out.add(new ArrayList<>(chosen));
            return;
        }
        for (int i = 0; i < stops.length; i++) {
            if (used[i]) continue;
            used[i] = true;
            chosen.add(stops[i]);
            build(stops, used, chosen, out);
            chosen.remove(chosen.size() - 1);
            used[i] = false;
        }
    }
}
