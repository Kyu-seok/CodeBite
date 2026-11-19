-- V362: rebuild-boss-tree -> rebuild-tree-from-traversals, retitled "Rebuild Tree From
-- Traversals". The "boss-fight tree" and corrupted-save story were never explained and
-- added nothing: the statement now opens with the task. Starter method assembleBreakdown
-- -> rebuildTree. Drivers and Starter Code directories are renamed in the same commit.
-- Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$rebuild-boss-tree$$, id FROM problems WHERE slug = $$rebuild-boss-tree$$;

UPDATE problems SET
    slug = $$rebuild-tree-from-traversals$$,
    title = $$Rebuild Tree From Traversals$$,
    description = $$Rebuild a binary tree from its preorder and inorder traversals, and return its root.

`preorder` lists the tree's values in preorder (node, then left subtree, then right subtree) and `inorder` lists the same values in inorder (left subtree, then node, then right subtree). All values are distinct, so exactly one tree has both traversals.

The output writes the tree level by level, left to right, with `null` for a missing child (trailing `null`s left out).

**Example 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: The first value of preorder, 10, is the root. In inorder, the values before 10, [3,5,7], form the left subtree and the values after it, [15,20], the right subtree. Repeating this gives left = 5 (children 3 and 7) and right = 20 (left child 15).
```

```diagram-tree
nodes: [10, 5, 20, 3, 7, 15]
```

**Example 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single node is the whole tree.
```$$,
    constraints = $$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- All values are distinct.
- `preorder` and `inorder` are the preorder and inorder traversals of the same tree.$$
WHERE slug = $$rebuild-boss-tree$$;

UPDATE problem_translations SET
    title = $$순회 결과로 트리 복원$$,
    description = $$이진 트리의 전위 순회와 중위 순회 결과로 트리를 복원하고, 그 루트를 반환하세요.

`preorder`는 트리의 값을 전위 순회(노드, 왼쪽 서브트리, 오른쪽 서브트리) 순서로, `inorder`는 같은 값을 중위 순회(왼쪽 서브트리, 노드, 오른쪽 서브트리) 순서로 나열합니다. 모든 값이 서로 다르므로 두 순회 결과를 모두 만족하는 트리는 정확히 하나입니다.

출력은 트리를 위층부터 왼쪽에서 오른쪽으로 적으며, 없는 자식은 `null`로 적습니다(끝에 남는 `null`은 생략합니다).

**예시 1:**
```
입력: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
출력: [10,5,20,3,7,15]
설명: preorder의 첫 값 10이 루트입니다. inorder에서 10 앞의 값 [3,5,7]은 왼쪽 서브트리, 뒤의 값 [15,20]은 오른쪽 서브트리가 됩니다. 이를 반복하면 왼쪽은 5(자식 3과 7), 오른쪽은 20(왼쪽 자식 15)이 됩니다.
```

```diagram-tree
nodes: [10, 5, 20, 3, 7, 15]
```

**예시 2:**
```
입력: preorder = [42], inorder = [42]
출력: [42]
설명: 노드 하나가 트리 전체입니다.
```$$,
    constraints = $$- `1 <= preorder.length <= 2 * 10^3`
- `inorder.length == preorder.length`
- `-10^8 <= preorder[i], inorder[i] <= 10^8`
- 모든 값은 서로 다릅니다.
- `preorder`와 `inorder`는 같은 트리의 전위 순회와 중위 순회 결과입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rebuild-tree-from-traversals$$);
