class Solution {
    powerSet(nums) {
        const out = [];
        for (let mask = 0; mask < (1 << nums.length); mask++) out.push(nums.filter((_, i) => mask >> i & 1));
        return out;
    }
}
