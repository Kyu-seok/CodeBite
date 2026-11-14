class Solution {
    public int pinpointPeak(int[] readings) {
        int lo = 0, hi = readings.length - 1;
        while (lo < hi) {
            int mid = (lo + hi) / 2;
            if (readings[mid] < readings[mid + 1]) lo = mid + 1;
            else hi = mid;
        }
        return lo;
    }
}
