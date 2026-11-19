class Solution {
public:
    int countLongestIncreasing(vector<int>& nums) {
        int n = nums.size();
        vector<int> length(n, 1); // longest increasing subsequence ending at i
        vector<int> count(n, 1);  // how many subsequences reach that length
        int longest = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < i; j++) {
                if (nums[j] < nums[i]) {
                    if (length[j] + 1 > length[i]) {
                        length[i] = length[j] + 1;
                        count[i] = count[j];
                    } else if (length[j] + 1 == length[i]) {
                        count[i] += count[j];
                    }
                }
            }
            longest = max(longest, length[i]);
        }
        int total = 0;
        for (int i = 0; i < n; i++) if (length[i] == longest) total += count[i];
        return total;
    }
};
