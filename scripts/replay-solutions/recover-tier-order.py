import heapq


class Solution:
    def orderSceneShoot(self, words: list[str]) -> str:
        letters = {letter for word in words for letter in word}
        after: dict[str, set[str]] = {letter: set() for letter in letters}
        for first, second in zip(words, words[1:]):
            for a, b in zip(first, second):
                if a != b:
                    after[a].add(b)
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
