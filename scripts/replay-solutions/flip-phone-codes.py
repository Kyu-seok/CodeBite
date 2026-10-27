from itertools import product

KEYPAD = {
    "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
    "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz",
}


class Solution:
    def letter_combinations(self, digits: str) -> list[str]:
        if not digits:
            return []
        return ["".join(letters) for letters in product(*(KEYPAD[d] for d in digits))]
