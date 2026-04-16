-- Phase 3 Batch 3: Linked List (#118-120) + Trees (#121-128)
-- 11 problems: recent-cache, reverse-k-nodes, swap-pairs, tree-codec, good-node-count, height-check, zigzag-levels, target-path, right-pointers, root-sum, flatten-tree

------------------------------------------------------------
-- Add Recent Cache problem
-- CodeBite original name: Recent Cache (inspired by LeetCode #146 LRU Cache)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Recent Cache',
    'recent-cache',
    'Design a data structure that acts as a cache with a fixed maximum size. When the cache is full and a new entry needs to be added, the **least recently used** entry should be removed to make room.

Implement the `RecentCache` class:

- `RecentCache(int capacity)` — creates the cache with the given positive capacity.
- `int get(int key)` — returns the value associated with `key` if it exists in the cache, or `-1` if not found. Accessing a key counts as a use.
- `void put(int key, int value)` — inserts or updates the entry for `key`. If the cache already contains `key`, update its value. If inserting a new key would exceed the capacity, evict the entry that has not been used for the longest time before inserting.

Both `get` and `put` must run in **O(1)** average time.

**Example 1:**
```
Input: ["RecentCache","put","put","get","put","get","put","get","get","get"] [[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
Output: [null,null,null,10,null,-1,null,-1,30,40]
Explanation: The cache has capacity 2.
put(1,10) -> cache is {1=10}
put(2,20) -> cache is {1=10, 2=20}
get(1)    -> returns 10, cache is {2=20, 1=10}
put(3,30) -> evicts key 2, cache is {1=10, 3=30}
get(2)    -> returns -1 (evicted)
put(4,40) -> evicts key 1, cache is {3=30, 4=40}
get(1)    -> returns -1 (evicted)
get(3)    -> returns 30
get(4)    -> returns 40
```

**Example 2:**
```
Input: ["RecentCache","put","get","put","get","get"] [[1],[5,100],[5],[6,200],[5],[6]]
Output: [null,null,100,null,-1,200]
Explanation: Capacity is 1, so each put evicts the previous entry.
```

**Example 3:**
```
Input: ["RecentCache","put","put","put","get","get","get"] [[3],[1,1],[2,2],[3,3],[1],[2],[3]]
Output: [null,null,null,null,1,2,3]
Explanation: Capacity is 3, so all three entries fit without eviction.
```',
    'MEDIUM',
    '1 <= capacity <= 3000
0 <= key <= 10^4
0 <= value <= 10^5
At most 2 * 10^5 calls to get and put.',
    118,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","get","put","get","put","get","get","get"]\n[[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]', '[null,null,null,10,null,-1,null,-1,30,40]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","get","put","get","get"]\n[[1],[5,100],[5],[6,200],[5],[6]]', '[null,null,100,null,-1,200]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","get","get","get"]\n[[3],[1,1],[2,2],[3,3],[1],[2],[3]]', '[null,null,null,null,1,2,3]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","put","get","get"]\n[[2],[1,1],[2,2],[3,3],[4,4],[1],[2]]', '[null,null,null,null,null,-1,-1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","get","put","put","get"]\n[[2],[2,1],[2,2],[2],[1,1],[4,1],[2]]', '[null,null,null,2,null,null,-1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","get","put","get","put","get","get"]\n[[2],[1,10],[1],[1,20],[1],[2,30],[1],[2]]', '[null,null,10,null,20,null,20,30]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'recent-cache'),
    'en',
    'Recent Cache',
    'Design a data structure that acts as a cache with a fixed maximum size. When the cache is full and a new entry needs to be added, the **least recently used** entry should be removed to make room.

Implement the `RecentCache` class:

- `RecentCache(int capacity)` — creates the cache with the given positive capacity.
- `int get(int key)` — returns the value associated with `key` if it exists in the cache, or `-1` if not found. Accessing a key counts as a use.
- `void put(int key, int value)` — inserts or updates the entry for `key`. If the cache already contains `key`, update its value. If inserting a new key would exceed the capacity, evict the entry that has not been used for the longest time before inserting.

Both `get` and `put` must run in **O(1)** average time.

