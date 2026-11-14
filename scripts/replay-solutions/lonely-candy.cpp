class Solution {
public:
    int findLonelyCandy(vector<int>& candies) {
        int loner = 0;
        for (int candy : candies) loner ^= candy;
        return loner;
    }
};
