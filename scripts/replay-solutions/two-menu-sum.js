class Solution {
    findMenuPair(menuPrice, budget) {
        let left = 0, right = menuPrice.length - 1;
        while (left < right) {
            const total = menuPrice[left] + menuPrice[right];
            if (total === budget) return [left + 1, right + 1];
            if (total < budget) left++;
            else right--;
        }
        return [];
    }
}
