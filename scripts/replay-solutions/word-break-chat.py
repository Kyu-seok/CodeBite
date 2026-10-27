class Solution:
    def splitHeadlineTokens(self, headline: str, topics: list[str]) -> bool:
        words = set(topics)
        lengths = {len(word) for word in words}
        # splittable[end] is whether headline[:end] splits into known words.
        splittable = [True] + [False] * len(headline)
        for end in range(1, len(headline) + 1):
            splittable[end] = any(
                length <= end and splittable[end - length] and headline[end - length:end] in words
                for length in lengths
            )
        return splittable[-1]
