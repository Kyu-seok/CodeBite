class Solution {
    countCouponCombos(amount, coupons) {
        const ways = new Array(amount + 1).fill(0);
        ways[0] = 1;
        for (const coupon of coupons)
            for (let total = coupon; total <= amount; total++) ways[total] += ways[total - coupon];
        return ways[amount];
    }
}
