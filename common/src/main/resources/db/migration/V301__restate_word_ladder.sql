-- V301: restate word-ladder (#233, part of #193). The Examples showed
-- "hit" -> "cog" over ["hot","dot","dog","lot","log","cog"], which is no sample
-- Test Case; they now show samples 1 and 2 ("pet" -> "pot" over
-- ["pit","pot","pat"] and over ["pit","pat"]), with the Diagram redrawn to the
-- words one letter apart in sample 1 in both languages and the explanations
-- rewritten. Slug, title, constraints, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    description = $$You're given two words `beginWord` and `endWord` of equal length, plus a dictionary `wordList`. A *transformation* changes exactly one letter at a time, and every intermediate result must appear in `wordList`. `endWord` itself must also be in `wordList` for any transformation to succeed. `beginWord` does NOT need to be in the list.

Return the length of the shortest transformation sequence from `beginWord` to `endWord`, counting both endpoints. If no valid sequence exists, return `0`.

**Example 1:**
```
Input: beginWord = "pet", endWord = "pot", wordList = ["pit","pot","pat"]
Output: 2
Explanation: "pet" and "pot" differ in exactly one letter and "pot" is in the dictionary, so the shortest sequence is "pet" → "pot", length 2.
```

```diagram-graph
edges: [["pet","pit"],["pet","pot"],["pet","pat"],["pit","pot"],["pit","pat"],["pot","pat"]]
directed: false
highlight_path: ["pet","pot"]
```

**Example 2:**
```
Input: beginWord = "pet", endWord = "pot", wordList = ["pit","pat"]
Output: 0
Explanation: "pot" is missing from the dictionary, so no valid sequence exists.
```$$
WHERE slug = $$word-ladder$$;

UPDATE problem_translations SET
    description = $$같은 길이의 두 단어 `beginWord`와 `endWord`, 그리고 사전 `wordList`가 주어집니다. *변환*은 한 번에 정확히 한 글자만 바꾸는 동작이고, 변환 도중 거치는 모든 단어는 `wordList` 안에 있어야 합니다. `endWord` 자체도 사전에 들어 있어야 변환이 성립할 수 있습니다. 단, `beginWord`는 사전에 들어 있을 필요가 없습니다.

`beginWord`에서 `endWord`까지 가는 가장 짧은 변환 시퀀스의 길이를 양 끝 단어를 포함해서 반환하세요. 변환이 불가능하면 `0`을 반환합니다.

**예시 1:**
```
입력: beginWord = "pet", endWord = "pot", wordList = ["pit","pot","pat"]
출력: 2
설명: "pet"과 "pot"은 정확히 한 글자만 다르고 "pot"이 사전에 들어 있으므로, 가장 짧은 시퀀스는 "pet" → "pot"이며 길이는 2입니다.
```

```diagram-graph
edges: [["pet","pit"],["pet","pot"],["pet","pat"],["pit","pot"],["pit","pat"],["pot","pat"]]
directed: false
highlight_path: ["pet","pot"]
```

**예시 2:**
```
입력: beginWord = "pet", endWord = "pot", wordList = ["pit","pat"]
출력: 0
설명: "pot"이 사전에 없으므로 어떤 변환 시퀀스도 성립하지 않습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-ladder$$);
