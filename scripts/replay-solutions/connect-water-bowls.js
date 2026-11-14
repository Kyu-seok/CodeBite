class Solution {
    minHoseLength(bowls) {
        const n = bowls.length;
        const best = new Array(n).fill(Infinity);
        best[0] = 0;
        const inTree = new Array(n).fill(false);
        let total = 0;
        for (let step = 0; step < n; step++) {
            let node = -1;
            for (let i = 0; i < n; i++) if (!inTree[i] && (node === -1 || best[i] < best[node])) node = i;
            inTree[node] = true;
            total += best[node];
            for (let i = 0; i < n; i++) if (!inTree[i]) {
                const cost = Math.abs(bowls[node][0] - bowls[i][0]) + Math.abs(bowls[node][1] - bowls[i][1]);
                if (cost < best[i]) best[i] = cost;
            }
        }
        return total;
    }
}
