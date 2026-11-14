class Solution {
    public int nthUnlockableLevel(int n) {
        int[] levels = new int[n];
        levels[0] = 1;
        int i2 = 0, i3 = 0, i5 = 0;
        for (int k = 1; k < n; k++) {
            int next = Math.min(levels[i2] * 2, Math.min(levels[i3] * 3, levels[i5] * 5));
            levels[k] = next;
            if (next == levels[i2] * 2) i2++;
            if (next == levels[i3] * 3) i3++;
            if (next == levels[i5] * 5) i5++;
        }
        return levels[n - 1];
    }
}
