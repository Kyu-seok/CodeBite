class Solution {
    power(base, exponent) {
        let e = exponent;
        if (e < 0) { base = 1 / base; e = -e; }
        let result = 1.0;
        while (e > 0) {
            if (e % 2 === 1) result *= base;
            base *= base;
            e = Math.floor(e / 2);
        }
        return result;
    }
}
