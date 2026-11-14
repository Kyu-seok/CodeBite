class Solution {
    busiestMachines(checkIns, k) {
        const counts = new Map();
        for (const machine of checkIns) counts.set(machine, (counts.get(machine) || 0) + 1);
        return [...counts.keys()].sort((a, b) => counts.get(b) - counts.get(a)).slice(0, k);
    }
}
