class Solution {
public:
    int countDecodings(string digits) {
        if (digits.empty() || digits[0] == '0') return 0;
        int before = 1, current = 1;
        for (size_t i = 1; i < digits.size(); i++) {
            int ways = digits[i] != '0' ? current : 0;
            int pair = (digits[i - 1] - '0') * 10 + (digits[i] - '0');
            if (pair >= 10 && pair <= 26) ways += before;
            before = current;
            current = ways;
        }
        return current;
    }
};
