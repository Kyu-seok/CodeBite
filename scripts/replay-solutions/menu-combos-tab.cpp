#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<vector<int>> listTabCombos(vector<int>& pastries, int tab) {
        vector<int> prices = pastries;
        sort(prices.begin(), prices.end());
        vector<vector<int>> combos;
        vector<int> chosen;
        pick(prices, 0, tab, chosen, combos);
        return combos;
    }

private:
    void pick(const vector<int>& prices, int start, int remaining, vector<int>& chosen, vector<vector<int>>& combos) {
        if (remaining == 0) {
            combos.push_back(chosen);
            return;
        }
        for (int i = start; i < (int) prices.size() && prices[i] <= remaining; i++) {
            if (i > start && prices[i] == prices[i - 1]) continue;
            chosen.push_back(prices[i]);
            pick(prices, i + 1, remaining - prices[i], chosen, combos);
            chosen.pop_back();
        }
    }
};
