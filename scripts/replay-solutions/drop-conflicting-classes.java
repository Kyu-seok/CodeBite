class Solution {
    public int dropClassConflicts(int[][] classes) {
        Arrays.sort(classes, (a, b) -> Integer.compare(a[1], b[1]));
        int dropped = 0;
        long end = Long.MIN_VALUE;
        for (int[] c : classes) {
            if (c[0] >= end) end = c[1];
            else dropped++;
        }
        return dropped;
    }
}
