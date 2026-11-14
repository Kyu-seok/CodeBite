class Solution {
    public boolean canBalance(String brackets) {
        // The number of unclosed openers can be anything in [low, high].
        int low = 0, high = 0;
        for (char ch : brackets.toCharArray()) {
            if (ch == '(') { low++; high++; }
            else if (ch == ')') { low--; high--; }
            else { low--; high++; }
            if (high < 0) return false;
            low = Math.max(low, 0);
        }
        return low == 0;
    }
}
