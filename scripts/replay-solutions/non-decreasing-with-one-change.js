class Solution {
    canBeNonDecreasing(nums) {
        const a = [...nums];
        let changed = false;
        for (let i = 1; i < a.length; i++) {
            if (a[i] < a[i - 1]) {
                if (changed) return false;
                changed = true;
                if (i >= 2 && a[i] < a[i - 2]) a[i] = a[i - 1];
            }
        }
        return true;
    }
}
