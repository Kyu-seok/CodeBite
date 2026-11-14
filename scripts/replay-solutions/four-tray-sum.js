class Solution {
    fourTraySum(trays, demand) {
        const nums = [...trays].sort((x, y) => x - y);
        const n = nums.length;
        const result = [];
        for (let a = 0; a < n - 3; a++) {
            if (a > 0 && nums[a] === nums[a - 1]) continue;
            for (let b = a + 1; b < n - 2; b++) {
                if (b > a + 1 && nums[b] === nums[b - 1]) continue;
                let low = b + 1, high = n - 1;
                while (low < high) {
                    const total = nums[a] + nums[b] + nums[low] + nums[high];
                    if (total < demand) low++;
                    else if (total > demand) high--;
                    else {
                        result.push([nums[a], nums[b], nums[low], nums[high]]);
                        low++;
                        while (low < high && nums[low] === nums[low - 1]) low++;
                        high--;
                    }
                }
            }
        }
        return result;
    }
}
