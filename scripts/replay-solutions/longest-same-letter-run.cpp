class Solution {
public:
    int longestSameLetterRun(string s, int k) {
        int counts[26] = {0};
        int start = 0, top = 0, best = 0;
        for (int end = 0; end < (int)s.size(); end++) {
            top = max(top, ++counts[s[end] - 'A']);
            while (end - start + 1 - top > k) {
                counts[s[start] - 'A']--;
                start++;
            }
            best = max(best, end - start + 1);
        }
        return best;
    }
};
