class Solution:
    def foldBaleOps(self, baleTape: list[str]) -> int:
        stack: list[int] = []
        for token in baleTape:
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
