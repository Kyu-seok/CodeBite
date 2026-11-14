-- V481: sum-root-to-leaf restated, Slug and title unchanged. The description's "at most a
-- few thousand nodes" contradicted the constraint [1, 1000], the constraint said "the
-- skill tree" (left from another problem), and only the Korean listed the 32-bit
-- guarantee as a constraint. The node count now lives in the constraints alone, which say
-- "the tree" and carry the 32-bit guarantee in both languages. Examples match the sample
-- test cases, which are unchanged.

UPDATE problems SET
    description = $$Each node of a binary tree holds a single digit `0`–`9`. Reading the node values of a root-to-leaf path from top to bottom spells a non-negative integer: the path `4 → 9 → 5` spells `495`.

Given the `root`, return the sum of the integers spelled by every root-to-leaf path.

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
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 1000]`.
- `0 <= Node.val <= 9`
- The sum fits in a 32-bit signed integer.$$
WHERE slug = $$sum-root-to-leaf$$;

UPDATE problem_translations SET
    description = $$이진 트리의 각 노드에는 `0`–`9` 사이의 한 자리 숫자가 들어 있습니다. 루트에서 잎까지 가는 경로의 노드 값을 위에서 아래로 이어 읽으면 음이 아닌 정수 하나가 됩니다. 예를 들어 `4 → 9 → 5` 경로는 `495`를 나타냅니다.

`root`가 주어질 때, 모든 루트-잎 경로가 나타내는 정수의 합을 반환하세요.

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
설명: 경로 3→6→4, 3→6→0, 3→1은 각각 364, 360, 31을 나타냅니다. 364 + 360 + 31 = 755입니다.
```$$,
    constraints = $$- 트리의 노드 개수는 `[1, 1000]` 범위 안에 있습니다.
- `0 <= Node.val <= 9`
- 합은 32비트 부호 있는 정수 범위 안에 들어갑니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sum-root-to-leaf$$);
