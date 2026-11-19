class Solution {
public:
    unsigned long reverseFlags(unsigned long statusWord) {
        unsigned long result = 0;
        for (int bit = 0; bit < 32; bit++) {
            result = (result << 1) | ((statusWord >> bit) & 1UL);
        }
        return result;
    }
};
