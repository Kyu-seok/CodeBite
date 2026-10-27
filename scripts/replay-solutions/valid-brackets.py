class Solution:
    def verifyJobNesting(self, tape: str) -> bool:
        opener_of = {")": "(", "]": "[", "}": "{"}
        stack: list[str] = []
        for ch in tape:
            if ch in opener_of:
                if not stack or stack.pop() != opener_of[ch]:
                    return False
            else:
                stack.append(ch)
        return not stack
