class Solution {
    public int[][] selectNearestStops(int[][] stops, int k) {
        int[][] sorted = stops.clone();
        Arrays.sort(sorted, (a, b) -> Long.compare(
                (long) a[0] * a[0] + (long) a[1] * a[1],
                (long) b[0] * b[0] + (long) b[1] * b[1]));
        return Arrays.copyOf(sorted, k);
    }
}
