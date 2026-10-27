from collections import deque
from string import ascii_lowercase


class Solution:
    def ladderLength(self, beginWord: str, endWord: str, wordList: list[str]) -> int:
        unvisited = set(wordList)
        if endWord not in unvisited:
            return 0
        unvisited.discard(beginWord)
        queue = deque([(beginWord, 1)])
        while queue:
            word, length = queue.popleft()
            for i in range(len(word)):
                for letter in ascii_lowercase:
                    candidate = word[:i] + letter + word[i + 1:]
                    if candidate in unvisited:
                        if candidate == endWord:
                            return length + 1
                        unvisited.remove(candidate)
                        queue.append((candidate, length + 1))
        return 0
