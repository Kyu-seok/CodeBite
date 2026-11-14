class Solution {
    public int[] findMenuPair(int[] menuPrice, int budget) {
        int left = 0, right = menuPrice.length - 1;
        while (left < right) {
            int total = menuPrice[left] + menuPrice[right];
            if (total == budget) return new int[] {left + 1, right + 1};
            if (total < budget) left++;
            else right--;
        }
        return new int[0];
    }
}
