class Solution {
    public List<Integer> spiralOrder(int[][] shelf) {
        List<Integer> result = new ArrayList<>();
        int top = 0, bottom = shelf.length - 1, left = 0, right = shelf[0].length - 1;
        while (top <= bottom && left <= right) {
            for (int c = left; c <= right; c++) result.add(shelf[top][c]);
            for (int r = top + 1; r <= bottom; r++) result.add(shelf[r][right]);
            if (top < bottom) for (int c = right - 1; c >= left; c--) result.add(shelf[bottom][c]);
            if (left < right) for (int r = bottom - 1; r > top; r--) result.add(shelf[r][left]);
            top++; bottom--; left++; right--;
        }
        return result;
    }
}
