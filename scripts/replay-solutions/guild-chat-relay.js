class Solution {
    minutesToReachAll(links, n, src) {
        const arrival = new Array(n + 1).fill(Infinity);
        arrival[src] = 0;
        const done = new Array(n + 1).fill(false);
        for (let round = 0; round < n; round++) {
            let player = -1;
            for (let p = 1; p <= n; p++) {
                if (!done[p] && (player === -1 || arrival[p] < arrival[player])) player = p;
            }
            if (arrival[player] === Infinity) return -1;
            done[player] = true;
            for (const [source, target, minutes] of links) {
                if (source === player && arrival[player] + minutes < arrival[target]) {
                    arrival[target] = arrival[player] + minutes;
                }
            }
        }
        return Math.max(...arrival.slice(1));
    }
}
