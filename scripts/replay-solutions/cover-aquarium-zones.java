class Solution {
    public int minPellets(int[][] zones) {
        int[][] sorted = zones.clone();
        java.util.Arrays.sort(sorted, (a, b) -> Integer.compare(a[1], b[1]));
        int pellets = 0;
        long lastDrop = Long.MIN_VALUE;
        for (int[] zone : sorted) {
            if (zone[0] > lastDrop) {
                pellets++;
                lastDrop = zone[1];
            }
        }
        return pellets;
    }
}
