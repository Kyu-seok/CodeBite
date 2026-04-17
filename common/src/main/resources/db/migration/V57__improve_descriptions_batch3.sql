-- Improve descriptions: batch 3

------------------------------------------------------------
-- matrix-search
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` integer matrix, determine whether a given `target` value exists in it. The matrix has the following properties:

- Each row is sorted in non-decreasing order.
- The first integer of each row is greater than the last integer of the previous row.

In other words, if you read the matrix row by row from left to right, the values form a single sorted sequence.

Your solution must run in `O(log(m * n))` time.

**Example 1:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true
Explanation: The value 3 exists in the first row.
```

**Example 2:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13
Output: false
Explanation: The value 13 does not appear anywhere in the matrix.
```'
WHERE slug = 'matrix-search';

UPDATE problem_translations
SET description = 'Given an `m x n` integer matrix, determine whether a given `target` value exists in it. The matrix has the following properties:

- Each row is sorted in non-decreasing order.
- The first integer of each row is greater than the last integer of the previous row.

In other words, if you read the matrix row by row from left to right, the values form a single sorted sequence.

Your solution must run in `O(log(m * n))` time.

**Example 1:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true
Explanation: The value 3 exists in the first row.
```

**Example 2:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13
Output: false
Explanation: The value 13 does not appear anywhere in the matrix.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search')
  AND locale = 'en';

------------------------------------------------------------
-- rotated-array-min
------------------------------------------------------------
UPDATE problems
SET description = 'An array of length `n`, originally sorted in ascending order, has been **rotated** between `1` and `n` times. Each rotation shifts all elements one position to the right, wrapping the last element to the front. For example, `[0,1,2,4,5,6,7]` might become `[4,5,6,7,0,1,2]` after four rotations.

Given the rotated array `nums` containing unique elements, return the minimum element.

Your solution must run in `O(log n)` time.

**Example 1:**
```
Input: nums = [3,4,5,1,2]
Output: 1
Explanation: The original array was [1,2,3,4,5] rotated 3 times.
```

**Example 2:**
```
Input: nums = [4,5,6,7,0,1,2]
Output: 0
```

**Example 3:**
```
Input: nums = [11,13,15,17]
Output: 11
Explanation: The original array was not rotated.
```'
WHERE slug = 'rotated-array-min';

UPDATE problem_translations
SET description = 'An array of length `n`, originally sorted in ascending order, has been **rotated** between `1` and `n` times. Each rotation shifts all elements one position to the right, wrapping the last element to the front. For example, `[0,1,2,4,5,6,7]` might become `[4,5,6,7,0,1,2]` after four rotations.

Given the rotated array `nums` containing unique elements, return the minimum element.

Your solution must run in `O(log n)` time.

**Example 1:**
```
Input: nums = [3,4,5,1,2]
Output: 1
Explanation: The original array was [1,2,3,4,5] rotated 3 times.
```

**Example 2:**
```
Input: nums = [4,5,6,7,0,1,2]
Output: 0
```

**Example 3:**
```
Input: nums = [11,13,15,17]
Output: 11
Explanation: The original array was not rotated.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotated-array-min')
  AND locale = 'en';

------------------------------------------------------------
-- reverse-list
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `head` of a singly linked list, reverse the list and return the new head.

The reversal should be done in-place by re-linking the existing nodes.

**Example 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
Explanation: The list 1->2->3->4->5 becomes 5->4->3->2->1.
```

**Example 2:**
```
Input: head = [1,2]
Output: [2,1]
```

**Example 3:**
```
Input: head = []
Output: []
```'
WHERE slug = 'reverse-list';

UPDATE problem_translations
SET description = 'Given the `head` of a singly linked list, reverse the list and return the new head.

The reversal should be done in-place by re-linking the existing nodes.

**Example 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
Explanation: The list 1->2->3->4->5 becomes 5->4->3->2->1.
```

**Example 2:**
```
Input: head = [1,2]
Output: [2,1]
```

**Example 3:**
```
Input: head = []
Output: []
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-list')
  AND locale = 'en';

------------------------------------------------------------
-- merge-sorted-lists
------------------------------------------------------------
UPDATE problems
SET description = 'Given the heads of two sorted linked lists `list1` and `list2`, merge them into a single sorted linked list.

