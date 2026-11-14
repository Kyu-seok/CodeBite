class Solution {
    reverseFlags(statusWord) {
        let result = 0;
        for (let bit = 0; bit < 32; bit++) {
            result = result * 2 + (Math.floor(statusWord / 2 ** bit) % 2);
        }
        return result;
    }
}
