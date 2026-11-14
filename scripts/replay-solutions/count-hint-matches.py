class Solution:
    def countHintMatches(self, notes: str, target: str) -> int:
        # ways[j] = ways to pick target[:j] from the letters of notes seen so far
        ways = [1] + [0] * len(target)
        for letter in notes:
            for j in range(len(target), 0, -1):
                if target[j - 1] == letter:
                    ways[j] += ways[j - 1]
        return ways[len(target)]
