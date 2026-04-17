-- Improve descriptions: batch 13

------------------------------------------------------------
-- tree-codec
------------------------------------------------------------
UPDATE problems
SET description = 'Design an algorithm to serialize a binary tree into a string and deserialize that string back into the original tree.

Implement a `Codec` class with two methods:

- `serialize(root)` -- Converts a binary tree into a single string.
- `deserialize(data)` -- Reconstructs the binary tree from the string produced by `serialize`.

The encoding format is entirely up to you. The only requirement is that `deserialize(serialize(root))` must produce a tree that is structurally identical to the original with the same node values.

**Example 1:**
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: The tree is serialized and then deserialized back to the same structure.
```

**Example 2:**
```
Input: root = []
Output: []
Explanation: An empty tree serializes and deserializes to an empty tree.
```

**Example 3:**
```
Input: root = [1]
Output: [1]
Explanation: A single-node tree round-trips correctly.
```'
WHERE slug = 'tree-codec';

UPDATE problem_translations
SET description = 'Design an algorithm to serialize a binary tree into a string and deserialize that string back into the original tree.

Implement a `Codec` class with two methods:

- `serialize(root)` -- Converts a binary tree into a single string.
- `deserialize(data)` -- Reconstructs the binary tree from the string produced by `serialize`.

The encoding format is entirely up to you. The only requirement is that `deserialize(serialize(root))` must produce a tree that is structurally identical to the original with the same node values.

**Example 1:**
```
Input: root = [1,2,3,null,null,4,5]
Output: [1,2,3,null,null,4,5]
Explanation: The tree is serialized and then deserialized back to the same structure.
```

**Example 2:**
```
Input: root = []
Output: []
Explanation: An empty tree serializes and deserializes to an empty tree.
```

**Example 3:**
```
Input: root = [1]
Output: [1]
Explanation: A single-node tree round-trips correctly.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec')
  AND locale = 'en';

------------------------------------------------------------
-- good-node-count
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, count the number of **good nodes**.

A node is considered **good** if no node along the path from the root to that node has a value strictly greater than the node''s own value. In other words, a node is good when its value is greater than or equal to every ancestor''s value. The root node is always good because it has no ancestors.

**Example 1:**
```
Input: root = [3,1,4,3,null,1,5]
Output: 4
Explanation: The good nodes are 3 (root), 4, 3 (left-left grandchild), and 5. Node 1 (left child of root) is not good because its ancestor 3 > 1. Node 1 (left child of 4) is not good because 4 > 1.
```

**Example 2:**
```
Input: root = [3,3,null,4,2]
Output: 3
Explanation: Nodes 3 (root), 3 (left child), and 4 are good. Node 2 is not good because its ancestor 3 > 2.
```

**Example 3:**
```
Input: root = [1]
Output: 1
Explanation: The root is always a good node.
```'
WHERE slug = 'good-node-count';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, count the number of **good nodes**.

A node is considered **good** if no node along the path from the root to that node has a value strictly greater than the node''s own value. In other words, a node is good when its value is greater than or equal to every ancestor''s value. The root node is always good because it has no ancestors.

**Example 1:**
```
Input: root = [3,1,4,3,null,1,5]
Output: 4
Explanation: The good nodes are 3 (root), 4, 3 (left-left grandchild), and 5. Node 1 (left child of root) is not good because its ancestor 3 > 1. Node 1 (left child of 4) is not good because 4 > 1.
```

**Example 2:**
```
Input: root = [3,3,null,4,2]
Output: 3
Explanation: Nodes 3 (root), 3 (left child), and 4 are good. Node 2 is not good because its ancestor 3 > 2.
```

**Example 3:**
```
Input: root = [1]
Output: 1
Explanation: The root is always a good node.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'good-node-count')
  AND locale = 'en';

------------------------------------------------------------
-- height-check
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, determine whether the tree is **height-balanced**.

A binary tree is height-balanced when, for every node, the difference in height between its left and right subtrees is at most `1`.

An empty tree is considered balanced.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: true
Explanation: The left subtree has height 1 and the right subtree has height 2. The difference is at most 1 for every node.
```