The merged list should be built by splicing together the nodes from both input lists. Return the head of the merged linked list.

**Example 1:**
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
Explanation: Merging 1->2->4 and 1->3->4 produces 1->1->2->3->4->4.
```

**Example 2:**
```
Input: list1 = [], list2 = []
Output: []
```

**Example 3:**
```
Input: list1 = [], list2 = [0]
Output: [0]
Explanation: Since list1 is empty, the result is just list2.
```'
WHERE slug = 'merge-sorted-lists';

UPDATE problem_translations
SET description = 'Given the heads of two sorted linked lists `list1` and `list2`, merge them into a single sorted linked list.

The merged list should be built by splicing together the nodes from both input lists. Return the head of the merged linked list.

**Example 1:**
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
Explanation: Merging 1->2->4 and 1->3->4 produces 1->1->2->3->4->4.
```

**Example 2:**
```
Input: list1 = [], list2 = []
Output: []
```

**Example 3:**
```
Input: list1 = [], list2 = [0]
Output: [0]
Explanation: Since list1 is empty, the result is just list2.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-sorted-lists')
  AND locale = 'en';

------------------------------------------------------------
-- cycle-detection
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `head` of a linked list, determine whether the list contains a **cycle**.

A cycle exists when a node''s `next` pointer connects back to a previous node in the list, making it possible to visit the same node again by continuously following `next` pointers. The variable `pos` indicates the index (0-based) of the node that the tail''s `next` pointer connects to. It is provided for illustration only and is not passed as a parameter.

Return `true` if the linked list has a cycle, or `false` otherwise.

**Example 1:**
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed).
```

**Example 2:**
```
Input: head = [1,2], pos = 0
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 0th node.
```

**Example 3:**
```
Input: head = [1], pos = -1
Output: false
Explanation: There is no cycle in the linked list.
```'
WHERE slug = 'cycle-detection';

UPDATE problem_translations
SET description = 'Given the `head` of a linked list, determine whether the list contains a **cycle**.

A cycle exists when a node''s `next` pointer connects back to a previous node in the list, making it possible to visit the same node again by continuously following `next` pointers. The variable `pos` indicates the index (0-based) of the node that the tail''s `next` pointer connects to. It is provided for illustration only and is not passed as a parameter.

Return `true` if the linked list has a cycle, or `false` otherwise.

**Example 1:**
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed).
```

**Example 2:**
```
Input: head = [1,2], pos = 0
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 0th node.
```

**Example 3:**
```
Input: head = [1], pos = -1
Output: false
Explanation: There is no cycle in the linked list.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cycle-detection')
  AND locale = 'en';

------------------------------------------------------------
-- remove-from-end
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `head` of a linked list, remove the `n`th node from the **end** of the list and return the updated head.

**Example 1:**
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
Explanation: The 2nd node from the end is 4. After removing it, the list becomes 1->2->3->5.
```

**Example 2:**
```
Input: head = [1], n = 1
Output: []
Explanation: The only node is removed, leaving an empty list.
```

**Example 3:**
```
Input: head = [1,2], n = 1
Output: [1]
```'
WHERE slug = 'remove-from-end';

UPDATE problem_translations
SET description = 'Given the `head` of a linked list, remove the `n`th node from the **end** of the list and return the updated head.

**Example 1:**
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
Explanation: The 2nd node from the end is 4. After removing it, the list becomes 1->2->3->5.
```

**Example 2:**
```
Input: head = [1], n = 1
Output: []
Explanation: The only node is removed, leaving an empty list.
```

**Example 3:**
```
Input: head = [1,2], n = 1
Output: [1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-from-end')
  AND locale = 'en';

------------------------------------------------------------
-- mirror-tree
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, **invert** the tree and return its root.

Inverting a binary tree means swapping every node''s left and right children, recursively, so the resulting tree is a mirror image of the original.

**Example 1:**
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
Explanation: Every left and right child pair is swapped. The node with value 2 moves to the right and 7 moves to the left.
```

**Example 2:**
```
Input: root = [2,1,3]
Output: [2,3,1]
```

**Example 3:**
```
Input: root = []
Output: []
```'
WHERE slug = 'mirror-tree';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, **invert** the tree and return its root.

Inverting a binary tree means swapping every node''s left and right children, recursively, so the resulting tree is a mirror image of the original.

