class Solution {
    private static final String[] KEYPAD = {"", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"};

    public List<String> letterCombinations(String digits) {
        List<String> result = new ArrayList<>();
        if (digits.isEmpty()) return result;
        build(digits, 0, new StringBuilder(), result);
        return result;
    }

    private void build(String digits, int i, StringBuilder prefix, List<String> result) {
        if (i == digits.length()) {
            result.add(prefix.toString());
            return;
        }
        for (char letter : KEYPAD[digits.charAt(i) - '0'].toCharArray()) {
            prefix.append(letter);
            build(digits, i + 1, prefix, result);
            prefix.deleteCharAt(prefix.length() - 1);
        }
    }
}
