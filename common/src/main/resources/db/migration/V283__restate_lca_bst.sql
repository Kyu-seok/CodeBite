-- V283: restate lca-bst (#215, part of #193). The Examples showed a tree
-- ([6,2,8,0,4,7,9,null,null,3,5]) that is no sample Test Case; they now show
-- samples 1, 2 and 3 ([20,10,30,5,15,25,40,null,8,12,18] with p, q = 8, 12 /
-- 25, 40 / 10, 15), with the Diagram redrawn to that tree in both languages and
-- the explanations rewritten. The English constraint "All topic IDs are unique"
-- (left over from an earlier theme) now says node values, as the Korean does.
-- Slug, title, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Given the `root` of a binary search tree and two nodes `p` and `q` that both exist in the tree, return the lowest common ancestor (LCA) of `p` and `q`.

The LCA is the deepest node that has both `p` and `q` as descendants — and a node is allowed to be a descendant of itself. Because the tree is a BST, you can walk down from the root and decide at each step which subtree contains both nodes.

**Example 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: 8 and 12 are both less than 20, so walk left to 10; there they split (8 < 10 < 12), so the LCA is 10.
```

```diagram-tree
nodes: [20, 10, 30, 5, 15, 25, 40, null, 8, 12, 18]
highlight: [8, 9]
```

**Example 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: 25 and 40 are both greater than 20, so walk right to 30; there they split, so the LCA is 30.
```

**Example 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15 is in the subtree rooted at 10, and a node can be its own descendant.
```$$,
    constraints = $$- The number of nodes in the tree is in the range `[2, 2 * 10^5]`.
- `-10^8 <= Node.val <= 10^8`
- All node values are unique.
- `p != q`
- Both `p` and `q` exist in the tree.$$
WHERE slug = $$lca-bst$$;

UPDATE problem_translations SET
    description = $$이진 검색 트리(BST)의 `root`와 트리 안에 존재하는 두 노드 `p`, `q`가 주어졌을 때, `p`와 `q`의 최소 공통 조상(LCA)을 반환하세요.

LCA란 `p`와 `q`를 모두 자손으로 두는 노드 중 가장 깊은 노드를 뜻합니다. 자기 자신도 자손으로 칠 수 있습니다. BST의 성질을 이용하면 루트에서 내려가면서 두 노드가 어느 서브트리에 속하는지 단계마다 판단할 수 있습니다.

**예시 1:**
```
입력: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
출력: 10
설명: `8`과 `12`는 모두 `20`보다 작으므로 왼쪽의 `10`으로 내려갑니다. 거기서 두 노드가 서로 다른 서브트리로 갈라지므로(`8 < 10 < 12`) LCA는 `10`입니다.
```

```diagram-tree
nodes: [20, 10, 30, 5, 15, 25, 40, null, 8, 12, 18]
highlight: [8, 9]
```

**예시 2:**
```
입력: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
출력: 30
설명: `25`와 `40`은 모두 `20`보다 크므로 오른쪽의 `30`으로 내려갑니다. 거기서 두 노드가 갈라지므로 LCA는 `30`입니다.
```

**예시 3:**
```
입력: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
출력: 10
설명: `15`는 노드 `10`을 루트로 하는 서브트리 안에 있고, 노드는 자기 자신을 자손으로 칠 수 있으므로 LCA는 `10`입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lca-bst$$);
