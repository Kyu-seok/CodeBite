class Solution {
    public double power(double base, int exponent) {
        long e = exponent;
        if (e < 0) { base = 1 / base; e = -e; }
        double result = 1.0;
        while (e > 0) {
            if ((e & 1) == 1) result *= base;
            base *= base;
            e >>= 1;
        }
        return result;
    }
}
