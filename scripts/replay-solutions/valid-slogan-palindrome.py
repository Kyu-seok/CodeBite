class Solution:
    def verifyMirrorCode(self, phrase: str) -> bool:
        cleaned = [ch.lower() for ch in phrase if ch.isalnum()]
        return cleaned == cleaned[::-1]
