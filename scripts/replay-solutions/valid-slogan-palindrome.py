class Solution:
    def isPalindrome(self, phrase: str) -> bool:
        left, right = 0, len(phrase) - 1
        while left < right:
            if not phrase[left].isalnum():
                left += 1
            elif not phrase[right].isalnum():
                right -= 1
            elif phrase[left].lower() != phrase[right].lower():
                return False
            else:
                left += 1
                right -= 1
        return True
