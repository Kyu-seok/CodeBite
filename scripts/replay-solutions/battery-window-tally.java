class Solution {
    public int countWindowTallies(int[] readings, int k) {
        Map<Long, Integer> seen = new HashMap<>();
        seen.put(0L, 1);
        long total = 0;
        int count = 0;
        for (int reading : readings) {
            total += reading;
            count += seen.getOrDefault(total - k, 0);
            seen.merge(total, 1, Integer::sum);
        }
        return count;
    }
}
