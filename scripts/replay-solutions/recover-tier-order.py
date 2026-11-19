import heapq


class Solution:
    def recoverTierOrder(self, tags: list[str]) -> str:
        # Letters in the order they first appear, and each letter's followers in the order the tags reveal them,
        # so every run goes the same way (a set's order would change from run to run; the answer would not).
        letters = list(dict.fromkeys(letter for tag in tags for letter in tag))
        after: dict[str, list[str]] = {letter: [] for letter in letters}
        for first, second in zip(tags, tags[1:]):
            for a, b in zip(first, second):
                if a != b:
                    if b not in after[a]:
                        after[a].append(b)
                    break
            else:
                if len(first) > len(second):
                    return ""
        indegree = dict.fromkeys(letters, 0)
        for followers in after.values():
            for letter in followers:
                indegree[letter] += 1
        ready = [letter for letter in letters if indegree[letter] == 0]
        heapq.heapify(ready)
        order = []
        while ready:
            letter = heapq.heappop(ready)
            order.append(letter)
            for follower in after[letter]:
                indegree[follower] -= 1
                if indegree[follower] == 0:
                    heapq.heappush(ready, follower)
        return "".join(order) if len(order) == len(letters) else ""
