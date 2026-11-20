import java.util.*;

class Solution {
    public List<List<Integer>> traceDualDrainage(int[][] field) {
        List<List<Integer>> both = new ArrayList<>();
        if (field.length == 0 || field[0].length == 0) return both;
        int rows = field.length, cols = field[0].length;
        boolean[][] topLeft = new boolean[rows][cols];
        boolean[][] bottomRight = new boolean[rows][cols];
        Deque<int[]> stack = new ArrayDeque<>();
        for (int c = 0; c < cols; c++) stack.push(new int[] {0, c});
        for (int r = 0; r < rows; r++) stack.push(new int[] {r, 0});
        climb(field, stack, topLeft);
        for (int c = 0; c < cols; c++) stack.push(new int[] {rows - 1, c});
        for (int r = 0; r < rows; r++) stack.push(new int[] {r, cols - 1});
        climb(field, stack, bottomRight);
        for (int r = 0; r < rows; r++) {
            for (int c = 0; c < cols; c++) {
                if (topLeft[r][c] && bottomRight[r][c]) both.add(Arrays.asList(r, c));
            }
        }
        return both;
    }

    private void climb(int[][] field, Deque<int[]> stack, boolean[][] seen) {
        int rows = field.length, cols = field[0].length;
        for (int[] start : stack) seen[start[0]][start[1]] = true;
        int[][] steps = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};
        while (!stack.isEmpty()) {
            int[] cell = stack.pop();
            for (int[] step : steps) {
                int nr = cell[0] + step[0], nc = cell[1] + step[1];
                if (nr >= 0 && nr < rows && nc >= 0 && nc < cols && !seen[nr][nc]
                        && field[nr][nc] >= field[cell[0]][cell[1]]) {
                    seen[nr][nc] = true;
                    stack.push(new int[] {nr, nc});
                }
            }
        }
    }
}
