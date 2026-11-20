class Solution {
    public int combineCounters(int firstCount, int secondCount) {
        int a = firstCount, b = secondCount;
        while (b != 0) {
            int carry = (a & b) << 1;
            a ^= b;
            b = carry;
        }
        return a;
    }
}
