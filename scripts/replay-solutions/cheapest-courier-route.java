class Solution {
    public int cheapestRoute(int n, int[][] links, int src, int dst, int maxStops) {
        long inf = Long.MAX_VALUE / 4;
        long[] cost = new long[n];
        Arrays.fill(cost, inf);
        cost[src] = 0;
        for (int round = 0; round <= maxStops; round++) {
            long[] updated = cost.clone();
            for (int[] link : links) {
                if (cost[link[0]] != inf && cost[link[0]] + link[2] < updated[link[1]]) {
                    updated[link[1]] = cost[link[0]] + link[2];
                }
            }
            cost = updated;
        }
        return cost[dst] == inf ? -1 : (int) cost[dst];
    }
}