**Example 1:**
```
Input: ["RecentCache","put","put","get","put","get","put","get","get","get"] [[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
Output: [null,null,null,10,null,-1,null,-1,30,40]
Explanation: The cache has capacity 2.
put(1,10) -> cache is {1=10}
put(2,20) -> cache is {1=10, 2=20}
get(1)    -> returns 10, cache is {2=20, 1=10}
put(3,30) -> evicts key 2, cache is {1=10, 3=30}
get(2)    -> returns -1 (evicted)
put(4,40) -> evicts key 1, cache is {3=30, 4=40}
get(1)    -> returns -1 (evicted)
get(3)    -> returns 30
get(4)    -> returns 40
```

**Example 2:**
```
Input: ["RecentCache","put","get","put","get","get"] [[1],[5,100],[5],[6,200],[5],[6]]
Output: [null,null,100,null,-1,200]
Explanation: Capacity is 1, so each put evicts the previous entry.
```

**Example 3:**
```
Input: ["RecentCache","put","put","put","get","get","get"] [[3],[1,1],[2,2],[3,3],[1],[2],[3]]
Output: [null,null,null,null,1,2,3]
Explanation: Capacity is 3, so all three entries fit without eviction.
```',
    '1 <= capacity <= 3000
0 <= key <= 10^4
0 <= value <= 10^5
At most 2 * 10^5 calls to get and put.'
);

------------------------------------------------------------
-- Add Reverse K Nodes problem
-- CodeBite original name: Reverse K Nodes (inspired by LeetCode #25 Reverse Nodes in k-Group)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Reverse K Nodes',
    'reverse-k-nodes',
    'Given the `head` of a singly linked list and an integer `k`, reverse the nodes in groups of `k` consecutive elements and return the modified list.

If the number of remaining nodes at the end is less than `k`, leave those nodes in their original order.

Only the node links may be changed — you may not alter the values stored in the nodes.

**Example 1:**
```
Input: head = [1,2,3,4,5], k = 2
Output: [2,1,4,3,5]
Explanation: Pairs (1,2) and (3,4) are reversed. Node 5 has no partner, so it stays.
```

**Example 2:**
```
Input: head = [1,2,3,4,5], k = 3
Output: [3,2,1,4,5]
Explanation: The first group of three is reversed. The remaining two nodes stay as-is.
```

**Example 3:**
```
Input: head = [1,2,3,4], k = 1
Output: [1,2,3,4]
Explanation: With k = 1, every group has one node, so nothing changes.
```',
    'HARD',
    'The number of nodes in the list is n.
1 <= k <= n <= 5000
0 <= Node.val <= 1000',
    119,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5]\n2', '[2,1,4,3,5]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5]\n3', '[3,2,1,4,5]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4]\n1', '[1,2,3,4]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6]\n6', '[6,5,4,3,2,1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6,7,8]\n3', '[3,2,1,6,5,4,7,8]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[5]\n1', '[5]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'reverse-k-nodes'), E'[1,2,3,4,5,6]\n2', '[2,1,4,3,6,5]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reverse-k-nodes'),
    'en',
    'Reverse K Nodes',
    'Given the `head` of a singly linked list and an integer `k`, reverse the nodes in groups of `k` consecutive elements and return the modified list.

If the number of remaining nodes at the end is less than `k`, leave those nodes in their original order.

Only the node links may be changed — you may not alter the values stored in the nodes.

**Example 1:**
```
Input: head = [1,2,3,4,5], k = 2
Output: [2,1,4,3,5]
Explanation: Pairs (1,2) and (3,4) are reversed. Node 5 has no partner, so it stays.
```

**Example 2:**
```
Input: head = [1,2,3,4,5], k = 3
Output: [3,2,1,4,5]
Explanation: The first group of three is reversed. The remaining two nodes stay as-is.
```

**Example 3:**
```
Input: head = [1,2,3,4], k = 1
Output: [1,2,3,4]
Explanation: With k = 1, every group has one node, so nothing changes.
```',
    'The number of nodes in the list is n.
1 <= k <= n <= 5000
0 <= Node.val <= 1000'
);

