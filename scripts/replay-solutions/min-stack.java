class LowTrackStack {
    private final java.util.ArrayDeque<int[]> entries = new java.util.ArrayDeque<>();

    public LowTrackStack() {
    }

    public void push(int val) {
        int low = entries.isEmpty() ? val : Math.min(val, entries.peek()[1]);
        entries.push(new int[]{val, low});
    }

    public void pop() {
        entries.pop();
    }

    public int top() {
        return entries.peek()[0];
    }

    public int getMin() {
        return entries.peek()[1];
    }
}
