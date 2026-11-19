class Solution:
    def isPalindrome(self, episode: int) -> bool:
        text = str(episode)
        return text == text[::-1]