**Example 2:**
```
Input: root = [1,2,2,3,3,null,null,4,4]
Output: false
Explanation: The left subtree has height 3 while the right subtree has height 1.
```

**Example 3:**
```
Input: root = []
Output: true
Explanation: An empty tree is considered balanced.
```'
WHERE slug = 'height-check';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, determine whether the tree is **height-balanced**.

A binary tree is height-balanced when, for every node, the difference in height between its left and right subtrees is at most `1`.

An empty tree is considered balanced.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: true
Explanation: The left subtree has height 1 and the right subtree has height 2. The difference is at most 1 for every node.
```

**Example 2:**
```
Input: root = [1,2,2,3,3,null,null,4,4]
Output: false
Explanation: The left subtree has height 3 while the right subtree has height 1.
```

**Example 3:**
```
Input: root = []
Output: true
Explanation: An empty tree is considered balanced.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-check')
  AND locale = 'en';

------------------------------------------------------------
-- zigzag-levels
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, return its node values grouped by level in **zigzag** order.

Zigzag order means the first level (root) is read left-to-right, the second level right-to-left, the third level left-to-right again, and so on, alternating direction at each level.

Return the result as an array of arrays, where each inner array contains the node values for that level in the specified order.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[20,9],[15,7]]
Explanation: Level 0 is left-to-right: [3]. Level 1 is right-to-left: [20,9]. Level 2 is left-to-right: [15,7].
```

**Example 2:**
```
Input: root = [1]
Output: [[1]]
```

**Example 3:**
```
Input: root = []
Output: []
```'
WHERE slug = 'zigzag-levels';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, return its node values grouped by level in **zigzag** order.

Zigzag order means the first level (root) is read left-to-right, the second level right-to-left, the third level left-to-right again, and so on, alternating direction at each level.

Return the result as an array of arrays, where each inner array contains the node values for that level in the specified order.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[20,9],[15,7]]
Explanation: Level 0 is left-to-right: [3]. Level 1 is right-to-left: [20,9]. Level 2 is left-to-right: [15,7].
```

**Example 2:**
```
Input: root = [1]
Output: [[1]]
```

