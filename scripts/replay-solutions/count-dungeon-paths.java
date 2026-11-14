class Solution {
    public int countPaths(int rows, int cols) {
        int[] ways = new int[cols];
        Arrays.fill(ways, 1);
        for (int r = 1; r < rows; r++) {
            for (int c = 1; c < cols; c++) ways[c] += ways[c - 1];
        }
        return ways[cols - 1];
    }
}