------------------------------------------------------------
-- Add Swap Pairs problem
-- CodeBite original name: Swap Pairs (inspired by LeetCode #24 Swap Nodes in Pairs)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Swap Pairs',
    'swap-pairs',
    'Given the `head` of a singly linked list, swap every two adjacent nodes and return the modified list''s head. You must solve this by rearranging the node links themselves, not by changing the values stored in the nodes.

If the list has an odd number of nodes, the last node stays in place.

**Example 1:**
```
Input: head = [1,2,3,4]
Output: [2,1,4,3]
Explanation: Nodes are swapped in pairs: (1,2) become (2,1) and (3,4) become (4,3).
```

**Example 2:**
```
Input: head = [5,10]
Output: [10,5]
Explanation: The single pair is swapped.
```

**Example 3:**
```
Input: head = [1,2,3]
Output: [2,1,3]
Explanation: The first pair swaps, but 3 has no partner so it remains at the end.
```',
    'MEDIUM',
    '0 <= Number of nodes <= 100
0 <= Node.val <= 100',
    120,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3,4]', '[2,1,4,3]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[5,10]', '[10,5]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3]', '[2,1,3]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[7]', '[7]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3,4,5,6]', '[2,1,4,3,6,5]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[0,0,0,0]', '[0,0,0,0]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'swap-pairs'),
    'en',
    'Swap Pairs',
    'Given the `head` of a singly linked list, swap every two adjacent nodes and return the modified list''s head. You must solve this by rearranging the node links themselves, not by changing the values stored in the nodes.

If the list has an odd number of nodes, the last node stays in place.

**Example 1:**
```
Input: head = [1,2,3,4]
Output: [2,1,4,3]
Explanation: Nodes are swapped in pairs: (1,2) become (2,1) and (3,4) become (4,3).
```

**Example 2:**
```
Input: head = [5,10]
Output: [10,5]
Explanation: The single pair is swapped.
```

**Example 3:**
```
Input: head = [1,2,3]
Output: [2,1,3]
Explanation: The first pair swaps, but 3 has no partner so it remains at the end.
```',
    '0 <= Number of nodes <= 100
0 <= Node.val <= 100'
);

------------------------------------------------------------
-- Add Tree Codec problem
-- CodeBite original name: Tree Codec (inspired by LeetCode #297 Serialize and Deserialize Binary Tree)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Tree Codec',
    'tree-codec',
    'Design an algorithm to convert a binary tree into a string representation and reconstruct the original tree from that string.

Implement a `Codec` class with two methods:

- `serialize(root)` -- Converts a binary tree into a single string.
- `deserialize(data)` -- Reconstructs the binary tree from the string produced by `serialize`.

The encoding format is up to you, as long as `deserialize(serialize(root))` returns a tree that is structurally identical to the original with the same node values. There are no restrictions on what the serialized string looks like.

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
```',
    'HARD',
    'The number of nodes is in the range [0, 10000].
-1000 <= Node.val <= 1000',
    121,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,3,null,null,4,5]', '[1,2,3,null,null,4,5]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1]', '[1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,3,4,5,6,7]', '[1,2,3,4,5,6,7]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,null,2,null,3,null,4]', '[1,null,2,null,3,null,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,null,3,null,4]', '[1,2,null,3,null,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[5,4,7,3,null,2,null,-1,null,9]', '[5,4,7,3,null,2,null,-1,null,9]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-codec'),
    'en',
    'Tree Codec',
    'Design an algorithm to convert a binary tree into a string representation and reconstruct the original tree from that string.

Implement a `Codec` class with two methods:

- `serialize(root)` -- Converts a binary tree into a single string.
- `deserialize(data)` -- Reconstructs the binary tree from the string produced by `serialize`.

The encoding format is up to you, as long as `deserialize(serialize(root))` returns a tree that is structurally identical to the original with the same node values. There are no restrictions on what the serialized string looks like.

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
```',
    'The number of nodes is in the range [0, 10000].
-1000 <= Node.val <= 1000'
);

------------------------------------------------------------
-- Add Good Node Count problem
-- CodeBite original name: Good Node Count (inspired by LeetCode #1448 Count Good Nodes in Binary Tree)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Good Node Count',
    'good-node-count',
    'Given the `root` of a binary tree, count the number of **good** nodes.

A node is considered **good** if there is no ancestor in the path from the root to that node whose value is strictly greater than the node''s own value. The root node is always good since it has no ancestors.

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
```',
    'MEDIUM',
    'The number of nodes in the tree is in the range [1, 10^5].
Each node''s value is between -10^4 and 10^4.',
    122,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[3,1,4,3,null,1,5]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[3,3,null,4,2]', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[1]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[2,null,4,null,6]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[9,3,6,1,7,5,8]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[5,5,5,5,5,5,5]', '7', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'good-node-count'),
    'en',
    'Good Node Count',
    'Given the `root` of a binary tree, count the number of **good** nodes.

A node is considered **good** if there is no ancestor in the path from the root to that node whose value is strictly greater than the node''s own value. The root node is always good since it has no ancestors.

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
```',
    'The number of nodes in the tree is in the range [1, 10^5].
Each node''s value is between -10^4 and 10^4.'
);

