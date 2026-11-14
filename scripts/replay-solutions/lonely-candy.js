class Solution {
    findLonelyCandy(candies) {
        let loner = 0;
        for (const candy of candies) loner ^= candy;
        return loner;
    }
}
