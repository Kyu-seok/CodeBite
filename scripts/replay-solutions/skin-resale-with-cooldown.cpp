class Solution {
public:
    int maxProfit(vector<int>& prices) {
        int holding = -1000000, sold = 0, resting = 0;
        for (int price : prices) {
            int h = max(holding, resting - price);
            int s = holding + price;
            int r = max(resting, sold);
            holding = h; sold = s; resting = r;
        }
        return max(sold, resting);
    }
};
