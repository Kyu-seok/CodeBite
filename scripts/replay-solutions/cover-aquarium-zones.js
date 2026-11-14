class Solution {
    minPellets(zones) {
        const sorted = [...zones].sort((a, b) => a[1] - b[1]);
        let pellets = 0;
        let lastDrop = -Infinity;
        for (const [start, end] of sorted) {
            if (start > lastDrop) {
                pellets++;
                lastDrop = end;
            }
        }
        return pellets;
    }
}
