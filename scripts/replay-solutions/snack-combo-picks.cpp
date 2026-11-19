#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<vector<int>> listSnackCombos(vector<int>& snacks) {
        vector<int> sorted(snacks);
        sort(sorted.begin(), sorted.end());
        vector<vector<int>> combos;
        vector<int> combo;
        build(sorted, 0, combo, combos);
        return combos;
    }

private:
    void build(const vector<int>& sorted, int start, vector<int>& combo, vector<vector<int>>& combos) {
        combos.push_back(combo);
        for (int i = start; i < (int) sorted.size(); i++) {
            if (i > start && sorted[i] == sorted[i - 1]) continue;
            combo.push_back(sorted[i]);
            build(sorted, i + 1, combo, combos);
            combo.pop_back();
        }
    }
};
