import java.util.*;

class ClickTally {
    private final Deque<Integer> clicks = new ArrayDeque<>();

    public ClickTally() {
    }

    public void record(int timestamp) {
        clicks.addLast(timestamp);
    }

    public int countSince(int timestamp) {
        while (!clicks.isEmpty() && clicks.peekFirst() <= timestamp - 300) {
            clicks.pollFirst();
        }
        return clicks.size();
    }
}
