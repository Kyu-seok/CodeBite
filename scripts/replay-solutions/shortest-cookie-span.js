class Solution {
    shortestCookieSpan(trays, target) {
        let best = trays.length + 1, left = 0, total = 0;
        for (let right = 0; right < trays.length; right++) {
            total += trays[right];
            while (total >= target) {
                best = Math.min(best, right - left + 1);
                total -= trays[left++];
            }
        }
        return best <= trays.length ? best : 0;
    }
}
