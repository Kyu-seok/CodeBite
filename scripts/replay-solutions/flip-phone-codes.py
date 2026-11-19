KEYPAD = {
    "2": "abc", "3": "def", "4": "ghi", "5": "jkl",
    "6": "mno", "7": "pqrs", "8": "tuv", "9": "wxyz",
}


class Solution:
    def letterCombinations(self, digits: str) -> list[str]:
        if not digits:
            return []
        combos: list[str] = []
        letters: list[str] = []

        def build(i: int) -> None:
            if i == len(digits):
                combos.append("".join(letters))
                return
            for letter in KEYPAD[digits[i]]:
                letters.append(letter)
                build(i + 1)
                letters.pop()

        build(0)
        return combos
