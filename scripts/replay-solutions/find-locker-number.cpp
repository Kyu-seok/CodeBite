class Solution {
public:
    int findLocker(vector<int>& lockers, int target) {
        int low = 0, high = (int)lockers.size() - 1;
        while (low <= high) {
            int mid = low + (high - low) / 2;
            if (lockers[mid] == target) return mid;
            if (lockers[mid] < target) low = mid + 1;
            else high = mid - 1;
        }
        return -1;
    }
};
