class Solution {
    public boolean canBeNonDecreasing(int[] nums) {
        int[] a = nums.clone();
        boolean changed = false;
        for (int i = 1; i < a.length; i++) {
            if (a[i] < a[i - 1]) {
                if (changed) return false;
                changed = true;
                if (i >= 2 && a[i] < a[i - 2]) a[i] = a[i - 1];
            }
        }
        return true;
    }
}
