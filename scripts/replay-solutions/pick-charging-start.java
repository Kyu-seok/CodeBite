class Solution {
    public int pickStartStop(int[] energy, int[] drain) {
        long total = 0, tank = 0;
        int start = 0;
        for (int i = 0; i < energy.length; i++) {
            int gain = energy[i] - drain[i];
            total += gain;
            tank += gain;
            if (tank < 0) {
                start = i + 1;
                tank = 0;
            }
        }
        return total < 0 ? -1 : start;
    }
}