**Example 1:**
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
Explanation: Every left and right child pair is swapped. The node with value 2 moves to the right and 7 moves to the left.
```

**Example 2:**
```
Input: root = [2,1,3]
Output: [2,3,1]
```

**Example 3:**
```
Input: root = []
Output: []
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-tree')
  AND locale = 'en';

------------------------------------------------------------
-- tree-depth
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, return its **maximum depth**.

The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node. A leaf is a node with no children.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
Explanation: The longest path is root(3) -> right(20) -> left(15) or root(3) -> right(20) -> right(7), both with 3 nodes.
```

**Example 2:**
```
Input: root = [1,null,2]
Output: 2
Explanation: The root has no left child. The path root(1) -> right(2) has 2 nodes.
```'
WHERE slug = 'tree-depth';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, return its **maximum depth**.

The maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node. A leaf is a node with no children.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
Explanation: The longest path is root(3) -> right(20) -> left(15) or root(3) -> right(20) -> right(7), both with 3 nodes.
```

**Example 2:**
```
Input: root = [1,null,2]
Output: 2
Explanation: The root has no left child. The path root(1) -> right(2) has 2 nodes.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-depth')
  AND locale = 'en';

------------------------------------------------------------
-- identical-trees
------------------------------------------------------------
UPDATE problems
SET description = 'Given the roots of two binary trees `p` and `q`, determine whether they are **identical**.

Two binary trees are identical if they have the same structure and every corresponding node holds the same value.

**Example 1:**
```
Input: p = [1,2,3], q = [1,2,3]
Output: true
Explanation: Both trees have the same structure and values at every node.
```

**Example 2:**
```
Input: p = [1,2], q = [1,null,2]
Output: false
Explanation: In tree p, node 2 is the left child of the root. In tree q, node 2 is the right child. The structures differ.
```

**Example 3:**
```
Input: p = [1,2,1], q = [1,1,2]
Output: false
Explanation: The structures are the same but the node values differ. Tree p has left child 2 and right child 1, while tree q has left child 1 and right child 2.
```'
WHERE slug = 'identical-trees';

UPDATE problem_translations
SET description = 'Given the roots of two binary trees `p` and `q`, determine whether they are **identical**.

Two binary trees are identical if they have the same structure and every corresponding node holds the same value.

**Example 1:**
```
Input: p = [1,2,3], q = [1,2,3]
Output: true
Explanation: Both trees have the same structure and values at every node.
```

**Example 2:**
```
Input: p = [1,2], q = [1,null,2]
Output: false
Explanation: In tree p, node 2 is the left child of the root. In tree q, node 2 is the right child. The structures differ.
```

**Example 3:**
```
Input: p = [1,2,1], q = [1,1,2]
Output: false
Explanation: The structures are the same but the node values differ. Tree p has left child 2 and right child 1, while tree q has left child 1 and right child 2.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'identical-trees')
  AND locale = 'en';

------------------------------------------------------------
-- tree-within-tree
------------------------------------------------------------
UPDATE problems
SET description = 'Given the roots of two binary trees `root` and `subRoot`, determine whether `subRoot` is a **subtree** of `root`.

A subtree of a binary tree is a node in the tree along with all of its descendants. The entire tree `root` is also considered a valid subtree of itself. Two subtrees match when they have the same structure and every corresponding node holds the same value.

**Example 1:**
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
Explanation: The left subtree of root (rooted at node 4) matches subRoot exactly.
```

**Example 2:**
```
Input: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]
Output: false
Explanation: The subtree rooted at node 4 in root has an extra child (node 0 under node 2), so it does not match subRoot.
```'
WHERE slug = 'tree-within-tree';

UPDATE problem_translations
SET description = 'Given the roots of two binary trees `root` and `subRoot`, determine whether `subRoot` is a **subtree** of `root`.

A subtree of a binary tree is a node in the tree along with all of its descendants. The entire tree `root` is also considered a valid subtree of itself. Two subtrees match when they have the same structure and every corresponding node holds the same value.

**Example 1:**
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
Explanation: The left subtree of root (rooted at node 4) matches subRoot exactly.
```

**Example 2:**
```
Input: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]
Output: false
Explanation: The subtree rooted at node 4 in root has an extra child (node 0 under node 2), so it does not match subRoot.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-within-tree')
  AND locale = 'en';
