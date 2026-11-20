class Solution {
    public int[][] mergeSeatingWindows(int[][] seatings) {
        int[][] sorted = seatings.clone();
        Arrays.sort(sorted, (a, b) -> a[0] != b[0] ? Integer.compare(a[0], b[0]) : Integer.compare(a[1], b[1]));
        List<int[]> merged = new ArrayList<>();
        for (int[] seating : sorted) {
            if (!merged.isEmpty() && seating[0] <= merged.get(merged.size() - 1)[1]) {
                int[] last = merged.get(merged.size() - 1);
                last[1] = Math.max(last[1], seating[1]);
            } else {
                merged.add(new int[] {seating[0], seating[1]});
            }
        }
        return merged.toArray(new int[0][]);
    }
}
