class Solution {
public:
    vector<int> splitStickerRuns(string stickers) {
        int last[26] = {0};
        for (int i = 0; i < (int) stickers.size(); i++) last[stickers[i] - 'a'] = i;
        vector<int> sizes;
        int start = 0, end = 0;
        for (int i = 0; i < (int) stickers.size(); i++) {
            end = max(end, last[stickers[i] - 'a']);
            if (i == end) { // every letter seen in this run has finished
                sizes.push_back(end - start + 1);
                start = i + 1;
            }
        }
        return sizes;
    }
};
