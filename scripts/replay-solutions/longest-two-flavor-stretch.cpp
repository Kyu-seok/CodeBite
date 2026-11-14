#include <unordered_map>

class Solution {
public:
    int longestTwoFlavorStretch(vector<int>& treats) {
        unordered_map<int, int> count; // treats of each flavor in treats[left..right]
        int best = 0, left = 0;
        for (int right = 0; right < (int) treats.size(); right++) {
            count[treats[right]]++;
            while (count.size() > 2) {
                int out = treats[left++];
                if (--count[out] == 0) count.erase(out);
            }
            best = max(best, right - left + 1);
        }
        return best;
    }
};
