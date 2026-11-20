class Solution {
    public int findVacantSlot(int[] lockers) {
        // Every number 0..n is XORed in once from the range and once from the list, except the
        // missing one, so the pairs cancel (x ^ x = 0) and only it is left.
        int missing = lockers.length;
        for (int i = 0; i < lockers.length; i++) {
            missing ^= i ^ lockers[i];
        }
        return missing;
    }
}
