class StreamMedian {
    private final java.util.PriorityQueue<Integer> low = new java.util.PriorityQueue<>(java.util.Collections.reverseOrder());
    private final java.util.PriorityQueue<Integer> high = new java.util.PriorityQueue<>();

    public StreamMedian() {
    }

    public void record(int num) {
        low.add(num);
        high.add(low.poll());
        if (high.size() > low.size()) low.add(high.poll());
    }

    public double median() {
        if (low.size() > high.size()) return low.peek();
        return (low.peek() + (double) high.peek()) / 2.0;
    }
}
