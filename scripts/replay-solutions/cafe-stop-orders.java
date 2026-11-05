class Solution {
    public List<List<Integer>> listStationOrders(int[] nums) {
        List<List<Integer>> out = new ArrayList<>();
        build(nums, new boolean[nums.length], new ArrayList<>(), out);
        return out;
    }

    private void build(int[] nums, boolean[] used, List<Integer> chosen, List<List<Integer>> out) {
        if (chosen.size() == nums.length) {
            out.add(new ArrayList<>(chosen));
            return;
        }
        for (int i = 0; i < nums.length; i++) {
            if (used[i]) continue;
            used[i] = true;
            chosen.add(nums[i]);
            build(nums, used, chosen, out);
            chosen.remove(chosen.size() - 1);
            used[i] = false;
        }
    }
}
