class Solution {
    canSplitEqually(tickets) {
        const total = tickets.reduce((a, b) => a + b, 0);
        if (total % 2 !== 0) return false;
        const half = total / 2;
        const reachable = new Array(half + 1).fill(false);
        reachable[0] = true;
        for (const t of tickets)
            for (let s = half; s >= t; s--)
                if (reachable[s - t]) reachable[s] = true;
        return reachable[half];
    }
}
