class Solution {
    public int maxSnackHaul(int[] snacks) {
        int skipped = 0, taken = 0;
        for (int haul : snacks) {
            int nextTaken = skipped + haul;
            skipped = Math.max(skipped, taken);
            taken = nextTaken;
        }
        return Math.max(skipped, taken);
    }
}
