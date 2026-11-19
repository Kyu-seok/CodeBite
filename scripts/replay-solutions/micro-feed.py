import heapq
from itertools import count


class MicroFeed:
    def __init__(self) -> None:
        self.clock = count()
        self.posts: dict[int, list[tuple[int, int]]] = {}  # user -> [(time, messageId)], oldest first
        self.following: dict[int, set[int]] = {}

    def publishPost(self, userId: int, messageId: int) -> None:
        self.posts.setdefault(userId, []).append((next(self.clock), messageId))

    def latestFeed(self, userId: int) -> list[int]:
        # Merge the authors' posts from their newest end: a max-heap (heapq on negated times) holds each
        # author's newest post not taken yet, so its top is the newest post left overall.
        authors = self.following.get(userId, set()) | {userId}
        heap = []
        for author in sorted(authors):
            mine = self.posts.get(author, [])
            if mine:
                time, messageId = mine[-1]
                heapq.heappush(heap, (-time, messageId, author, len(mine) - 1))
        feed = []
        while heap and len(feed) < 10:
            _, messageId, author, i = heapq.heappop(heap)
            feed.append(messageId)
            if i > 0:
                time, older = self.posts[author][i - 1]
                heapq.heappush(heap, (-time, older, author, i - 1))
        return feed

    def subscribe(self, followerId: int, followeeId: int) -> None:
        if followerId != followeeId:
            self.following.setdefault(followerId, set()).add(followeeId)

    def unsubscribe(self, followerId: int, followeeId: int) -> None:
        self.following.get(followerId, set()).discard(followeeId)
