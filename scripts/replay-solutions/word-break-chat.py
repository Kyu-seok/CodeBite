class Solution:
    def canSplitMessage(self, message: str, words: list[str]) -> bool:
        known = set(words)
        lengths = {len(word) for word in known}
        # splittable[end] is whether message[:end] splits into known words.
        splittable = [True] + [False] * len(message)
        for end in range(1, len(message) + 1):
            splittable[end] = any(
                length <= end and splittable[end - length] and message[end - length:end] in known
                for length in lengths
            )
        return splittable[-1]
