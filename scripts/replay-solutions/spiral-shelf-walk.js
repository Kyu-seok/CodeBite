class Solution {
    spiralOrder(shelf) {
        const result = [];
        let top = 0, bottom = shelf.length - 1, left = 0, right = shelf[0].length - 1;
        while (top <= bottom && left <= right) {
            for (let c = left; c <= right; c++) result.push(shelf[top][c]);
            for (let r = top + 1; r <= bottom; r++) result.push(shelf[r][right]);
            if (top < bottom) for (let c = right - 1; c >= left; c--) result.push(shelf[bottom][c]);
            if (left < right) for (let r = bottom - 1; r > top; r--) result.push(shelf[r][left]);
            top++; bottom--; left++; right--;
        }
        return result;
    }
}
