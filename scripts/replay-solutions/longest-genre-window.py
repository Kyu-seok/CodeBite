class Solution:
    def longestFreshFeed(self, feed: str) -> int:
        last_seen: dict[str, int] = {}
        start = 0
        best = 0
        for i, tag in enumerate(feed):
            if last_seen.get(tag, -1) >= start:
                start = last_seen[tag] + 1
            last_seen[tag] = i
            best = max(best, i - start + 1)
        return best
