#include <vector>
using namespace std;

class Solution {
public:
    int countCouponCombos(int amount, vector<int>& coupons) {
        vector<long long> ways(amount + 1, 0);
        ways[0] = 1;
        for (int coupon : coupons)
            for (int total = coupon; total <= amount; total++) ways[total] += ways[total - coupon];
        return (int)ways[amount];
    }
};
