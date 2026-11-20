class Solution {
    public int spotCatalogTarget(int[] catalog, int target) {
        int low = 0, high = catalog.length - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            if (catalog[mid] == target) return mid;
            if (catalog[low] <= catalog[mid]) { // left half is sorted
                if (catalog[low] <= target && target < catalog[mid]) {
                    high = mid - 1;
                } else {
                    low = mid + 1;
                }
            } else { // right half is sorted
                if (catalog[mid] < target && target <= catalog[high]) {
                    low = mid + 1;
                } else {
                    high = mid - 1;
                }
            }
        }
        return -1;
    }
}
