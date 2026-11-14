class Solution {
public:
    int countPalindromicSubstrings(string doodle) {
        int n = doodle.size(), count = 0;
        for (int center = 0; center < 2 * n - 1; center++) {
            int left = center / 2, right = (center + 1) / 2;
            while (left >= 0 && right < n && doodle[left] == doodle[right]) {
                count++;
                left--;
                right++;
            }
        }
        return count;
    }
};
