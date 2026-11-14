class Solution {
    resolvePriceRatios(ratios, values, queries) {
        const graph = new Map();
        ratios.forEach(([a, b], i) => {
            if (!graph.has(a)) graph.set(a, []);
            if (!graph.has(b)) graph.set(b, []);
            graph.get(a).push([b, values[i]]);
            graph.get(b).push([a, 1 / values[i]]);
        });
        return queries.map(([from, to]) => {
            if (!graph.has(from) || !graph.has(to)) return -1;
            const seen = new Map([[from, 1]]);
            const stack = [from];
            while (stack.length) {
                const item = stack.pop();
                if (item === to) return seen.get(item);
                for (const [next, w] of graph.get(item)) {
                    if (!seen.has(next)) { seen.set(next, seen.get(item) * w); stack.push(next); }
                }
            }
            return -1;
        });
    }
}
