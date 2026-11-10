-- V294: restate sum-root-to-leaf (#226, part of #193). The examples now show the
-- sample test cases (order_index 1 and 2), which are unchanged: Example 1 is
-- [2,5,8] -> 53 and Example 2 is [3,6,1,4,0] -> 755, in English and Korean. The
-- Diagram under Example 1 is redrawn to the new data. Slug, title, constraints,
-- Drivers and Starter Code stay.

UPDATE problems SET
    description = $$The root-to-leaf path of a binary tree spells a non-negative integer when its node values are read top to bottom (each node holds a single digit `0`–`9`). For example, the path `4 → 9 → 5` spells `495`.

Given the `root`, sum the integers spelled by every root-to-leaf path. The tree has at most a few thousand nodes and the sum fits in a 32-bit integer.

**Example 1:**
```
Input: root = [2,5,8]
Output: 53
Explanation: Paths 2→5 and 2→8 spell 25 and 28. 25 + 28 = 53.
```

```diagram-tree
nodes: [2, 5, 8]
```

**Example 2:**
```
Input: root = [3,6,1,4,0]
Output: 755
Explanation: Paths 3→6→4, 3→6→0 and 3→1 spell 364, 360 and 31. 364 + 360 + 31 = 755.
```$$
WHERE slug = $$sum-root-to-leaf$$;

UPDATE problem_translations SET
    description = $$이진 트리의 각 노드는 `0`–`9` 사이의 한 자리 숫자를 담고 있습니다. 루트에서 잎까지 가는 경로의 노드 값을 위에서 아래로 이어 붙이면 음이 아닌 정수 한 개가 만들어집니다. 예를 들어 `4 → 9 → 5` 경로는 `495`를 나타냅니다.

`root`가 주어졌을 때, 모든 루트-잎 경로가 나타내는 정수의 합을 반환하세요. 트리의 노드 수는 많아야 수천 개이고, 합은 32비트 정수 범위 안에 들어갑니다.

**예시 1:**
```
입력: root = [2,5,8]
출력: 53
설명: 경로 2→5와 2→8은 각각 25와 28을 나타냅니다. 25 + 28 = 53입니다.
```

```diagram-tree
nodes: [2, 5, 8]
```

**예시 2:**
```
입력: root = [3,6,1,4,0]
출력: 755
설명: 세 갈래 경로 3→6→4, 3→6→0, 3→1이 각각 364, 360, 31을 나타내며 합은 755입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sum-root-to-leaf$$);
