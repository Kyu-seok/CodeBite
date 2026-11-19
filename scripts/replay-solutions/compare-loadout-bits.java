class Solution {
    public int countFlagMismatches(int leftFlags, int rightFlags) {
        return Integer.bitCount(leftFlags ^ rightFlags);
    }
}
