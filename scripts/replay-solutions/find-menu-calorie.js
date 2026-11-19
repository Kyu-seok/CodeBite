class Solution {
    findCalorie(menu, target) {
        let row = 0, col = menu[0].length - 1;
        while (row < menu.length && col >= 0) {
            const value = menu[row][col];
            if (value === target) return true;
            if (value > target) col--; else row++;
        }
        return false;
    }
}
