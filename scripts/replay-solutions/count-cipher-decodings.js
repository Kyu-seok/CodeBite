class Solution {
    countDecodings(digits) {
        if (digits.length === 0 || digits[0] === "0") return 0;
        let before = 1, current = 1;
        for (let i = 1; i < digits.length; i++) {
            let ways = digits[i] !== "0" ? current : 0;
            const pair = Number(digits.slice(i - 1, i + 1));
            if (pair >= 10 && pair <= 26) ways += before;
            before = current;
            current = ways;
        }
        return current;
    }
}
