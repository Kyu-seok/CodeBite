class Solution:
    def evalPostfix(self, tokens: list[str]) -> int:
        stack: list[int] = []
        for token in tokens:
            if token not in ("+", "-", "*", "/"):
                stack.append(int(token))
                continue
            right = stack.pop()
            left = stack.pop()
            match token:
                case "+":
                    stack.append(left + right)
                case "-":
                    stack.append(left - right)
                case "*":
                    stack.append(left * right)
                case "/":
                    stack.append(int(left / right))  # truncates toward zero
        return stack[0]
