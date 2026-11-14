#include <vector>
#include <algorithm>
using namespace std;

class Solution {
public:
    vector<vector<int>> listVoucherSums(vector<int>& prices, int voucher) {
        vector<int> sorted = prices;
        sort(sorted.begin(), sorted.end());
        vector<vector<int>> baskets;
        vector<int> basket;
        build(sorted, 0, voucher, basket, baskets);
        return baskets;
    }

private:
    void build(const vector<int>& prices, int start, int remaining, vector<int>& basket, vector<vector<int>>& baskets) {
        if (remaining == 0) {
            baskets.push_back(basket);
            return;
        }
        for (int i = start; i < (int)prices.size() && prices[i] <= remaining; i++) {
            basket.push_back(prices[i]);
            build(prices, i, remaining - prices[i], basket, baskets);
            basket.pop_back();
        }
    }
};
