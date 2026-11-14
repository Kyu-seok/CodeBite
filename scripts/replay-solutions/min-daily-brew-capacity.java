class Solution {
    public int minDailyCapacity(int[] volumes, int days) {
        int low = 0, high = 0;
        for (int v : volumes) { low = Math.max(low, v); high += v; }
        while (low < high) {
            int mid = (low + high) / 2;
            if (daysNeeded(volumes, mid) <= days) high = mid; else low = mid + 1;
        }
        return low;
    }

    private int daysNeeded(int[] volumes, int capacity) {
        int used = 1, load = 0;
        for (int v : volumes) {
            if (load + v > capacity) { used++; load = 0; }
            load += v;
        }
        return used;
    }
}
