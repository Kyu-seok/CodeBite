
class TimestampedStore {
    private final Map<String, TreeMap<Integer, String>> history = new HashMap<>();

    public TimestampedStore() {
    }

    public void write(String key, String value, int timestamp) {
        history.computeIfAbsent(key, k -> new TreeMap<>()).put(timestamp, value);
    }

    public String readAt(String key, int timestamp) {
        TreeMap<Integer, String> writes = history.get(key);
        if (writes == null) return "";
        Map.Entry<Integer, String> e = writes.floorEntry(timestamp);
        return e == null ? "" : e.getValue();
    }
}
