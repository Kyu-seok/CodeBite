import java.util.*;

class Solution {
    public boolean checkKeyReachability(List<List<Integer>> rooms) {
        boolean[] visited = new boolean[rooms.size()];
        visited[0] = true;
        int count = 1;
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(0);
        while (!stack.isEmpty()) {
            for (int key : rooms.get(stack.pop())) {
                if (!visited[key]) {
                    visited[key] = true;
                    count++;
                    stack.push(key);
                }
            }
        }
        return count == rooms.size();
    }
}
