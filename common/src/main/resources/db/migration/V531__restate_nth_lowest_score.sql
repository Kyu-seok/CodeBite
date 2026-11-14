-- V531: nth-lowest-score restated, title unchanged. The task now comes first, and the
-- statement names no method. Starter method pickNthTarget -> nthLowestScore in all 4 Starter
-- Codes and Drivers. Examples and their Diagram match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$Given the `root` of a binary search tree of scores and an integer `k`, return the `k`-th lowest score, counting from `1`.

An in-order walk of a binary search tree visits its scores from lowest to highest, so the answer is the `k`-th score that walk visits.

**Example 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In order, the scores are [2,4,6,8,10,12,14]. The 4th is 8.
```

```diagram-tree
nodes: [8, 4, 12, 2, 6, 10, 14]
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In order, the scores are [5,7,10,15,20,25,30,35]. The 2nd is 7.
```$$,
    constraints = $$- The number of scores in the tree is `n`.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- The tree is a valid binary search tree.$$
WHERE slug = $$nth-lowest-score$$;

UPDATE problem_translations SET
    description = $$점수를 담은 이진 탐색 트리의 루트 `root`와 정수 `k`가 주어질 때, `1`부터 세어 `k`번째로 낮은 점수를 반환하세요.

이진 탐색 트리를 중위 순회하면 가장 낮은 점수부터 가장 높은 점수까지 차례로 방문하므로, 그 순회에서 `k`번째로 방문하는 점수가 답입니다.

**예시 1:**
```
입력: root = [8,4,12,2,6,10,14], k = 4
출력: 8
설명: 점수를 차례로 나열하면 [2,4,6,8,10,12,14]이고, 4번째는 8입니다.
```

```diagram-tree
nodes: [8, 4, 12, 2, 6, 10, 14]
```

**예시 2:**
```
입력: root = [20,10,30,5,15,25,35,null,7], k = 2
출력: 7
설명: 점수를 차례로 나열하면 [5,7,10,15,20,25,30,35]이고, 2번째는 7입니다.
```$$,
    constraints = $$- 트리에 들어 있는 점수 개수는 `n`입니다.
- `1 <= k <= n <= 8 * 10^4`
- `0 <= Node.val <= 10^8`
- 트리는 올바른 이진 탐색 트리입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$nth-lowest-score$$);
