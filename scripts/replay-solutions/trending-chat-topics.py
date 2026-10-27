from collections import Counter


class Solution:
    def rankTrendingTopics(self, topics: list[str], k: int) -> list[str]:
        counts = Counter(topics)
        return sorted(counts, key=lambda topic: (-counts[topic], topic))[:k]
