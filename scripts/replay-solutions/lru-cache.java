
class LRUCache {
    private final int capacity;
    private final LinkedHashMap<Integer, Integer> entries = new LinkedHashMap<>(16, 0.75f, true);

    public LRUCache(int capacity) {
        this.capacity = capacity;
    }

    public int get(int key) {
        Integer v = entries.get(key);
        return v == null ? -1 : v;
    }

    public void put(int key, int value) {
        entries.put(key, value);
        if (entries.size() > capacity) {
            entries.remove(entries.keySet().iterator().next());
        }
    }
}
