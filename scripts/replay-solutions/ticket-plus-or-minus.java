import java.util.*;

class Solution {
    public int countSignAssignments(int[] tickets, int target) {
        Map<Integer, Integer> ways = new HashMap<>();
        ways.put(0, 1);
        for (int value : tickets) {
            Map<Integer, Integer> following = new HashMap<>();
            for (Map.Entry<Integer, Integer> e : ways.entrySet()) {
                following.merge(e.getKey() + value, e.getValue(), Integer::sum);
                following.merge(e.getKey() - value, e.getValue(), Integer::sum);
            }
            ways = following;
        }
        return ways.getOrDefault(target, 0);
    }
}
