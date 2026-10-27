import heapq
from itertools import count


class MicroFeed:
    def __init__(self) -> None:
        self.clock = count()
        self.posts: dict[int, list[tuple[int, int]]] = {}
        self.following: dict[int, set[int]] = {}

    def publishPost(self, userId: int, messageId: int) -> None:
        self.posts.setdefault(userId, []).append((next(self.clock), messageId))

    def latestFeed(self, userId: int) -> list[int]:
        authors = self.following.get(userId, set()) | {userId}
        newest = heapq.nlargest(
            10, (post for author in authors for post in self.posts.get(author, [])[-10:]))
        return [messageId for _, messageId in newest]

    def subscribe(self, followerId: int, followeeId: int) -> None:
        if followerId != followeeId:
            self.following.setdefault(followerId, set()).add(followeeId)

    def unsubscribe(self, followerId: int, followeeId: int) -> None:
        self.following.get(followerId, set()).discard(followeeId)
