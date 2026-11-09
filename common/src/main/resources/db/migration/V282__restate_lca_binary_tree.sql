-- V282: lca-binary-tree, text-only Restatement (#214, part of #193). The
-- Examples showed a tree no sample Test Case has; they now show sample 1 and
-- sample 2 in English and Korean, and the Diagram under Example 1 is redrawn
-- to the new tree, highlighting p and q by index (4 at 3, 11 at 10). Slug,
-- title, constraints, Starter Code, Drivers and Test Cases are unchanged.

UPDATE problems SET
    description = $$Given the `root` of a binary tree (not necessarily a BST) and two nodes `p` and `q` that both exist in the tree, return the lowest common ancestor (LCA) of `p` and `q`.

The LCA is the deepest node that has both `p` and `q` in its subtree — and a node may be its own descendant. All node values are unique.

**Example 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: 4 and 11 belong to different subtrees of 7, so 7 is the deepest node that contains both.
```

```diagram-tree
nodes: [12, 7, 20, 4, 9, 16, 25, null, null, 8, 11]
highlight: [3, 10]
```

**Example 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: 9 lives inside the subtree rooted at 7, and a node can be a descendant of itself.
```$$
WHERE slug = $$lca-binary-tree$$;

UPDATE problem_translations SET
    description = $$일반 이진 트리(BST일 필요 없음)의 `root`와 트리 안에 존재하는 두 노드 `p`, `q`가 주어졌을 때, `p`와 `q`의 최소 공통 조상(LCA)을 반환하세요.

LCA란 `p`와 `q`를 모두 서브트리에 포함하는 노드 중 가장 깊은 노드를 뜻하며, 노드는 자기 자신을 자손으로 칠 수 있습니다. 모든 노드 값은 서로 다릅니다.

**예시 1:**
```
입력: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
출력: 7
설명: 4와 11은 7의 서로 다른 서브트리에 속하므로, 두 노드를 모두 포함하는 가장 깊은 노드는 7입니다.
```

```diagram-tree
nodes: [12, 7, 20, 4, 9, 16, 25, null, null, 8, 11]
highlight: [3, 10]
```

**예시 2:**
```
입력: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
출력: 7
설명: 9는 7을 루트로 하는 서브트리 안에 있고, 노드는 자기 자신을 자손으로 칠 수 있으므로 LCA는 7입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lca-binary-tree$$);
