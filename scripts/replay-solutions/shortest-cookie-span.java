class Solution {
    public int shortestCookieSpan(int[] trays, int target) {
        int best = trays.length + 1, left = 0;
        long total = 0;
        for (int right = 0; right < trays.length; right++) {
            total += trays[right];
            while (total >= target) {
                best = Math.min(best, right - left + 1);
                total -= trays[left++];
            }
        }
        return best <= trays.length ? best : 0;
    }
}
