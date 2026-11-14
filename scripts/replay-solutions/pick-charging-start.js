class Solution {
    pickStartStop(energy, drain) {
        let total = 0, tank = 0, start = 0;
        for (let i = 0; i < energy.length; i++) {
            const gain = energy[i] - drain[i];
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
