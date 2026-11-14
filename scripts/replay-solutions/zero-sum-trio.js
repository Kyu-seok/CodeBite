class Solution {
    zeroSumTrios(deltas) {
        const nums = [...deltas].sort((a, b) => a - b);
        const trios = [];
        for (let i = 0; i + 2 < nums.length; i++) {
            if (i > 0 && nums[i] === nums[i - 1]) continue;
            let left = i + 1, right = nums.length - 1;
            while (left < right) {
                const total = nums[i] + nums[left] + nums[right];
                if (total < 0) left++;
                else if (total > 0) right--;
                else {
                    trios.push([nums[i], nums[left], nums[right]]);
                    left++;
                    while (left < right && nums[left] === nums[left - 1]) left++;
                    right--;
                }
            }
        }
        return trios;
    }
}
