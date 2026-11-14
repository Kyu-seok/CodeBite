class FixedRing {
    private final int[] slots;
    private int head = 0;
    private int size = 0;

    public FixedRing(int k) {
        slots = new int[k];
    }

    public boolean push(int value) {
        if (isFull()) return false;
        slots[(head + size) % slots.length] = value;
        size++;
        return true;
    }

    public boolean pull() {
        if (isEmpty()) return false;
        head = (head + 1) % slots.length;
        size--;
        return true;
    }

    public int front() {
        return isEmpty() ? -1 : slots[head];
    }

    public int rear() {
        return isEmpty() ? -1 : slots[(head + size - 1) % slots.length];
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public boolean isFull() {
        return size == slots.length;
    }
}
