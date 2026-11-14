-- V532: right-side-skill-view restated, title unchanged. The task now comes first, "tier"
-- and "row" become one word, level, and Example 3 ([1,null,2]), a near-duplicate of
-- Example 2, is dropped; Example 2 is explained instead. Starter method
-- captureDockSilhouette -> rightSideView in all 4 Starter Codes and Drivers. Examples and
-- their Diagram match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given the `root` of a skill tree, return the value of the rightmost node on each level, from the top level down: the nodes you see when you look at the tree from its right side. Return an empty list if the tree is empty.

**Example 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Level 0 has only 7. Level 1 has 8 and 9, and 9 hides 8. Level 2 has 6 and 3, and 3 hides 6, even though 6 hangs under the left branch.
```

```diagram-tree
nodes: [7, 8, 9, null, 6, null, 3]
highlight: [0, 2, 6]
```

**Example 2:**
```
Input: root = [2,null,5]
Output: [2,5]
Explanation: Each level has one node, 2 and then its right child 5, so both are seen.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 100]`.
- `-100 <= Node.val <= 100`$$
WHERE slug = $$right-side-skill-view$$;

UPDATE problem_translations SET
    description = $$스킬 트리의 루트 `root`가 주어질 때, 맨 위 층부터 아래로 각 층에서 가장 오른쪽에 있는 노드의 값을 반환하세요. 트리를 오른쪽에서 바라볼 때 보이는 노드들입니다. 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: root = [7,8,9,null,6,null,3]
출력: [7,9,3]
설명: 0층에는 7만 있습니다. 1층에는 8과 9가 있고, 9가 8을 가립니다. 2층에는 6과 3이 있고, 6이 왼쪽 가지에 매달려 있어도 3이 6을 가립니다.
```

```diagram-tree
nodes: [7, 8, 9, null, 6, null, 3]
highlight: [0, 2, 6]
```

**예시 2:**
```
입력: root = [2,null,5]
출력: [2,5]
설명: 각 층에 노드가 하나씩, 2와 그 오른쪽 자식 5만 있으므로 둘 다 보입니다.
```$$,
    constraints = $$- 트리의 노드 개수는 `[0, 100]` 범위에 있습니다.
- `-100 <= Node.val <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$right-side-skill-view$$);
