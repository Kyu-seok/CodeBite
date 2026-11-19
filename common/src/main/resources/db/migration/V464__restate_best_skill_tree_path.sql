-- V464: best-skill-tree-path restated, English title unchanged; Korean title 가지 (branch) ->
-- 경로 (path). "Branch" was redefined to mean a chain that can bend up and back down (5 -> 4 ->
-- 6), against its usual downward meaning, and "the best contiguous chain to spec into" was game
-- jargon: the statement now calls it a path and says it may turn at a node. Starter method
-- maxBranchTotal -> maxPathSum in all 4 Starter Codes and Drivers. Examples match the sample
-- test cases, which are unchanged, and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$A skill tree is a binary tree whose nodes hold scores, positive or negative. Given its `root`, return the largest sum of scores along any non-empty **path**.

A path is a sequence of nodes in which each node is joined to the next by an edge and no node appears twice. It may start and end at any node and need not include the root. It may also turn at a node, coming up from one child and going down to the other, as 5 -> 4 -> 6 does in Example 1. A single node is a path.

**Example 1:**
```
Input: root = [4,5,6]
Output: 15
Explanation: The best path is 5 -> 4 -> 6, totaling 5 + 4 + 6 = 15.
```

```diagram-tree
nodes: [4, 5, 6]
```

**Example 2:**
```
Input: root = [-8,11,25,null,null,13,9]
Output: 47
Explanation: The best path is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. The best path through the root, 11 -> -8 -> 25 -> 13, totals only 41.
```$$
WHERE slug = $$best-skill-tree-path$$;

UPDATE problem_translations SET
    title = $$최고의 스킬 트리 경로$$,
    description = $$스킬 트리는 각 노드에 양수 또는 음수 점수가 있는 이진 트리입니다. 트리의 루트 `root`가 주어질 때, 비어 있지 않은 **경로**의 점수 합 중 최댓값을 반환하세요.

경로는 이웃한 노드끼리 간선으로 이어지고 같은 노드가 두 번 나오지 않는 노드의 나열입니다. 어느 노드에서 시작하고 끝나도 되며 루트를 포함하지 않아도 됩니다. 예시 1의 5 -> 4 -> 6처럼 한쪽 자식에서 올라와 다른 쪽 자식으로 내려가며 한 노드에서 꺾일 수도 있습니다. 노드 하나만으로도 경로입니다.

**예시 1:**
```
입력: root = [4,5,6]
출력: 15
설명: 가장 좋은 경로는 5 -> 4 -> 6이며, 합은 5 + 4 + 6 = 15입니다.
```

```diagram-tree
nodes: [4, 5, 6]
```

**예시 2:**
```
입력: root = [-8,11,25,null,null,13,9]
출력: 47
설명: 가장 좋은 경로는 13 -> 25 -> 9이며, 합은 13 + 25 + 9 = 47입니다. 루트를 지나는 경로 중 가장 좋은 11 -> -8 -> 25 -> 13의 합은 41에 그칩니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$best-skill-tree-path$$);
