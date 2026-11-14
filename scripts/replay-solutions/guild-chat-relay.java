import java.util.*;

class Solution {
    public int minutesToReachAll(int[][] links, int n, int src) {
        List<List<int[]>> graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) graph.add(new ArrayList<>());
        for (int[] link : links) graph.get(link[0]).add(new int[]{link[1], link[2]});
        int[] arrival = new int[n + 1];
        Arrays.fill(arrival, -1);
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
        heap.add(new int[]{0, src});
        int reached = 0, latest = 0;
        while (!heap.isEmpty()) {
            int[] top = heap.poll();
            if (arrival[top[1]] != -1) continue;
            arrival[top[1]] = top[0];
            reached++;
            latest = top[0];
            for (int[] edge : graph.get(top[1])) {
                if (arrival[edge[0]] == -1) heap.add(new int[]{top[0] + edge[1], edge[0]});
            }
        }
        return reached == n ? latest : -1;
    }
}
