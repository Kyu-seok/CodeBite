class Solution {
    public int countDecodings(String digits) {
        if (digits.isEmpty() || digits.charAt(0) == '0') return 0;
        int before = 1, current = 1;
        for (int i = 1; i < digits.length(); i++) {
            int ways = digits.charAt(i) != '0' ? current : 0;
            int pair = Integer.parseInt(digits.substring(i - 1, i + 1));
            if (pair >= 10 && pair <= 26) ways += before;
            before = current;
            current = ways;
        }
        return current;
    }
}
