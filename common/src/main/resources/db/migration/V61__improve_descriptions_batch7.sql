-- Improve descriptions: batch 7
-- Slugs: search-rotated-array, koko-bananas, find-peak,
--         reorder-list, add-two-numbers, copy-random-list,
--         merge-k-lists, kth-smallest-bst, build-tree,
--         right-side-view

------------------------------------------------------------
-- search-rotated-array
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` sorted in ascending order with **distinct** values, that has been rotated at an unknown pivot index, and a `target` value, return the index of `target` in `nums`, or `-1` if it is not present.

For example, the array `[0,1,2,4,5,6,7]` might be rotated at pivot index 3, becoming `[4,5,6,7,0,1,2]`.

Your algorithm must run in **O(log n)** time.

**Example 1:**
```
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
Explanation: The value 0 is located at index 4 in the rotated array.
```

**Example 2:**
```
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
Explanation: The value 3 does not exist in the array.
```

**Example 3:**
```
Input: nums = [1], target = 0
Output: -1
```'
WHERE slug = 'search-rotated-array';

UPDATE problem_translations
SET description = 'Given an integer array `nums` sorted in ascending order with **distinct** values, that has been rotated at an unknown pivot index, and a `target` value, return the index of `target` in `nums`, or `-1` if it is not present.

For example, the array `[0,1,2,4,5,6,7]` might be rotated at pivot index 3, becoming `[4,5,6,7,0,1,2]`.

Your algorithm must run in **O(log n)** time.

**Example 1:**
```
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
Explanation: The value 0 is located at index 4 in the rotated array.
```

**Example 2:**
```
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
Explanation: The value 3 does not exist in the array.
```

**Example 3:**
```
Input: nums = [1], target = 0
Output: -1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'search-rotated-array')
  AND locale = 'en';

------------------------------------------------------------
-- koko-bananas
------------------------------------------------------------
UPDATE problems
SET description = 'There are `n` piles of bananas, where the `i`-th pile has `piles[i]` bananas. A guard will return in `h` hours.

You can choose an eating speed of `k` bananas per hour. Each hour, you pick one pile and eat `k` bananas from it. If the pile has fewer than `k` bananas, you eat the entire pile and do nothing for the rest of that hour.

Return the minimum integer `k` such that all bananas can be eaten within `h` hours.

**Example 1:**
```
Input: piles = [3,6,7,11], h = 8
Output: 4
Explanation: At speed 4, the hours needed per pile are [1,2,2,3], totaling 8 hours.
```

**Example 2:**
```
Input: piles = [30,11,23,4,20], h = 5
Output: 30
Explanation: With only 5 hours and 5 piles, each pile must be finished in one hour.
```

**Example 3:**
```
Input: piles = [30,11,23,4,20], h = 6
Output: 23
```'
WHERE slug = 'koko-bananas';

UPDATE problem_translations
SET description = 'There are `n` piles of bananas, where the `i`-th pile has `piles[i]` bananas. A guard will return in `h` hours.

You can choose an eating speed of `k` bananas per hour. Each hour, you pick one pile and eat `k` bananas from it. If the pile has fewer than `k` bananas, you eat the entire pile and do nothing for the rest of that hour.

Return the minimum integer `k` such that all bananas can be eaten within `h` hours.

**Example 1:**
```
Input: piles = [3,6,7,11], h = 8
Output: 4
Explanation: At speed 4, the hours needed per pile are [1,2,2,3], totaling 8 hours.
```

**Example 2:**
```
Input: piles = [30,11,23,4,20], h = 5
Output: 30
Explanation: With only 5 hours and 5 piles, each pile must be finished in one hour.
```

**Example 3:**
```
Input: piles = [30,11,23,4,20], h = 6
Output: 23
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'koko-bananas')
  AND locale = 'en';

------------------------------------------------------------
-- find-peak
------------------------------------------------------------
UPDATE problems
SET description = 'A **peak element** is an element that is strictly greater than its neighbors.

Given a 0-indexed integer array `nums`, return the index of any peak element.

You may assume that `nums[-1]` and `nums[n]` are both negative infinity. In other words, an element at the boundary only needs to be greater than its single neighbor.

If the array contains multiple peaks, returning the index of any one is acceptable.

Your algorithm must run in **O(log n)** time.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: 2
Explanation: 3 is a peak element and your function should return the index 2.
```

**Example 2:**
```
Input: nums = [1,2,1,3,5,6,4]
Output: 5
Explanation: Your function can return either index 1 (value 2) or index 5 (value 6).
```'
WHERE slug = 'find-peak';

UPDATE problem_translations
SET description = 'A **peak element** is an element that is strictly greater than its neighbors.

Given a 0-indexed integer array `nums`, return the index of any peak element.

You may assume that `nums[-1]` and `nums[n]` are both negative infinity. In other words, an element at the boundary only needs to be greater than its single neighbor.

If the array contains multiple peaks, returning the index of any one is acceptable.

