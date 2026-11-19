class Solution {
public:
    bool canBeNonDecreasing(vector<int>& nums) {
        vector<int> a = nums;
        bool changed = false;
        for (int i = 1; i < (int)a.size(); i++) {
            if (a[i] < a[i - 1]) {
                if (changed) return false;
                changed = true;
                if (i >= 2 && a[i] < a[i - 2]) a[i] = a[i - 1];
            }
        }
        return true;
    }
};