------------------------------------------------------------
-- Add Height Check problem
-- CodeBite original name: Height Check (inspired by Balanced Binary Tree, LC #110)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Height Check',
    'height-check',
    'Given the `root` of a binary tree, determine whether the tree is **height-balanced**.

A binary tree is height-balanced if, for every node in the tree, the heights of its left and right subtrees differ by no more than `1`.

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
```',
    'EASY',
    '0 <= number of nodes <= 5000
-10^4 <= Node.val <= 10^4',
    123,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[3,9,20,null,null,15,7]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,2,3,3,null,null,4,4]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,3,4,5,6,null,8]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,null,3,null,4,null]', 'false', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'height-check'),
    'en',
    'Height Check',
    'Given the `root` of a binary tree, determine whether the tree is **height-balanced**.

A binary tree is height-balanced if, for every node in the tree, the heights of its left and right subtrees differ by no more than `1`.

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
```',
    '0 <= number of nodes <= 5000
-10^4 <= Node.val <= 10^4'
);

------------------------------------------------------------
-- Add Zigzag Levels problem
-- CodeBite original name: Zigzag Levels (inspired by Binary Tree Zigzag Level Order Traversal, LC #103)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Zigzag Levels',
    'zigzag-levels',
    'Given the `root` of a binary tree, return its values grouped by level, but with alternating traversal direction. The first level (root) should be read left-to-right, the second level right-to-left, the third level left-to-right again, and so on.

Return the result as a list of lists, where each inner list contains the node values for that level in the appropriate order.

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
```',
    'MEDIUM',
    '0 <= number of nodes <= 2000
-100 <= Node.val <= 100',
    124,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[3,9,20,null,null,15,7]', '[[3],[20,9],[15,7]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1]', '[[1]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,2,3,4,5,6,7]', '[[1],[3,2],[4,5,6,7]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,2,3,4,null,null,5]', '[[1],[3,2],[4,5]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[5,1,8,null,3,7,null]', '[[5],[8,1],[3,7]]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'zigzag-levels'),
    'en',
    'Zigzag Levels',
    'Given the `root` of a binary tree, return its values grouped by level, but with alternating traversal direction. The first level (root) should be read left-to-right, the second level right-to-left, the third level left-to-right again, and so on.

Return the result as a list of lists, where each inner list contains the node values for that level in the appropriate order.

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
```',
    '0 <= number of nodes <= 2000
-100 <= Node.val <= 100'
);

------------------------------------------------------------
-- Add Target Path problem
-- CodeBite original name: Target Path (inspired by Path Sum II, LC #113)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Target Path',
    'target-path',
    'Given the `root` of a binary tree and an integer `target`, return all **root-to-leaf** paths where the sum of the node values along the path equals `target`.

A **leaf** is a node that has no children. Each path should be represented as a list of node values from root to leaf.

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
```',
    'MEDIUM',
    '0 <= number of nodes <= 5000
-1000 <= Node.val <= 1000
-1000 <= target <= 1000',
    125,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[5,4,8,11,null,13,4,7,2,null,null,5,1]\n22', '[[5,4,11,2],[5,8,4,5]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1,2,3]\n5', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1,2]\n3', '[[1,2]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[]\n0', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1]\n1', '[[1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[-2,null,-3]\n-5', '[[-2,-3]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1,2,2,3,3,3,3]\n6', '[[1,2,3],[1,2,3],[1,2,3],[1,2,3]]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'target-path'),
    'en',
    'Target Path',
    'Given the `root` of a binary tree and an integer `target`, return all **root-to-leaf** paths where the sum of the node values along the path equals `target`.

A **leaf** is a node that has no children. Each path should be represented as a list of node values from root to leaf.

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
```',
    '0 <= number of nodes <= 5000
-1000 <= Node.val <= 1000
-1000 <= target <= 1000'
);

