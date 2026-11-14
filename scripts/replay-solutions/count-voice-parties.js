class Solution {
    countParties(n, relays) {
        const parent = Array.from({ length: n }, (_, i) => i);
        const find = (x) => {
            while (parent[x] !== x) {
                parent[x] = parent[parent[x]];
                x = parent[x];
            }
            return x;
        };
        let parties = n;
        for (const [a, b] of relays) {
            const ra = find(a), rb = find(b);
            if (ra !== rb) {
                parent[ra] = rb;
                parties--;
            }
        }
        return parties;
    }
}
