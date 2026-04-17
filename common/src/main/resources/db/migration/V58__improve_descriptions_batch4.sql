-- Improve descriptions: batch 4

------------------------------------------------------------
-- level-traversal
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, return its **level order traversal** as a 2D array. Each inner array should contain the node values at that depth, ordered from left to right.

Level order traversal visits every node on a level before moving to the next level, starting from the root.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
Explanation: Level 0 has node 3, level 1 has nodes 9 and 20, and level 2 has nodes 15 and 7.
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
WHERE slug = 'level-traversal';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, return its **level order traversal** as a 2D array. Each inner array should contain the node values at that depth, ordered from left to right.

Level order traversal visits every node on a level before moving to the next level, starting from the root.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
Explanation: Level 0 has node 3, level 1 has nodes 9 and 20, and level 2 has nodes 15 and 7.
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
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'level-traversal')
  AND locale = 'en';

------------------------------------------------------------
-- bst-validator
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `root` of a binary tree, determine whether it is a valid **binary search tree** (BST).

A valid BST satisfies all of the following rules:
- Every node in the left subtree has a value strictly less than the current node''s value.
- Every node in the right subtree has a value strictly greater than the current node''s value.
- Both the left and right subtrees must themselves be valid BSTs.

Note that this definition applies recursively to the entire tree, not just to immediate children.

**Example 1:**
```
Input: root = [2,1,3]
Output: true
Explanation: The left child 1 is less than 2, and the right child 3 is greater than 2.
```

**Example 2:**
```
Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node''s value is 5, but its right child''s value is 4, which violates the BST property.
```'
WHERE slug = 'bst-validator';

UPDATE problem_translations
SET description = 'Given the `root` of a binary tree, determine whether it is a valid **binary search tree** (BST).

A valid BST satisfies all of the following rules:
- Every node in the left subtree has a value strictly less than the current node''s value.
- Every node in the right subtree has a value strictly greater than the current node''s value.
- Both the left and right subtrees must themselves be valid BSTs.

Note that this definition applies recursively to the entire tree, not just to immediate children.

**Example 1:**
```
Input: root = [2,1,3]
Output: true
Explanation: The left child 1 is less than 2, and the right child 3 is greater than 2.
```

**Example 2:**
```
Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node''s value is 5, but its right child''s value is 4, which violates the BST property.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-validator')
  AND locale = 'en';

------------------------------------------------------------
-- bst-ancestor
------------------------------------------------------------
UPDATE problems
SET description = 'Given a **binary search tree** (BST) and two nodes `p` and `q`, find their **lowest common ancestor** (LCA).

The lowest common ancestor of two nodes is the deepest node in the tree that has both `p` and `q` as descendants. A node is allowed to be a descendant of itself.

Since the tree is a BST, you can use the ordering property to determine which subtree to search: if both `p` and `q` are smaller than the current node, the LCA is in the left subtree; if both are larger, the LCA is in the right subtree; otherwise, the current node is the LCA.

**Example 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: The LCA of nodes 2 and 8 is 6.
```

**Example 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: The LCA of nodes 2 and 4 is 2, since a node can be a descendant of itself.
```

**Example 3:**
```
Input: root = [2,1], p = 2, q = 1
Output: 2
```'
WHERE slug = 'bst-ancestor';

UPDATE problem_translations
SET description = 'Given a **binary search tree** (BST) and two nodes `p` and `q`, find their **lowest common ancestor** (LCA).

The lowest common ancestor of two nodes is the deepest node in the tree that has both `p` and `q` as descendants. A node is allowed to be a descendant of itself.

Since the tree is a BST, you can use the ordering property to determine which subtree to search: if both `p` and `q` are smaller than the current node, the LCA is in the left subtree; if both are larger, the LCA is in the right subtree; otherwise, the current node is the LCA.

**Example 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: The LCA of nodes 2 and 8 is 6.
```

**Example 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: The LCA of nodes 2 and 4 is 2, since a node can be a descendant of itself.
```

**Example 3:**
```
Input: root = [2,1], p = 2, q = 1
Output: 2
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-ancestor')
  AND locale = 'en';

