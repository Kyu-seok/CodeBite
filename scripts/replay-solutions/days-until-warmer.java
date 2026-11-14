class Solution {
    public int[] daysUntilWarmer(int[] readings) {
        int n = readings.length;
        int[] wait = new int[n];
        int[] pending = new int[n];
        int top = 0;
        for (int day = 0; day < n; day++) {
            while (top > 0 && readings[pending[top - 1]] < readings[day]) {
                int earlier = pending[--top];
                wait[earlier] = day - earlier;
            }
            pending[top++] = day;
        }
        return wait;
    }
}
