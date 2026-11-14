-- V501: mirror-menu-tree restated, title unchanged. The task now comes first, the chill/bold
-- menu flavour the task never used is gone, and the empty tree (allowed by the constraints)
-- is stated: it stays empty. Starter method reflectBlend -> mirrorTree in all 4 Starter Codes
-- and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given the `root` of a binary tree, swap the left and right children of every node and return the root of the mirrored tree. An empty tree (`root = []`) stays empty.

**Example 1:**
```
Input: root = [5,3,8,2,4,7,9]
Output: [5,8,3,9,7,4,2]
Explanation: The children of `5`, `3` and `8` are all swapped, so each level reads right to left.
```

```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
after: [5, 8, 3, 9, 7, 4, 2]
```

**Example 2:**
```
Input: root = [6,4,11]
Output: [6,11,4]
Explanation: The root's left child `4` and right child `11` trade places.
```

**Example 3:**
```
Input: root = [5]
Output: [5]
Explanation: A single node has no children to swap.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$mirror-menu-tree$$;

UPDATE problem_translations SET
    description = $$이진 트리의 루트 `root`가 주어집니다. 모든 노드의 왼쪽 자식과 오른쪽 자식을 맞바꾼 뒤, 좌우가 뒤집힌 트리의 루트를 반환하세요. 빈 트리(`root = []`)는 그대로 빈 트리입니다.

**예시 1:**
```
입력: root = [5,3,8,2,4,7,9]
출력: [5,8,3,9,7,4,2]
설명: `5`, `3`, `8`의 자식이 모두 맞바뀌어 각 계층을 오른쪽에서 왼쪽으로 읽은 순서가 됩니다.
```

```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
after: [5, 8, 3, 9, 7, 4, 2]
```

**예시 2:**
```
입력: root = [6,4,11]
출력: [6,11,4]
설명: 루트 `6`의 왼쪽 자식 `4`와 오른쪽 자식 `11`이 서로 자리를 바꿉니다.
```

**예시 3:**
```
입력: root = [5]
출력: [5]
설명: 노드가 하나뿐이라 맞바꿀 자식이 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$mirror-menu-tree$$);