Your algorithm must run in **O(log n)** time.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: 2
Explanation: 3 is a peak element and your function should return the index 2.
```

**Example 2:**
```
Input: nums = [1,2,1,3,5,6,4]
Output: 5
Explanation: Your function can return either index 1 (value 2) or index 5 (value 6).
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-peak')
  AND locale = 'en';

------------------------------------------------------------
-- reorder-list
------------------------------------------------------------
UPDATE problems
SET description = 'Given the head of a singly linked list with nodes `L0 -> L1 -> ... -> Ln-1 -> Ln`, reorder it into the following form:

`L0 -> Ln -> L1 -> Ln-1 -> L2 -> Ln-2 -> ...`

You must not modify the values in the nodes. Only the node links themselves may be rearranged.

**Example 1:**
```
Input: head = [1,2,3,4]
Output: [1,4,2,3]
Explanation: The list is interleaved from both ends: 1->4->2->3.
```

**Example 2:**
```
Input: head = [1,2,3,4,5]
Output: [1,5,2,4,3]
Explanation: Nodes are taken alternately from the front and back.
```'
WHERE slug = 'reorder-list';

UPDATE problem_translations
SET description = 'Given the head of a singly linked list with nodes `L0 -> L1 -> ... -> Ln-1 -> Ln`, reorder it into the following form:

`L0 -> Ln -> L1 -> Ln-1 -> L2 -> Ln-2 -> ...`

You must not modify the values in the nodes. Only the node links themselves may be rearranged.

**Example 1:**
```
Input: head = [1,2,3,4]
Output: [1,4,2,3]
Explanation: The list is interleaved from both ends: 1->4->2->3.
```

**Example 2:**
```
Input: head = [1,2,3,4,5]
Output: [1,5,2,4,3]
Explanation: Nodes are taken alternately from the front and back.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reorder-list')
  AND locale = 'en';

------------------------------------------------------------
-- add-two-numbers
------------------------------------------------------------
UPDATE problems
SET description = 'You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in **reverse order**, meaning the ones digit is at the head of the list. Each node contains a single digit.

Add the two numbers and return the sum as a linked list in the same reverse-digit order.

You may assume neither number has leading zeros, except for the number `0` itself.

**Example 1:**
```
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**Example 2:**
```
Input: l1 = [0], l2 = [0]
Output: [0]
```

**Example 3:**
```
Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
Output: [8,9,9,9,0,0,0,1]
```'
WHERE slug = 'add-two-numbers';

UPDATE problem_translations
SET description = 'You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in **reverse order**, meaning the ones digit is at the head of the list. Each node contains a single digit.

Add the two numbers and return the sum as a linked list in the same reverse-digit order.

You may assume neither number has leading zeros, except for the number `0` itself.

**Example 1:**
```
Input: l1 = [2,4,3], l2 = [5,6,4]
Output: [7,0,8]
Explanation: 342 + 465 = 807.
```

**Example 2:**
```
Input: l1 = [0], l2 = [0]
Output: [0]
```

**Example 3:**
```
Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
Output: [8,9,9,9,0,0,0,1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'add-two-numbers')
  AND locale = 'en';

------------------------------------------------------------
-- copy-random-list
------------------------------------------------------------
UPDATE problems
SET description = 'A linked list of length `n` is given where each node has two pointers:

- `next` -- points to the next node in the list (or `null`).
- `random` -- points to any node in the list, or `null`.

Construct a **deep copy** of the list. The copy must consist of exactly `n` brand-new nodes. Each new node''s `next` and `random` pointers must refer only to nodes in the copied list, never to nodes in the original.

Return the head of the copied linked list.

The input is represented as an array of pairs `[val, random_index]`, where `random_index` is the 0-based index of the node that the `random` pointer targets, or `null` if it points to nothing.

**Example 1:**
```
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
Explanation: Each node is cloned with its random pointer preserved.
```

**Example 2:**
```
Input: head = [[1,1],[2,1]]
Output: [[1,1],[2,1]]
```

**Example 3:**
```
Input: head = [[3,null],[3,0],[3,null]]
Output: [[3,null],[3,0],[3,null]]
```'
WHERE slug = 'copy-random-list';

UPDATE problem_translations
SET description = 'A linked list of length `n` is given where each node has two pointers:

- `next` -- points to the next node in the list (or `null`).
- `random` -- points to any node in the list, or `null`.

Construct a **deep copy** of the list. The copy must consist of exactly `n` brand-new nodes. Each new node''s `next` and `random` pointers must refer only to nodes in the copied list, never to nodes in the original.

Return the head of the copied linked list.

The input is represented as an array of pairs `[val, random_index]`, where `random_index` is the 0-based index of the node that the `random` pointer targets, or `null` if it points to nothing.

**Example 1:**
```
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
Explanation: Each node is cloned with its random pointer preserved.
```

**Example 2:**
```
Input: head = [[1,1],[2,1]]
Output: [[1,1],[2,1]]
```

**Example 3:**
```
Input: head = [[3,null],[3,0],[3,null]]
Output: [[3,null],[3,0],[3,null]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'copy-random-list')
  AND locale = 'en';

