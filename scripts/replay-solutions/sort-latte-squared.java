class Solution {
    public int[] sortedSquaredDrifts(int[] drifts) {
        int n = drifts.length;
        int[] out = new int[n];
        int lo = 0, hi = n - 1;
        for (int k = n - 1; k >= 0; k--) {
            int a = drifts[lo] * drifts[lo], b = drifts[hi] * drifts[hi];
            if (a > b) { out[k] = a; lo++; } else { out[k] = b; hi--; }
        }
        return out;
    }
}
