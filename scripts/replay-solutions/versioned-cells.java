class VersionedCells {
    private final java.util.List<java.util.TreeMap<Integer, Integer>> history = new java.util.ArrayList<>();
    private int snapId = 0;

    public VersionedCells(int length) {
        for (int i = 0; i < length; i++) {
            java.util.TreeMap<Integer, Integer> cell = new java.util.TreeMap<>();
            cell.put(-1, 0);
            history.add(cell);
        }
    }

    public void set(int index, int val) {
        history.get(index).put(snapId, val);
    }

    public int commit() {
        return snapId++;
    }

    public int readAt(int index, int snapId) {
        return history.get(index).floorEntry(snapId).getValue();
    }
}
