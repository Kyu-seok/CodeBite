class Solution {
    public long reverseFlags(long statusWord) {
        return Integer.reverse((int) statusWord) & 0xFFFFFFFFL;
    }
}
