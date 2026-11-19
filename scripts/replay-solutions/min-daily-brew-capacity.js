class Solution {
    minDailyCapacity(volumes, days) {
        const daysNeeded = (capacity) => {
            let used = 1, load = 0;
            for (const v of volumes) {
                if (load + v > capacity) { used++; load = 0; }
                load += v;
            }
            return used;
        };
        let low = Math.max(...volumes), high = volumes.reduce((a, b) => a + b, 0);
        while (low < high) {
            const mid = Math.floor((low + high) / 2);
            if (daysNeeded(mid) <= days) high = mid; else low = mid + 1;
        }
        return low;
    }
}
