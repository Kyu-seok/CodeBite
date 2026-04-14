-- Phase 2 Batch 2: 7 problems — Binary Search (3) + Linked Lists (4)

------------------------------------------------------------
-- BINARY SEARCH
------------------------------------------------------------

-- Search Rotated Array (Search in Rotated Sorted Array)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Search Rotated Array',
    'search-rotated-array',
    'There is an integer array `nums` sorted in ascending order (with distinct values) that has been rotated at an unknown pivot index.

Given a `target` value, return its index if found in `nums`, or `-1` if it is not.

You must write an algorithm with **O(log n)** runtime complexity.

**Example 1:**
```
Input: nums = [4,5,6,7,0,1,2], target = 0
Output: 4
```

**Example 2:**
```
Input: nums = [4,5,6,7,0,1,2], target = 3
Output: -1
```

**Example 3:**
```
Input: nums = [1], target = 0
Output: -1
```',
    'MEDIUM',
    '1 <= nums.length <= 5000
-10^4 <= nums[i] <= 10^4
All values of nums are unique.
nums is guaranteed to be rotated at some pivot.
-10^4 <= target <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), '[4,5,6,7,0,1,2]
0', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), '[4,5,6,7,0,1,2]
3', '-1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), '[1]
0', '-1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), '[3,1]
1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), '[5,1,3]
5', '0', FALSE, 5);

-- Koko Bananas (Koko Eating Bananas)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Koko Bananas',
    'koko-bananas',
    'Koko loves to eat bananas. There are `n` piles of bananas, where the `i`-th pile has `piles[i]` bananas. The guards will return in `h` hours.

Koko can decide her bananas-per-hour eating speed of `k`. Each hour, she chooses a pile and eats `k` bananas from it. If the pile has less than `k` bananas, she eats all of them and will not eat any more during that hour.

Return the minimum integer `k` such that she can eat all the bananas within `h` hours.

**Example 1:**
```
Input: piles = [3,6,7,11], h = 8
Output: 4
```

**Example 2:**
```
Input: piles = [30,11,23,4,20], h = 5
Output: 30
```

**Example 3:**
```
Input: piles = [30,11,23,4,20], h = 6
Output: 23
```',
    'MEDIUM',
    '1 <= piles.length <= 10^4
piles.length <= h <= 10^9
1 <= piles[i] <= 10^9',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), '[3,6,7,11]
8', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), '[30,11,23,4,20]
5', '30', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), '[30,11,23,4,20]
6', '23', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), '[1000000000]
2', '500000000', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), '[2,2]
2', '2', FALSE, 5);

-- Find Peak (Find Peak Element)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Find Peak',
    'find-peak',
    'A peak element is an element that is strictly greater than its neighbors.

Given a **0-indexed** integer array `nums`, find a peak element and return its index. If the array contains multiple peaks, return the index to **any** of the peaks.

You may imagine that `nums[-1] = nums[n] = -∞`. In other words, an element is always considered to be strictly greater than a neighbor that is outside the array.

You must write an algorithm that runs in **O(log n)** time.

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
```',
    'MEDIUM',
    '1 <= nums.length <= 1000
-2^31 <= nums[i] <= 2^31 - 1
nums[i] != nums[i + 1] for all valid i.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2,3,1]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2,1,3,5,6,4]', '5', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[3,2,1]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2,3]', '2', FALSE, 5);

------------------------------------------------------------
-- LINKED LISTS
------------------------------------------------------------

-- Reorder List
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Reorder List',
    'reorder-list',
    'You are given the head of a singly linked list: `L0 → L1 → … → Ln-1 → Ln`.

Reorder the list to be: `L0 → Ln → L1 → Ln-1 → L2 → Ln-2 → …`

You may **not** modify the values in the list''s nodes. Only nodes themselves may be changed.

**Example 1:**
```
Input: head = [1,2,3,4]
Output: [1,4,2,3]
```

**Example 2:**
```
Input: head = [1,2,3,4,5]
Output: [1,5,2,4,3]
```',
    'MEDIUM',
    'The number of nodes is in the range [1, 5 * 10^4].
1 <= Node.val <= 1000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3,4]', '[1,4,2,3]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3,4,5]', '[1,5,2,4,3]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1]', '[1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2]', '[1,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'reorder-list'), '[1,2,3]', '[1,3,2]', FALSE, 5);

-- Add Two Numbers
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Add Two Numbers',
    'add-two-numbers',
    'You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in **reverse order**, and each of their nodes contains a single digit. Add the two numbers and return the sum as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

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
```',
    'MEDIUM',
    'The number of nodes in each linked list is in the range [1, 100].
0 <= Node.val <= 9
It is guaranteed that the list represents a number that does not have leading zeros.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), '[2,4,3]
[5,6,4]', '[7,0,8]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), '[0]
[0]', '[0]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), '[9,9,9,9,9,9,9]
[9,9,9,9]', '[8,9,9,9,0,0,0,1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), '[1]
[9,9]', '[0,0,1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), '[5]
[5]', '[0,1]', FALSE, 5);

-- Copy Random List (Copy List with Random Pointer)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Copy Random List',
    'copy-random-list',
    'A linked list of length `n` is given such that each node contains an additional random pointer, which could point to any node in the list, or `null`.

Construct a **deep copy** of the list. The deep copy should consist of exactly `n` **brand new** nodes, where each new node has its value set to the value of its corresponding original node. Both the `next` and `random` pointer of the new nodes should point to new nodes in the copied list such that the pointers in the original list and copied list represent the same list state. None of the pointers in the new list should point to nodes in the original list.

Return the head of the copied linked list.

The input is represented as pairs `[val, random_index]` where `random_index` is the index of the node the random pointer points to, or `null` if it points to nothing.

**Example 1:**
```
Input: head = [[7,null],[13,0],[11,4],[10,2],[1,0]]
Output: [[7,null],[13,0],[11,4],[10,2],[1,0]]
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
```',
    'MEDIUM',
    '0 <= n <= 1000
-10^4 <= Node.val <= 10^4
Node.random is null or is pointing to some node in the linked list.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[7,null],[13,0],[11,4],[10,2],[1,0]]', '[[7,null],[13,0],[11,4],[10,2],[1,0]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,1],[2,1]]', '[[1,1],[2,1]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[3,null],[3,0],[3,null]]', '[[3,null],[3,0],[3,null]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,null]]', '[[1,null]]', FALSE, 5);

-- Merge K Lists (Merge K Sorted Lists)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Merge K Lists',
    'merge-k-lists',
    'You are given an array of `k` linked lists `lists`, each linked list is sorted in ascending order.

Merge all the linked lists into one sorted linked list and return it.

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
```',
    'HARD',
    'k == lists.length
0 <= k <= 10^4
0 <= lists[i].length <= 500
-10^4 <= lists[i][j] <= 10^4
lists[i] is sorted in ascending order.
The sum of lists[i].length will not exceed 10^4.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[1,4,5],[1,3,4],[2,6]]', '[1,1,2,3,4,4,5,6]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[]]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[1],[2],[3]]', '[1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[5,10],[1,2,3],[4,6,8]]', '[1,2,3,4,5,6,8,10]', FALSE, 5);

------------------------------------------------------------
-- ENGLISH TRANSLATIONS
------------------------------------------------------------

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'search-rotated-array', 'koko-bananas', 'find-peak',
    'reorder-list', 'add-two-numbers', 'copy-random-list', 'merge-k-lists'
);
