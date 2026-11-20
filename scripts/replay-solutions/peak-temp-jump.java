class Solution {
    public int maxTempSwing(int[] readings) {
        int lowest = Integer.MAX_VALUE;
        int best = 0;
        for (int reading : readings) {
            lowest = Math.min(lowest, reading);
            best = Math.max(best, reading - lowest);
        }
        return best;
    }
}
