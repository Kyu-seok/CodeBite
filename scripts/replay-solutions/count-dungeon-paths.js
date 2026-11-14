class Solution {
    countPaths(rows, cols) {
        const ways = new Array(cols).fill(1);
        for (let r = 1; r < rows; r++) {
            for (let c = 1; c < cols; c++) ways[c] += ways[c - 1];
        }
        return ways[cols - 1];
    }
}
