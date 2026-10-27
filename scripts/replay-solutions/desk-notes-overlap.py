class Solution:
    def longest_common_subsequence(self, left: str, right: str) -> int:
        previous = [0] * (len(right) + 1)
        for a in left:
            current = [0]
            for j, b in enumerate(right):
                current.append(previous[j] + 1 if a == b else max(previous[j + 1], current[j]))
            previous = current
        return previous[-1]
