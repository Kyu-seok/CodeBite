class Solution {
    public int crushHeaviestBlocks(int[] blocks) {
        PriorityQueue<Integer> pile = new PriorityQueue<>(Collections.reverseOrder());
        for (int b : blocks) pile.add(b);
        while (pile.size() > 1) {
            int y = pile.poll(), x = pile.poll();
            if (y != x) pile.add(y - x);
        }
        return pile.isEmpty() ? 0 : pile.peek();
    }
}
