class Solution {
    public boolean isValidBrackets(String brackets) {
        Deque<Character> stack = new ArrayDeque<>();
        for (char ch : brackets.toCharArray()) {
            if (ch == '(' || ch == '[' || ch == '{') {
                stack.push(ch);
            } else {
                char opener = ch == ')' ? '(' : ch == ']' ? '[' : '{';
                if (stack.isEmpty() || stack.pop() != opener) return false;
            }
        }
        return stack.isEmpty();
    }
}
