-- Add Tree Ancestor problem
-- CodeBite original name: Tree Ancestor (inspired by Lowest Common Ancestor of a Binary Tree, LC #236)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Tree Ancestor',
    'tree-ancestor',
    'Given a binary tree, find the lowest common ancestor (LCA) of two given nodes `p` and `q`.

The lowest common ancestor is the deepest node in the tree that has both `p` and `q` as descendants. A node is allowed to be a descendant of itself.

All node values are unique, and both `p` and `q` are guaranteed to exist in the tree.

**Example 1:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: The LCA of nodes 5 and 1 is 3.
```

**Example 2:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: Node 5 is an ancestor of node 4, so the LCA is 5 itself.
```

**Example 3:**
```
Input: root = [1,2,3], p = 2, q = 3
Output: 1
```',
    'MEDIUM',
    'The number of nodes in the tree is in the range [2, 10000].
-10^9 <= Node.val <= 10^9
All Node.val are unique.
p != q
Both p and q exist in the tree.',
    129,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[3,5,1,6,2,0,8,null,null,7,4]\n5\n1', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[3,5,1,6,2,0,8,null,null,7,4]\n5\n4', '5', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3]\n2\n3', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2]\n1\n2', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[3,5,1,6,2,0,8,null,null,7,4]\n7\n8', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[3,5,1,6,2,0,8,null,null,7,4]\n6\n4', '5', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-ancestor'),
    'en',
    'Tree Ancestor',
    'Given a binary tree, find the lowest common ancestor (LCA) of two given nodes `p` and `q`.

The lowest common ancestor is the deepest node in the tree that has both `p` and `q` as descendants. A node is allowed to be a descendant of itself.

All node values are unique, and both `p` and `q` are guaranteed to exist in the tree.

**Example 1:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 1
Output: 3
Explanation: The LCA of nodes 5 and 1 is 3.
```

**Example 2:**
```
Input: root = [3,5,1,6,2,0,8,null,null,7,4], p = 5, q = 4
Output: 5
Explanation: Node 5 is an ancestor of node 4, so the LCA is 5 itself.
```

**Example 3:**
```
Input: root = [1,2,3], p = 2, q = 3
Output: 1
```',
    'The number of nodes in the tree is in the range [2, 10000].
-10^9 <= Node.val <= 10^9
All Node.val are unique.
p != q
Both p and q exist in the tree.'
);
