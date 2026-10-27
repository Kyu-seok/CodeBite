from collections import Counter


class Solution:
    def canGroupBakes(self, hand: list[int], groupSize: int) -> bool:
        if len(hand) % groupSize:
            return False
        left = Counter(hand)
        # The smallest card left must start a group, so start as many groups there as it has copies.
        for start in sorted(left):
            groups = left[start]
            if groups == 0:
                continue
            for card in range(start, start + groupSize):
                if left[card] < groups:
                    return False
                left[card] -= groups
        return True
