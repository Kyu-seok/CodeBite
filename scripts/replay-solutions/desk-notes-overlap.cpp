class Solution {
public:
    int longestCommonSubsequence(string left, string right) {
        vector<int> previous(right.size() + 1, 0);
        for (char a : left) {
            vector<int> current(right.size() + 1, 0);
            for (size_t j = 0; j < right.size(); j++) {
                current[j + 1] = a == right[j] ? previous[j] + 1 : max(previous[j + 1], current[j]);
            }
            previous = current;
        }
        return previous[right.size()];
    }
};
