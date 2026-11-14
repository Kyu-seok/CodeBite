class Solution {
    canBalance(brackets) {
        // The number of unclosed openers can be anything in [low, high].
        let low = 0, high = 0;
        for (const ch of brackets) {
            if (ch === '(') { low++; high++; }
            else if (ch === ')') { low--; high--; }
            else { low--; high++; }
            if (high < 0) return false;
            low = Math.max(low, 0);
        }
        return low === 0;
    }
}
