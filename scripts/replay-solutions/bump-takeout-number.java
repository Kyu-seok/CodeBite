class Solution {
    public int[] bumpParcelCode(int[] digits) {
        int[] result = digits.clone();
        for (int i = result.length - 1; i >= 0; i--) {
            if (result[i] < 9) {
                result[i]++;
                return result;
            }
            result[i] = 0;
        }
        int[] longer = new int[result.length + 1];
        longer[0] = 1;
        return longer;
    }
}
