class TopKStream {
    private final int k;
    private final PriorityQueue<Integer> heap = new PriorityQueue<>();

    public TopKStream(int k, int[] scores) {
        this.k = k;
        for (int score : scores) {
            heap.add(score);
            if (heap.size() > k) heap.poll();
        }
    }

    public int record(int val) {
        heap.add(val);
        if (heap.size() > k) heap.poll();
        return heap.peek();
    }
}
