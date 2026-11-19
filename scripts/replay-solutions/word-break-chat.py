class Solution:
    def canSplitMessage(self, message: str, words: list[str]) -> bool:
        # splittable[end] is whether message[:end] splits into known words.
        splittable = [True] + [False] * len(message)
        for end in range(1, len(message) + 1):
            # message[:end] splits when some word ends it and the part before that word splits.
            splittable[end] = any(
                message.startswith(word, end - len(word)) and splittable[end - len(word)]
                for word in words
                if len(word) <= end
            )
        return splittable[-1]
