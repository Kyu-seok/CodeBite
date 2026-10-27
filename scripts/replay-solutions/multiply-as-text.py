class Solution:
    def productAsText(self, left: str, right: str) -> str:
        # digits[k] holds the 10^k place of the product, least significant first.
        digits = [0] * (len(left) + len(right))
        for i, a in enumerate(reversed(left)):
            for j, b in enumerate(reversed(right)):
                digits[i + j] += (ord(a) - ord("0")) * (ord(b) - ord("0"))
        carry = 0
        for k in range(len(digits)):
            carry, digits[k] = divmod(digits[k] + carry, 10)
        while len(digits) > 1 and digits[-1] == 0:
            digits.pop()
        return "".join(chr(ord("0") + d) for d in reversed(digits))
