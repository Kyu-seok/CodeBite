class Solution {
    public int minHoseLength(int[][] bowls) {
        int n = bowls.length;
        long[] best = new long[n];
        Arrays.fill(best, Long.MAX_VALUE);
        best[0] = 0;
        boolean[] inTree = new boolean[n];
        long total = 0;
        for (int step = 0; step < n; step++) {
            int node = -1;
            for (int i = 0; i < n; i++) if (!inTree[i] && (node == -1 || best[i] < best[node])) node = i;
            inTree[node] = true;
            total += best[node];
            for (int i = 0; i < n; i++) if (!inTree[i]) {
                long cost = Math.abs((long) bowls[node][0] - bowls[i][0]) + Math.abs((long) bowls[node][1] - bowls[i][1]);
                if (cost < best[i]) best[i] = cost;
            }
        }
        return (int) total;
    }
}
