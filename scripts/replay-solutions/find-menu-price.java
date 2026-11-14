class Solution {
    public boolean hasPrice(int[][] menu, int target) {
        int cols = menu[0].length;
        int low = 0, high = menu.length * cols - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            int value = menu[mid / cols][mid % cols];
            if (value == target) return true;
            if (value < target) low = mid + 1;
            else high = mid - 1;
        }
        return false;
    }
}
