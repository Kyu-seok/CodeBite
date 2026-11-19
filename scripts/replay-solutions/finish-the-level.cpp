class Solution {
public:
    bool canFinishLevel(vector<int>& jumps) {
        int farthest = 0;
        for (int tile = 0; tile < (int)jumps.size(); tile++) {
            if (tile > farthest) return false;
            farthest = max(farthest, tile + jumps[tile]);
        }
        return true;
    }
};
