class Solution {
    /**
     * @param {string} left
     * @param {string} right
     * @return {string}
     */
    productAsText(left, right) {
        const digits = new Array(left.length + right.length).fill(0);
        for (let i = left.length - 1; i >= 0; i--) {
            for (let j = right.length - 1; j >= 0; j--) {
                const sum = digits[i + j + 1] + Number(left[i]) * Number(right[j]);
                digits[i + j + 1] = sum % 10;
                digits[i + j] += Math.floor(sum / 10);
            }
        }
        const out = digits.join('').replace(/^0+/, '');
        return out === '' ? '0' : out;
    }
}