------------------------------------------------------------
-- all-subsets
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` of unique elements, return all possible **subsets** (the power set).

The result must not contain duplicate subsets. You may return the subsets in any order.

A subset is any selection of elements from the array, including the empty selection and the full array itself.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
Explanation: There are 2^3 = 8 subsets in total, including the empty set and the full array.
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```'
WHERE slug = 'all-subsets';

UPDATE problem_translations
SET description = 'Given an integer array `nums` of unique elements, return all possible **subsets** (the power set).

The result must not contain duplicate subsets. You may return the subsets in any order.

A subset is any selection of elements from the array, including the empty selection and the full array itself.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
Explanation: There are 2^3 = 8 subsets in total, including the empty set and the full array.
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-subsets')
  AND locale = 'en';

------------------------------------------------------------
-- target-combinations
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of distinct integers `candidates` and a target integer `target`, return all unique combinations of `candidates` that sum to `target`. You may return the combinations in any order.

Each number in `candidates` may be used an **unlimited number of times**. Two combinations are considered unique if they differ in the frequency of at least one chosen number.

**Example 1:**
```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
Explanation: 2 + 2 + 3 = 7 and 7 = 7 are the only two combinations that sum to the target.
```

**Example 2:**
```
Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]
```

**Example 3:**
```
Input: candidates = [2], target = 1
Output: []
Explanation: No combination of 2s can sum to 1.
```'
WHERE slug = 'target-combinations';

UPDATE problem_translations
SET description = 'Given an array of distinct integers `candidates` and a target integer `target`, return all unique combinations of `candidates` that sum to `target`. You may return the combinations in any order.

Each number in `candidates` may be used an **unlimited number of times**. Two combinations are considered unique if they differ in the frequency of at least one chosen number.

**Example 1:**
```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
Explanation: 2 + 2 + 3 = 7 and 7 = 7 are the only two combinations that sum to the target.
```

**Example 2:**
```
Input: candidates = [2,3,5], target = 8
Output: [[2,2,2,2],[2,3,3],[3,5]]
```

**Example 3:**
```
Input: candidates = [2], target = 1
Output: []
Explanation: No combination of 2s can sum to 1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-combinations')
  AND locale = 'en';

------------------------------------------------------------
-- all-arrangements
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `nums` of distinct integers, return all possible **permutations**. You may return the answer in any order.

A permutation is a rearrangement of all elements in the array into a specific sequence. For an array of length `n`, there are exactly `n!` (n factorial) permutations.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
Explanation: There are 3! = 6 permutations of three distinct elements.
```

**Example 2:**
```
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**Example 3:**
```
Input: nums = [1]
Output: [[1]]
```'
WHERE slug = 'all-arrangements';

UPDATE problem_translations
SET description = 'Given an array `nums` of distinct integers, return all possible **permutations**. You may return the answer in any order.

A permutation is a rearrangement of all elements in the array into a specific sequence. For an array of length `n`, there are exactly `n!` (n factorial) permutations.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
Explanation: There are 3! = 6 permutations of three distinct elements.
```

**Example 2:**
```
Input: nums = [0,1]
Output: [[0,1],[1,0]]
```

**Example 3:**
```
Input: nums = [1]
Output: [[1]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-arrangements')
  AND locale = 'en';

------------------------------------------------------------
-- island-counter
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` 2D grid where `"1"` represents land and `"0"` represents water, return the number of **islands**.

An island is a group of `"1"`s connected **horizontally or vertically** (not diagonally). You may assume that all four edges of the grid are surrounded by water.

**Example 1:**
```
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
Explanation: All the land cells are connected, forming a single island.
```

**Example 2:**
```
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
Explanation: There are three separate groups of connected land cells.
```'
WHERE slug = 'island-counter';

UPDATE problem_translations
SET description = 'Given an `m x n` 2D grid where `"1"` represents land and `"0"` represents water, return the number of **islands**.

An island is a group of `"1"`s connected **horizontally or vertically** (not diagonally). You may assume that all four edges of the grid are surrounded by water.

