class Solution {
    public int fewestBags(int[] bagSizes, int quota) {
        int unreachable = quota + 1;
        int[] fewest = new int[quota + 1];
        java.util.Arrays.fill(fewest, unreachable);
        fewest[0] = 0;
        for (int total = 1; total <= quota; total++) {
            for (int size : bagSizes) {
                if (size <= total && fewest[total - size] + 1 < fewest[total]) {
                    fewest[total] = fewest[total - size] + 1;
                }
            }
        }
        return fewest[quota] == unreachable ? -1 : fewest[quota];
    }
}
