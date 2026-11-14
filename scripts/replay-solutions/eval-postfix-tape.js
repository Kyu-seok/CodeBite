class Solution {
    evalPostfix(tokens) {
        const stack = [];
        for (const token of tokens) {
            if (!['+', '-', '*', '/'].includes(token)) {
                stack.push(Number(token));
                continue;
            }
            const b = stack.pop();
            const a = stack.pop();
            if (token === '+') stack.push(a + b);
            else if (token === '-') stack.push(a - b);
            else if (token === '*') stack.push(a * b);
            else stack.push(Math.trunc(a / b));
        }
        return stack[0];
    }
}
