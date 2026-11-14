class Solution {
    public int minEatingRate(int[] piles, int hours) {
        int low = 1, high = 1;
        for (int pile : piles) high = Math.max(high, pile);
        while (low < high) {
            int rate = low + (high - low) / 2;
            long needed = 0;
            for (int pile : piles) needed += (pile + (long) rate - 1) / rate;
            if (needed <= hours) high = rate;
            else low = rate + 1;
        }
        return low;
    }
}
