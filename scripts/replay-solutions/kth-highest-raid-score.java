import java.util.PriorityQueue;

class Solution {
    public int kthHighestScore(int[] scores, int k) {
        // A min-heap of the k highest scores seen so far: its top is the k-th highest.
        PriorityQueue<Integer> top = new PriorityQueue<>();
        for (int score : scores) {
            top.add(score);
            if (top.size() > k) top.poll();
        }
        return top.peek();
    }
}
