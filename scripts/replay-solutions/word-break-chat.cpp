class Solution {
public:
    bool canSplitMessage(string message, vector<string>& words) {
        int n = message.size();
        vector<bool> splittable(n + 1, false);
        splittable[0] = true;
        for (int end = 1; end <= n; end++) {
            for (const string& word : words) {
                int start = end - (int)word.size();
                if (start >= 0 && splittable[start] && message.compare(start, word.size(), word) == 0) {
                    splittable[end] = true;
                    break;
                }
            }
        }
        return splittable[n];
    }
};
