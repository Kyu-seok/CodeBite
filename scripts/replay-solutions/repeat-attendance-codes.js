class Solution {
    listRepeatedCodes(codes) {
        const repeated = [];
        for (const code of codes) {
            const index = Math.abs(code) - 1;
            if (codes[index] < 0) repeated.push(Math.abs(code));
            else codes[index] = -codes[index];
        }
        return repeated;
    }
}
