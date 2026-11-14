class Solution {
    public double mergedPriceMedian(int[] pricesA, int[] pricesB) {
        int[] merged = new int[pricesA.length + pricesB.length];
        int i = 0, j = 0, k = 0;
        while (i < pricesA.length || j < pricesB.length) {
            if (j == pricesB.length || (i < pricesA.length && pricesA[i] <= pricesB[j])) merged[k++] = pricesA[i++];
            else merged[k++] = pricesB[j++];
        }
        int n = merged.length;
        if (n % 2 == 1) return merged[n / 2];
        return (merged[n / 2 - 1] + (double) merged[n / 2]) / 2.0;
    }
}