**Example 3:**
```
Input: root = []
Output: []
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zigzag-levels')
  AND locale = 'en';

------------------------------------------------------------
-- target-path
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree and an integer `target`, find all **root-to-leaf** paths where the node values along the path sum to `target`.

A **leaf** is a node with no children. Return each path as an array of node values from root to leaf.

**Example 1:**
```
Input: root = [5,4,8,11,null,13,4,7,2,null,null,5,1], target = 22
Output: [[5,4,11,2],[5,8,4,5]]
Explanation: There are two paths whose values sum to 22: 5 + 4 + 11 + 2 = 22, and 5 + 8 + 4 + 5 = 22.
```

**Example 2:**
```
Input: root = [1,2,3], target = 5
Output: []
Explanation: No root-to-leaf path has a sum of 5.
```

**Example 3:**
```
Input: root = [1,2], target = 3
Output: [[1,2]]
```'
WHERE slug = 'target-path';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree and an integer `target`, find all **root-to-leaf** paths where the node values along the path sum to `target`.

A **leaf** is a node with no children. Return each path as an array of node values from root to leaf.

**Example 1:**
```
Input: root = [5,4,8,11,null,13,4,7,2,null,null,5,1], target = 22
Output: [[5,4,11,2],[5,8,4,5]]
Explanation: There are two paths whose values sum to 22: 5 + 4 + 11 + 2 = 22, and 5 + 8 + 4 + 5 = 22.
```

**Example 2:**
```
Input: root = [1,2,3], target = 5
Output: []
Explanation: No root-to-leaf path has a sum of 5.
```

**Example 3:**
```
Input: root = [1,2], target = 3
Output: [[1,2]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-path')
  AND locale = 'en';

------------------------------------------------------------
-- right-pointers
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a **perfect binary tree** where every parent has exactly two children and all leaves are on the same level. Each node has an additional `next` pointer, initially set to `null`.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Set each node''s `next` pointer to the node immediately to its right on the same level. If there is no node to the right, `next` should remain `null`.

Return the root of the modified tree.

**Example 1:**
```
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: The tree has three levels.
- Level 0: 1 -> null
- Level 1: 2 -> 3 -> null
- Level 2: 4 -> 5 -> 6 -> 7 -> null
The serialization uses # to mark the end of each level''s chain.
```

**Example 2:**
```
Input: root = [1]
Output: [1,#]
Explanation: A single root node has no right neighbor.
```

**Example 3:**
```
Input: root = [1,2,3]
Output: [1,#,2,3,#]
```'
WHERE slug = 'right-pointers';

UPDATE problem_translations
SET description = 'You are given a **perfect binary tree** where every parent has exactly two children and all leaves are on the same level. Each node has an additional `next` pointer, initially set to `null`.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Set each node''s `next` pointer to the node immediately to its right on the same level. If there is no node to the right, `next` should remain `null`.

Return the root of the modified tree.

**Example 1:**
```
Input: root = [1,2,3,4,5,6,7]
Output: [1,#,2,3,#,4,5,6,7,#]
Explanation: The tree has three levels.
- Level 0: 1 -> null
- Level 1: 2 -> 3 -> null
- Level 2: 4 -> 5 -> 6 -> 7 -> null
The serialization uses # to mark the end of each level''s chain.
```

**Example 2:**
```
Input: root = [1]
Output: [1,#]
Explanation: A single root node has no right neighbor.
```

**Example 3:**
```
Input: root = [1,2,3]
Output: [1,#,2,3,#]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-pointers')
  AND locale = 'en';

------------------------------------------------------------
-- root-sum
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree where each node contains a single digit (`0`-`9`), compute the sum of all numbers formed by root-to-leaf paths.

Each root-to-leaf path represents a number built by concatenating the digits along the way. For example, the path `1 -> 2 -> 3` represents the number `123`.

Return the total sum of all such numbers across every root-to-leaf path.

**Example 1:**
```
Input: root = [1,2,3]
Output: 25
Explanation: The path 1 -> 2 forms 12, and 1 -> 3 forms 13. The total is 12 + 13 = 25.
```

**Example 2:**
```
Input: root = [4,9,0,5,1]
Output: 1026
Explanation: 4 -> 9 -> 5 = 495, 4 -> 9 -> 1 = 491, 4 -> 0 = 40. Total = 495 + 491 + 40 = 1026.
```

**Example 3:**
```
Input: root = [7]
Output: 7
Explanation: The tree has only one node, which is both root and leaf. The only number is 7.
```'
WHERE slug = 'root-sum';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree where each node contains a single digit (`0`-`9`), compute the sum of all numbers formed by root-to-leaf paths.

Each root-to-leaf path represents a number built by concatenating the digits along the way. For example, the path `1 -> 2 -> 3` represents the number `123`.

Return the total sum of all such numbers across every root-to-leaf path.

**Example 1:**
```
Input: root = [1,2,3]
Output: 25
Explanation: The path 1 -> 2 forms 12, and 1 -> 3 forms 13. The total is 12 + 13 = 25.
```

**Example 2:**
```
Input: root = [4,9,0,5,1]
Output: 1026
Explanation: 4 -> 9 -> 5 = 495, 4 -> 9 -> 1 = 491, 4 -> 0 = 40. Total = 495 + 491 + 40 = 1026.
```

**Example 3:**
```
Input: root = [7]
Output: 7
Explanation: The tree has only one node, which is both root and leaf. The only number is 7.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'root-sum')
  AND locale = 'en';

------------------------------------------------------------
-- flatten-tree
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, flatten it **in-place** into a singly linked list using the right pointers.

