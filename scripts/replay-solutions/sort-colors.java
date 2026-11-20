class Solution {
    public void sortColors(int[] nums) {
        // Dutch national flag: 0s go before low, 2s after high.
        int low = 0, mid = 0, high = nums.length - 1;
        while (mid <= high) {
            if (nums[mid] == 0) {
                swap(nums, low++, mid++);
            } else if (nums[mid] == 2) {
                swap(nums, mid, high--);
            } else {
                mid++;
            }
        }
    }

    private void swap(int[] nums, int i, int j) {
        int held = nums[i];
        nums[i] = nums[j];
        nums[j] = held;
    }
}
