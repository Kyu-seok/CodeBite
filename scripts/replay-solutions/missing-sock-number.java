class Solution {
    public int smallestMissingNumber(int[] socks) {
        int n = socks.length;
        for (int i = 0; i < n; i++) {
            while (socks[i] >= 1 && socks[i] <= n && socks[socks[i] - 1] != socks[i]) {
                int home = socks[i] - 1;
                int moved = socks[home];
                socks[home] = socks[i];
                socks[i] = moved;
            }
        }
        for (int i = 0; i < n; i++) {
            if (socks[i] != i + 1) return i + 1;
        }
        return n + 1;
    }
}
