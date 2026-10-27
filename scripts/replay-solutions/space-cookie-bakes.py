from collections import Counter


class Solution:
    def orderRecipeBakes(self, cookies: str) -> str:
        # Lay the letters, most frequent first, into the even slots and then the odd ones.
        counts = Counter(cookies)
        if counts and max(counts.values()) > (len(cookies) + 1) // 2:
            return ""
        letters = sorted(cookies, key=lambda letter: (-counts[letter], letter))
        result = [""] * len(cookies)
        slots = list(range(0, len(cookies), 2)) + list(range(1, len(cookies), 2))
        for slot, letter in zip(slots, letters):
            result[slot] = letter
        return "".join(result)
