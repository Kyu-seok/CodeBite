const KEYPAD = { 2: 'abc', 3: 'def', 4: 'ghi', 5: 'jkl', 6: 'mno', 7: 'pqrs', 8: 'tuv', 9: 'wxyz' };

class Solution {
    letterCombinations(digits) {
        if (digits.length === 0) return [];
        let combos = [''];
        for (const d of digits) {
            const next = [];
            for (const prefix of combos) {
                for (const letter of KEYPAD[d]) next.push(prefix + letter);
            }
            combos = next;
        }
        return combos;
    }
}
