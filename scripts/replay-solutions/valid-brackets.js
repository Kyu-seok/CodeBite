class Solution {
    isValidBrackets(brackets) {
        const openerOf = { ')': '(', ']': '[', '}': '{' };
        const stack = [];
        for (const ch of brackets) {
            if (ch in openerOf) {
                if (stack.length === 0 || stack.pop() !== openerOf[ch]) return false;
            } else {
                stack.push(ch);
            }
        }
        return stack.length === 0;
    }
}
