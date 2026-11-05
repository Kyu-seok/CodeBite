class Solution {
    listStationOrders(stops) {
        if (stops.length === 0) return [[]];
        return stops.flatMap((s, i) =>
            this.listStationOrders(stops.filter((_, j) => j !== i)).map(rest => [s, ...rest]));
    }
}
