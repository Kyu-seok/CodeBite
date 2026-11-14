class Solution {
    listVoucherSums(prices, voucher) {
        const sorted = [...prices].sort((a, b) => a - b);
        const baskets = [];
        const build = (start, remaining, basket) => {
            if (remaining === 0) {
                baskets.push([...basket]);
                return;
            }
            for (let i = start; i < sorted.length && sorted[i] <= remaining; i++) {
                basket.push(sorted[i]);
                build(i, remaining - sorted[i], basket);
                basket.pop();
            }
        };
        build(0, voucher, []);
        return baskets;
    }
}
