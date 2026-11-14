class Solution {
    public int earliestCrossingTime(int[][] elevation) {
        int n = elevation.length;
        boolean[][] seen = new boolean[n][n];
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
        heap.add(new int[]{elevation[0][0], 0, 0});
        seen[0][0] = true;
        int highest = 0;
        int[][] steps = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        while (!heap.isEmpty()) {
            int[] top = heap.poll();
            highest = Math.max(highest, top[0]);
            if (top[1] == n - 1 && top[2] == n - 1) return highest;
            for (int[] s : steps) {
                int r = top[1] + s[0], c = top[2] + s[1];
                if (r >= 0 && r < n && c >= 0 && c < n && !seen[r][c]) {
                    seen[r][c] = true;
                    heap.add(new int[]{elevation[r][c], r, c});
                }
            }
        }
        return highest;
    }
}
