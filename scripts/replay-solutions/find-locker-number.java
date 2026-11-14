class Solution {
    public int findLocker(int[] lockers, int target) {
        int low = 0, high = lockers.length - 1;
        while (low <= high) {
            int mid = (low + high) >>> 1;
            if (lockers[mid] == target) return mid;
            if (lockers[mid] < target) low = mid + 1;
            else high = mid - 1;
        }
        return -1;
    }
}