The nodes in the flattened list must appear in the same order as a **pre-order** traversal of the original tree. Every node''s `left` pointer must be set to `null`, and the `right` pointer should point to the next node in the pre-order sequence.

**Example 1:**
```
Input: root = [1,2,5,3,4,null,6]
Output: [1,2,3,4,5,6]
Explanation: The tree is flattened into: 1 -> 2 -> 3 -> 4 -> 5 -> 6 using right pointers.
```

**Example 2:**
```
Input: root = []
Output: []
```

**Example 3:**
```
Input: root = [0]
Output: [0]
```',
    constraints = 'The number of nodes in the tree is in the range [0, 2000].
-100 <= Node.val <= 100'
WHERE slug = 'flatten-tree';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, flatten it **in-place** into a singly linked list using the right pointers.

The nodes in the flattened list must appear in the same order as a **pre-order** traversal of the original tree. Every node''s `left` pointer must be set to `null`, and the `right` pointer should point to the next node in the pre-order sequence.

**Example 1:**
```
Input: root = [1,2,5,3,4,null,6]
Output: [1,2,3,4,5,6]
Explanation: The tree is flattened into: 1 -> 2 -> 3 -> 4 -> 5 -> 6 using right pointers.
```

**Example 2:**
```
Input: root = []
Output: []
```

**Example 3:**
```
Input: root = [0]
Output: [0]
```',
    constraints = 'The number of nodes in the tree is in the range [0, 2000].
-100 <= Node.val <= 100'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flatten-tree')
  AND locale = 'en';

------------------------------------------------------------
-- tree-ancestor
------------------------------------------------------------
UPDATE problems
SET description = 'Given a binary tree and two nodes `p` and `q`, find the **lowest common ancestor** (LCA) of the two nodes.

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
```'
WHERE slug = 'tree-ancestor';

UPDATE problem_translations
SET description = 'Given a binary tree and two nodes `p` and `q`, find the **lowest common ancestor** (LCA) of the two nodes.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-ancestor')
  AND locale = 'en';

------------------------------------------------------------
-- job-scheduler
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an array of jobs represented by characters, where each character identifies the job type. You are also given an integer `n` representing the **cooldown period** between two executions of the same job type.

In each time unit, you can either execute one job or remain idle. Two executions of the same job type must be separated by at least `n` time units. Jobs can be completed in any order.

Return the minimum number of time units needed to finish all jobs.

**Example 1:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 2
Output: 8
Explanation: One valid schedule is A -> B -> idle -> A -> B -> idle -> A -> B. There are 8 total intervals.
```

**Example 2:**
```
Input: jobs = ["A","C","A","B","D","B"], n = 1
Output: 6
Explanation: One valid schedule is A -> B -> C -> D -> A -> B. No idle time is needed since all identical jobs are already spaced apart.
```

**Example 3:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 0
Output: 6
Explanation: With no cooldown, all jobs can run back to back in 6 intervals.
```'
WHERE slug = 'job-scheduler';

UPDATE problem_translations
SET description = 'You are given an array of jobs represented by characters, where each character identifies the job type. You are also given an integer `n` representing the **cooldown period** between two executions of the same job type.

In each time unit, you can either execute one job or remain idle. Two executions of the same job type must be separated by at least `n` time units. Jobs can be completed in any order.

Return the minimum number of time units needed to finish all jobs.

**Example 1:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 2
Output: 8
Explanation: One valid schedule is A -> B -> idle -> A -> B -> idle -> A -> B. There are 8 total intervals.
```

**Example 2:**
```
Input: jobs = ["A","C","A","B","D","B"], n = 1
Output: 6
Explanation: One valid schedule is A -> B -> C -> D -> A -> B. No idle time is needed since all identical jobs are already spaced apart.
```

**Example 3:**
```
Input: jobs = ["A","A","A","B","B","B"], n = 0
Output: 6
Explanation: With no cooldown, all jobs can run back to back in 6 intervals.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'job-scheduler')
  AND locale = 'en';
