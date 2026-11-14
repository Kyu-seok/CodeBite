-- V480: populating-next-pointers restated, Slug and title unchanged. Hidden case 4 is an
-- empty tree (expected []), which the constraint "[1, 4096]" ruled out; a perfect tree
-- also never has 4096 nodes (its sizes are 2^k - 1). The constraint is now [0, 4095], the
-- description says an empty tree returns null and how the output is printed, "members"
-- is now "nodes", and the Korean says 포화 이진 트리 (perfect), not 완전한 (complete).
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$You are given the `root` of a **perfect** binary tree: every parent has two children and every leaf sits at the same depth. Each node has fields `val`, `left`, `right` and `next`, and every `next` starts as null.

Set each node's `next` to the node immediately to its right on the same level, and leave it null for the rightmost node of each level. Return `root`. If the tree is empty, return null.

The output lists the nodes level by level, following `next` pointers from the leftmost node of each level, with `#` after each level's last node. An empty tree prints as `[]`.

**Example 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: 10 is alone on its level; 20 → 30; 40 → 50 → 60 → 70. Each level's last node keeps next = null.
```

```diagram-tree
nodes: [10, 20, 30, 40, 50, 60, 70]
```

**Example 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: The single node is alone on its level, so its `next` stays null.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[0, 4095]`.
- `-1000 <= Node.val <= 1000`
- The tree is a perfect binary tree.$$
WHERE slug = $$populating-next-pointers$$;

UPDATE problem_translations SET
    description = $$**포화** 이진 트리(perfect binary tree)의 `root`가 주어집니다. 모든 부모는 자식이 둘이고, 모든 잎은 같은 깊이에 있습니다. 각 노드는 `val`, `left`, `right`, `next` 필드를 가지며, 처음에는 모든 `next`가 null입니다.

각 노드의 `next`가 같은 레벨에서 바로 오른쪽에 있는 노드를 가리키도록 설정하세요. 각 레벨의 가장 오른쪽 노드는 `next`를 null로 둡니다. `root`를 반환하고, 트리가 비어 있으면 null을 반환합니다.

출력은 각 레벨의 가장 왼쪽 노드부터 `next`를 따라가며 노드를 레벨 순서대로 나열하고, 각 레벨의 마지막 노드 뒤에 `#`를 붙입니다. 빈 트리는 `[]`로 출력됩니다.

**예시 1:**
```
입력: root = [10,20,30,40,50,60,70]
출력: [10,#,20,30,#,40,50,60,70,#]
설명: 10은 레벨에 혼자 있고, 20 → 30, 40 → 50 → 60 → 70으로 이어집니다. 각 레벨의 마지막 노드는 next가 null로 남습니다.
```

```diagram-tree
nodes: [10, 20, 30, 40, 50, 60, 70]
```

**예시 2:**
```
입력: root = [9]
출력: [9,#]
설명: 노드가 하나뿐이면 같은 레벨에 오른쪽 노드가 없으므로 `next`는 null로 남습니다.
```$$,
    constraints = $$- 트리의 노드 개수는 `[0, 4095]` 범위 안에 있습니다.
- `-1000 <= Node.val <= 1000`
- 트리는 포화 이진 트리입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$populating-next-pointers$$);
