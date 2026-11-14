class Solution {
    public int countCouponCombos(int amount, int[] coupons) {
        int[] ways = new int[amount + 1];
        ways[0] = 1;
        for (int coupon : coupons)
            for (int total = coupon; total <= amount; total++)
                ways[total] += ways[total - coupon];
        return ways[amount];
    }
}
