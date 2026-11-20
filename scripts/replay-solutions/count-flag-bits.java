class Solution {
    public int[] tallyPriorityFlags(int upperId) {
        int[] counts = new int[upperId + 1];
        for (int i = 1; i <= upperId; i++) {
            // i & (i - 1) is i with its lowest 1 bit cleared: a smaller number, already counted.
            counts[i] = counts[i & (i - 1)] + 1;
        }
        return counts;
    }
}
