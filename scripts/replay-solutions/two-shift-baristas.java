class Solution {
    public boolean splitIntoTwoShifts(int[][] conflicts) {
        int n = conflicts.length;
        int[] shift = new int[n];
        java.util.Arrays.fill(shift, -1);
        for (int start = 0; start < n; start++) {
            if (shift[start] != -1) continue;
            shift[start] = 0;
            java.util.ArrayDeque<Integer> stack = new java.util.ArrayDeque<>();
            stack.push(start);
            while (!stack.isEmpty()) {
                int node = stack.pop();
                for (int other : conflicts[node]) {
                    if (shift[other] == -1) {
                        shift[other] = 1 - shift[node];
                        stack.push(other);
                    } else if (shift[other] == shift[node]) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
