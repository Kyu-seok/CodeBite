class Solution {
public:
    int longestGenreWindow(string feed) {
        vector<int> lastSeen(256, -1);
        int start = 0;
        int best = 0;
        for (int i = 0; i < (int) feed.size(); i++) {
            unsigned char tag = feed[i];
            if (lastSeen[tag] >= start) {
                start = lastSeen[tag] + 1;
            }
            lastSeen[tag] = i;
            best = max(best, i - start + 1);
        }
        return best;
    }
};
