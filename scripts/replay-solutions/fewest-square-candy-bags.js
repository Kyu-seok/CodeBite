class Solution {
    fewestBags(candies) {
        const fewest = new Array(candies + 1).fill(0);
        for (let a = 1; a <= candies; a++) {
            fewest[a] = a;
            for (let s = 1; s * s <= a; s++) fewest[a] = Math.min(fewest[a], fewest[a - s * s] + 1);
        }
        return fewest[candies];
    }
}