**Example 1:**
```
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
Explanation: All the land cells are connected, forming a single island.
```

**Example 2:**
```
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
Explanation: There are three separate groups of connected land cells.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'island-counter')
  AND locale = 'en';

------------------------------------------------------------
-- graph-copy
------------------------------------------------------------
UPDATE problems
SET description = 'Given a reference to a node in a connected undirected graph, return a **deep copy** (clone) of the entire graph.

Each node has an integer value and a list of its neighbors. The graph is represented as an adjacency list, where each index corresponds to a node and its list contains the neighbors of that node. The given node will always be the first node with `val = 1`.

Your cloned graph must be a completely new set of nodes with the same structure and values as the original. No node in the clone should reference any node in the original graph.

**Example 1:**
```
Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
Output: [[2,4],[1,3],[2,4],[1,3]]
Explanation: Node 1 connects to nodes 2 and 4. Node 2 connects to nodes 1 and 3. The clone has the same structure.
```

**Example 2:**
```
Input: adjList = [[]]
Output: [[]]
Explanation: The graph consists of a single node with no neighbors.
```

**Example 3:**
```
Input: adjList = []
Output: []
Explanation: The graph is empty (no nodes).
```'
WHERE slug = 'graph-copy';

UPDATE problem_translations
SET description = 'Given a reference to a node in a connected undirected graph, return a **deep copy** (clone) of the entire graph.

Each node has an integer value and a list of its neighbors. The graph is represented as an adjacency list, where each index corresponds to a node and its list contains the neighbors of that node. The given node will always be the first node with `val = 1`.

Your cloned graph must be a completely new set of nodes with the same structure and values as the original. No node in the clone should reference any node in the original graph.

**Example 1:**
```
Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
Output: [[2,4],[1,3],[2,4],[1,3]]
Explanation: Node 1 connects to nodes 2 and 4. Node 2 connects to nodes 1 and 3. The clone has the same structure.
```

**Example 2:**
```
Input: adjList = [[]]
Output: [[]]
Explanation: The graph consists of a single node with no neighbors.
```

**Example 3:**
```
Input: adjList = []
Output: []
Explanation: The graph is empty (no nodes).
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'graph-copy')
  AND locale = 'en';

------------------------------------------------------------
-- course-planner
------------------------------------------------------------
UPDATE problems
SET description = 'There are `numCourses` courses labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [a, b]` means you must complete course `b` before taking course `a`.

Return `true` if it is possible to finish all courses. Otherwise, return `false`.

This is essentially a cycle detection problem: if the prerequisite graph contains a cycle, it is impossible to complete all courses.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: You take course 0 first, then course 1. There is no conflict.
```

**Example 2:**
```
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: Course 1 requires course 0, and course 0 requires course 1. This circular dependency makes it impossible to finish both.
```'
WHERE slug = 'course-planner';

UPDATE problem_translations
SET description = 'There are `numCourses` courses labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [a, b]` means you must complete course `b` before taking course `a`.

Return `true` if it is possible to finish all courses. Otherwise, return `false`.

This is essentially a cycle detection problem: if the prerequisite graph contains a cycle, it is impossible to complete all courses.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: You take course 0 first, then course 1. There is no conflict.
```

**Example 2:**
```
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: Course 1 requires course 0, and course 0 requires course 1. This circular dependency makes it impossible to finish both.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-planner')
  AND locale = 'en';

------------------------------------------------------------
-- staircase
------------------------------------------------------------
UPDATE problems
SET description = 'You are climbing a staircase that has `n` steps. Each time you can climb either `1` or `2` steps.

Return the number of distinct ways you can reach the top.

**Example 1:**
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps
```

**Example 2:**
```
Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```'
WHERE slug = 'staircase';

UPDATE problem_translations
SET description = 'You are climbing a staircase that has `n` steps. Each time you can climb either `1` or `2` steps.

Return the number of distinct ways you can reach the top.

**Example 1:**
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps
```

**Example 2:**
```
Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'staircase')
  AND locale = 'en';
