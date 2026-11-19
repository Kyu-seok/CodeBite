class Solution {
    public List<List<Integer>> zeroSumTrios(int[] deltas) {
        int[] nums = deltas.clone();
        Arrays.sort(nums);
        List<List<Integer>> trios = new ArrayList<>();
        for (int i = 0; i + 2 < nums.length; i++) {
            if (i > 0 && nums[i] == nums[i - 1]) continue;
            int left = i + 1, right = nums.length - 1;
            while (left < right) {
                long total = (long) nums[i] + nums[left] + nums[right];
                if (total < 0) left++;
                else if (total > 0) right--;
                else {
                    trios.add(Arrays.asList(nums[i], nums[left], nums[right]));
                    left++;
                    while (left < right && nums[left] == nums[left - 1]) left++;
                    right--;
                }
            }
        }
        return trios;
    }
}
