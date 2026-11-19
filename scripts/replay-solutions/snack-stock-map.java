class ChainedMap {
    private static final int BUCKETS = 2069;
    private final int[][] keys = new int[BUCKETS][];
    private final int[][] values = new int[BUCKETS][];
    private final int[] sizes = new int[BUCKETS];

    public ChainedMap() {
    }

    private int find(int b, int key) {
        for (int i = 0; i < sizes[b]; i++) {
            if (keys[b][i] == key) return i;
        }
        return -1;
    }

    public void set(int key, int value) {
        int b = key % BUCKETS;
        int i = find(b, key);
        if (i >= 0) {
            values[b][i] = value;
            return;
        }
        if (keys[b] == null) {
            keys[b] = new int[4];
            values[b] = new int[4];
        } else if (sizes[b] == keys[b].length) {
            keys[b] = java.util.Arrays.copyOf(keys[b], sizes[b] * 2);
            values[b] = java.util.Arrays.copyOf(values[b], sizes[b] * 2);
        }
        keys[b][sizes[b]] = key;
        values[b][sizes[b]] = value;
        sizes[b]++;
    }

    public int lookup(int key) {
        int b = key % BUCKETS;
        int i = find(b, key);
        return i >= 0 ? values[b][i] : -1;
    }

    public void erase(int key) {
        int b = key % BUCKETS;
        int i = find(b, key);
        if (i < 0) return;
        int last = --sizes[b];
        keys[b][i] = keys[b][last];
        values[b][i] = values[b][last];
    }
}
