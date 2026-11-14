class Solution {
    spaceBakes(cookies) {
        const n = cookies.length;
        const counts = {};
        for (const c of cookies) counts[c] = (counts[c] || 0) + 1;
        const kinds = Object.keys(counts).sort((a, b) => counts[b] - counts[a] || (a < b ? -1 : 1));
        if (counts[kinds[0]] > Math.floor((n + 1) / 2)) return "";
        const result = new Array(n);
        let slot = 0;
        for (const kind of kinds) {
            for (let k = 0; k < counts[kind]; k++) {
                if (slot >= n) slot = 1;
                result[slot] = kind;
                slot += 2;
            }
        }
        return result.join("");
    }
}