------------------------------------------------------------
-- Add Right Pointers problem
-- CodeBite original name: Right Pointers (inspired by Populating Next Right Pointers in Each Node, LC #116)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Right Pointers',
    'right-pointers',
    'You are given a **perfect binary tree** where every parent has exactly two children and all leaves are on the same level. Each node has the following structure:

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Set each node''s `next` pointer to point to the node immediately to its right on the same level. If there is no node to the right, `next` should be set to `null`. Initially, all `next` pointers are `null`.

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
```',
    'MEDIUM',
    'The number of nodes is in the range [1, 4096].
-1000 <= Node.val <= 1000
The tree is guaranteed to be a perfect binary tree.',
    126,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3,4,5,6,7]', '[1,#,2,3,#,4,5,6,7,#]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1]', '[1,#]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3]', '[1,#,2,3,#]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]', '[1,#,2,3,#,4,5,6,7,#,8,9,10,11,12,13,14,15,#]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[0,1,2,3,4,5,6]', '[0,#,1,2,#,3,4,5,6,#]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'right-pointers'), '[-1,0,1,-2,-3,2,3]', '[-1,#,0,1,#,-2,-3,2,3,#]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'right-pointers'),
    'en',
    'Right Pointers',
    'You are given a **perfect binary tree** where every parent has exactly two children and all leaves are on the same level. Each node has the following structure:

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

Set each node''s `next` pointer to point to the node immediately to its right on the same level. If there is no node to the right, `next` should be set to `null`. Initially, all `next` pointers are `null`.

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
```',
    'The number of nodes is in the range [1, 4096].
-1000 <= Node.val <= 1000
The tree is guaranteed to be a perfect binary tree.'
);

------------------------------------------------------------
-- Add Root Sum problem
-- CodeBite original name: Root Sum (inspired by Sum Root to Leaf Numbers, LC #129)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Root Sum',
    'root-sum',
    'Given the `root` of a binary tree where each node contains a single digit (0-9), compute the total of all numbers formed by **root-to-leaf** paths.

Each path from the root to a leaf represents a number created by concatenating the digits along the way. For instance, the path 1 -> 2 -> 3 represents the number `123`.

Return the sum of every such number across all root-to-leaf paths.

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
```',
    'MEDIUM',
    '1 <= number of nodes <= 1000
0 <= Node.val <= 9',
    127,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,2,3]', '25', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[4,9,0,5,1]', '1026', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[7]', '7', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,0]', '10', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[9,9,9,9,9,9,9]', '3996', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,2,3,4,5]', '262', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[0,1,null,2]', '12', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'root-sum'),
    'en',
    'Root Sum',
    'Given the `root` of a binary tree where each node contains a single digit (0-9), compute the total of all numbers formed by **root-to-leaf** paths.

Each path from the root to a leaf represents a number created by concatenating the digits along the way. For instance, the path 1 -> 2 -> 3 represents the number `123`.

Return the sum of every such number across all root-to-leaf paths.

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
```',
    '1 <= number of nodes <= 1000
0 <= Node.val <= 9'
);

------------------------------------------------------------
-- Add Flatten Tree problem
-- CodeBite original name: Flatten Tree (inspired by LeetCode #114 Flatten Binary Tree to Linked List)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Flatten Tree',
    'flatten-tree',
    'Given the `root` of a binary tree, rearrange the tree **in-place** so that it forms a singly linked list using the tree''s right pointers. The nodes in the resulting list should appear in the same order as a **pre-order** traversal of the original tree. Every node''s `left` pointer must be set to `null`.

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
    'MEDIUM',
    'The number of nodes in the tree is in the range `[0, 2000]`.
`-100 <= Node.val <= 100`',
    128,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,2,5,3,4,null,6]', '[1,2,3,4,5,6]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[0]', '[0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,2,null,3]', '[1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,null,2,null,3]', '[1,2,3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[5,3,8,1,4,7,9]', '[5,3,1,4,8,7,9]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]', '[1,2,4,8,9,5,10,11,3,6,12,13,7,14,15]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flatten-tree'),
    'en',
    'Flatten Tree',
    'Given the `root` of a binary tree, rearrange the tree **in-place** so that it forms a singly linked list using the tree''s right pointers. The nodes in the resulting list should appear in the same order as a **pre-order** traversal of the original tree. Every node''s `left` pointer must be set to `null`.

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
    'The number of nodes in the tree is in the range `[0, 2000]`.
`-100 <= Node.val <= 100`'
);

