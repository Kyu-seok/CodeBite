class Solution {
    public int maxSplitProduct(int length) {
        long[] best = new long[length + 1];
        best[1] = 1;
        for (int total = 2; total <= length; total++)
            for (int first = 1; first < total; first++)
                best[total] = Math.max(best[total], first * Math.max(total - first, best[total - first]));
        return (int) best[length];
    }
}
