class Solution {
    hasPrice(menu, target) {
        const cols = menu[0].length;
        let low = 0, high = menu.length * cols - 1;
        while (low <= high) {
            const mid = Math.floor((low + high) / 2);
            const value = menu[Math.floor(mid / cols)][mid % cols];
            if (value === target) return true;
            if (value < target) low = mid + 1;
            else high = mid - 1;
        }
        return false;
    }
}
