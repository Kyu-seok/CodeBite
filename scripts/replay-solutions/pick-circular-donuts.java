class Solution {
    public int maxTastiness(int[] tastiness) {
        int n = tastiness.length;
        if (n == 1) return tastiness[0];
        // The first and last are neighbours, so leave out one of them.
        return Math.max(bestInLine(tastiness, 1, n), bestInLine(tastiness, 0, n - 1));
    }

    private int bestInLine(int[] values, int from, int to) {
        int skip = 0, take = 0;
        for (int i = from; i < to; i++) {
            int nextTake = skip + values[i];
            skip = Math.max(skip, take);
            take = nextTake;
        }
        return Math.max(skip, take);
    }
}
