class Solution {
    listVisitOrders(stops) {
        if (stops.length === 0) return [[]];
        return stops.flatMap((s, i) =>
            this.listVisitOrders(stops.filter((_, j) => j !== i)).map(rest => [s, ...rest]));
    }
}
