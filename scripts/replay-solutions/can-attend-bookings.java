class Solution {
    public boolean verifyTableBookings(int[][] bookings) {
        int[][] sorted = bookings.clone();
        Arrays.sort(sorted, (a, b) -> Integer.compare(a[0], b[0]));
        for (int i = 1; i < sorted.length; i++) {
            if (sorted[i - 1][1] > sorted[i][0]) return false;
        }
        return true;
    }
}
