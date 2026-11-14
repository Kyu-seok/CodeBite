-- V513: valid-score-bst restated, Slug and title unchanged. "All scores are distinct" was false
-- for hidden case [10,5,15,null,null,10,20] (expects false): the statement now allows repeated
-- scores and says a repeat always breaks the strict rule. The value bound was 10^8 while hidden
-- case [2147483647] holds 2^31 - 1, a fair input: the constraint is loosened to the 32-bit
-- range. Starter method verifyWardOrder -> isValidBST in all 4 Starter Codes and Drivers, and
-- in the text. Examples match the sample test cases, which are unchanged, and Example 1 keeps
-- its Diagram.

UPDATE problems SET
    description = $$Given the `root` of a binary tree of scores, return `true` if it is a valid binary search tree (BST), otherwise `false`.

In a valid BST, every node in a node's left subtree holds a score **strictly lower** than that node's, and every node in its right subtree a score **strictly higher**. The rule covers whole subtrees, not just a node's children. Because the rule is strict, a tree in which two nodes hold the same score is never valid.

**Example 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above.
```

```diagram-tree
nodes: [50, 30, 70, 20, 40, 60, 80]
```

**Example 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 is in the right subtree of the root 10, but 6 < 10, so the rule breaks.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[1, 2 * 10^5]`.
- `-2^31 <= Node.val <= 2^31 - 1`$$
WHERE slug = $$valid-score-bst$$;

UPDATE problem_translations SET
    description = $$점수가 담긴 이진 트리의 루트 `root`가 주어질 때, 이 트리가 올바른 이진 탐색 트리(BST)이면 `true`, 아니면 `false`를 반환하세요.

올바른 BST에서는 어떤 노드의 왼쪽 서브트리에 있는 모든 노드의 점수가 그 노드보다 **엄격히 작고**, 오른쪽 서브트리에 있는 모든 노드의 점수는 **엄격히 큽니다**. 이 규칙은 직계 자식뿐 아니라 서브트리 전체에 적용됩니다. 규칙이 엄격하므로 같은 점수를 가진 노드가 둘 있는 트리는 언제나 올바르지 않습니다.

**예시 1:**
```
입력: root = [50,30,70,20,40,60,80]
출력: true
설명: 모든 왼쪽 서브트리는 조상 노드보다 작은 값만 갖고, 모든 오른쪽 서브트리는 조상 노드보다 큰 값만 갖습니다.
```

```diagram-tree
nodes: [50, 30, 70, 20, 40, 60, 80]
```

**예시 2:**
```
입력: root = [10,5,15,null,null,6,20]
출력: false
설명: 6은 루트 10의 오른쪽 서브트리에 있지만 6 < 10이므로 규칙이 깨집니다.
```$$,
    constraints = $$- 트리의 노드 개수는 `[1, 2 * 10^5]` 범위 안에 있습니다.
- `-2^31 <= Node.val <= 2^31 - 1`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-score-bst$$);
