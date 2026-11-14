class Solution {
    cheapestRoute(n, links, src, dst, maxStops) {
        let cost = new Array(n).fill(Infinity);
        cost[src] = 0;
        for (let round = 0; round <= maxStops; round++) {
            const updated = cost.slice();
            for (const [from, to, price] of links) {
                if (cost[from] + price < updated[to]) updated[to] = cost[from] + price;
            }
            cost = updated;
        }
        return cost[dst] === Infinity ? -1 : cost[dst];
    }
}
