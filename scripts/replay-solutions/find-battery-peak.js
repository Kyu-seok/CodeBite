class Solution {
    pinpointPeak(readings) {
        let lo = 0, hi = readings.length - 1;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (readings[mid] < readings[mid + 1]) lo = mid + 1;
            else hi = mid;
        }
        return lo;
    }
}
