import java.util.*;

class QueueFromStacks {
    private final Deque<Integer> inbox = new ArrayDeque<>();
    private final Deque<Integer> outbox = new ArrayDeque<>();

    public QueueFromStacks() {
    }

    public void push(int x) {
        inbox.push(x);
    }

    private void shift() {
        if (outbox.isEmpty()) {
            while (!inbox.isEmpty()) outbox.push(inbox.pop());
        }
    }

    public int pop() {
        shift();
        return outbox.pop();
    }

    public int peek() {
        shift();
        return outbox.peek();
    }

    public boolean empty() {
        return inbox.isEmpty() && outbox.isEmpty();
    }
}
