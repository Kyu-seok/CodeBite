class Solution {
public:
    int longestRisingScores(vector<int>& scores) {
        // tails[k] is the smallest score that ends a strictly increasing subsequence of length k + 1.
        vector<int> tails;
        for (int score : scores) {
            int lo = 0, hi = tails.size();
            while (lo < hi) {
                int mid = (lo + hi) / 2;
                if (tails[mid] < score) lo = mid + 1; else hi = mid;
            }
            if (lo == (int) tails.size()) tails.push_back(score); else tails[lo] = score;
        }
        return tails.size();
    }
};
