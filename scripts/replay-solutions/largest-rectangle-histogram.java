class Solution {
    public int largestRectangleArea(int[] heights) {
        int best = 0;
        Deque<Integer> stack = new ArrayDeque<>();
        for (int i = 0; i <= heights.length; i++) {
            int height = i < heights.length ? heights[i] : 0;
            while (!stack.isEmpty() && heights[stack.peek()] >= height) {
                int top = heights[stack.pop()];
                int left = stack.isEmpty() ? 0 : stack.peek() + 1;
                best = Math.max(best, top * (i - left));
            }
            stack.push(i);
        }
        return best;
    }
}
