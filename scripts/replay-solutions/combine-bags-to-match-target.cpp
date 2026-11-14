class Solution {
public:
    bool canMatchTarget(vector<vector<int>>& bags, vector<int>& target) {
        bool reached[3] = {false, false, false};
        for (auto& bag : bags) {
            if (bag[0] > target[0] || bag[1] > target[1] || bag[2] > target[2]) continue;
            for (int k = 0; k < 3; k++) if (bag[k] == target[k]) reached[k] = true;
        }
        return reached[0] && reached[1] && reached[2];
    }
};
