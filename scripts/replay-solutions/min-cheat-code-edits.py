class Solution:
    def min_distance(self, source: str, target: str) -> int:
        previous = list(range(len(target) + 1))
        for i, a in enumerate(source, 1):
            current = [i]
            for j, b in enumerate(target, 1):
                if a == b:
                    current.append(previous[j - 1])
                else:
                    current.append(1 + min(previous[j - 1], previous[j], current[j - 1]))
            previous = current
        return previous[-1]