------------------------------------------------------------
-- merge-k-lists
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of `k` linked lists, where each list is sorted in ascending order, merge all of them into a single sorted linked list and return it.

**Example 1:**
```
Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
Explanation: The linked lists are:
  1->4->5
  1->3->4
  2->6
Merging them into one sorted list: 1->1->2->3->4->4->5->6
```

**Example 2:**
```
Input: lists = []
Output: []
```

**Example 3:**
```
Input: lists = [[]]
Output: []
```'
WHERE slug = 'merge-k-lists';

UPDATE problem_translations
SET description = 'Given an array of `k` linked lists, where each list is sorted in ascending order, merge all of them into a single sorted linked list and return it.

**Example 1:**
```
Input: lists = [[1,4,5],[1,3,4],[2,6]]
Output: [1,1,2,3,4,4,5,6]
Explanation: The linked lists are:
  1->4->5
  1->3->4
  2->6
Merging them into one sorted list: 1->1->2->3->4->4->5->6
```

**Example 2:**
```
Input: lists = []
Output: []
```

**Example 3:**
```
Input: lists = [[]]
Output: []
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-k-lists')
  AND locale = 'en';

------------------------------------------------------------
-- kth-smallest-bst
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary search tree and an integer `k`, return the `k`th smallest value among all node values in the tree.

The value of `k` is **1-indexed**, meaning `k = 1` returns the smallest element, `k = 2` returns the second smallest, and so on.

**Example 1:**
```
Input: root = [3,1,4,null,2], k = 1
Output: 1
Explanation: The in-order traversal is [1,2,3,4]. The 1st smallest value is 1.
```

**Example 2:**
```
Input: root = [5,3,6,2,4,null,null,1], k = 3
Output: 3
Explanation: The in-order traversal is [1,2,3,4,5,6]. The 3rd smallest value is 3.
```'
WHERE slug = 'kth-smallest-bst';

UPDATE problem_translations
SET description = 'Given the `root` of a binary search tree and an integer `k`, return the `k`th smallest value among all node values in the tree.

The value of `k` is **1-indexed**, meaning `k = 1` returns the smallest element, `k = 2` returns the second smallest, and so on.

**Example 1:**
```
Input: root = [3,1,4,null,2], k = 1
Output: 1
Explanation: The in-order traversal is [1,2,3,4]. The 1st smallest value is 1.
```

**Example 2:**
```
Input: root = [5,3,6,2,4,null,null,1], k = 3
Output: 3
Explanation: The in-order traversal is [1,2,3,4,5,6]. The 3rd smallest value is 3.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-smallest-bst')
  AND locale = 'en';

------------------------------------------------------------
-- build-tree
------------------------------------------------------------
UPDATE problems
SET description = 'Given two integer arrays `preorder` and `inorder`, construct and return the binary tree they describe.

- `preorder` contains the nodes in **preorder traversal** order (root, left, right).
- `inorder` contains the nodes in **inorder traversal** order (left, root, right).

Both arrays have the same length, and all values are unique.

**Example 1:**
```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]
Explanation: The root is 3, left subtree contains [9], and right subtree contains [20,15,7].
```

**Example 2:**
```
Input: preorder = [-1], inorder = [-1]
Output: [-1]
```'
WHERE slug = 'build-tree';

UPDATE problem_translations
SET description = 'Given two integer arrays `preorder` and `inorder`, construct and return the binary tree they describe.

- `preorder` contains the nodes in **preorder traversal** order (root, left, right).
- `inorder` contains the nodes in **inorder traversal** order (left, root, right).

Both arrays have the same length, and all values are unique.

**Example 1:**
```
Input: preorder = [3,9,20,15,7], inorder = [9,3,15,20,7]
Output: [3,9,20,null,null,15,7]
Explanation: The root is 3, left subtree contains [9], and right subtree contains [20,15,7].
```

**Example 2:**
```
Input: preorder = [-1], inorder = [-1]
Output: [-1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-tree')
  AND locale = 'en';

------------------------------------------------------------
-- right-side-view
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, imagine yourself standing on the **right side** of it and looking left.

Return the values of the nodes you can see, ordered from top to bottom. At each level of the tree, only the rightmost visible node is included.

**Example 1:**
```
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]
Explanation: At level 0 you see node 1, at level 1 you see node 3, at level 2 you see node 4.
```

**Example 2:**
```
Input: root = [1,null,3]
Output: [1,3]
```

**Example 3:**
```
Input: root = []
Output: []
```'
WHERE slug = 'right-side-view';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, imagine yourself standing on the **right side** of it and looking left.

Return the values of the nodes you can see, ordered from top to bottom. At each level of the tree, only the rightmost visible node is included.

**Example 1:**
```
Input: root = [1,2,3,null,5,null,4]
Output: [1,3,4]
Explanation: At level 0 you see node 1, at level 1 you see node 3, at level 2 you see node 4.
```

**Example 2:**
```
Input: root = [1,null,3]
Output: [1,3]
```

**Example 3:**
```
Input: root = []
Output: []
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-side-view')
  AND locale = 'en';
