class Solution {
    spotRedundantLink(links) {
        const parent = Array.from({ length: links.length + 1 }, (_, i) => i);
        const find = x => {
            while (parent[x] !== x) {
                parent[x] = parent[parent[x]];
                x = parent[x];
            }
            return x;
        };
        for (const [a, b] of links) {
            const rootA = find(a), rootB = find(b);
            if (rootA === rootB) return [a, b];
            parent[rootA] = rootB;
        }
        return [];
    }
}
