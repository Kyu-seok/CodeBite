class Solution:
    def countFilterMatches(self, s: str, t: str) -> int:
        # ways[j] = ways to pick t[:j] from the letters of s seen so far
        ways = [1] + [0] * len(t)
        for letter in s:
            for j in range(len(t), 0, -1):
                if t[j - 1] == letter:
                    ways[j] += ways[j - 1]
        return ways[len(t)]
