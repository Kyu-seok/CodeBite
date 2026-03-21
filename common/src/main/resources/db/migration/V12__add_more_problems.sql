-- Problem: Binary Tree Level Order Traversal — 2D integer array output (tree input)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Binary Tree Level Order Traversal',
    'binary-tree-level-order-traversal',
    'Given the `root` of a binary tree, return the level order traversal of its nodes'' values. (i.e., from left to right, level by level).

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: [[3],[9,20],[15,7]]
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
    'The number of nodes in the tree is in the range [0, 2000].
-1000 <= Node.val <= 1000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'binary-tree-level-order-traversal'), '[3,9,20,null,null,15,7]', '[[3],[9,20],[15,7]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'binary-tree-level-order-traversal'), '[1]', '[[1]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'binary-tree-level-order-traversal'), '[]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'binary-tree-level-order-traversal'), '[1,2,3,4,5]', '[[1],[2,3],[4,5]]', FALSE, 4);

-- Problem: Group Anagrams — 2D string array output (order-independent, sorted canonical form)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Group Anagrams',
    'group-anagrams',
    'Given an array of strings `strs`, group the anagrams together. You can return the answer in any order.

An anagram is a word or phrase formed by rearranging the letters of a different word or phrase, typically using all the original letters exactly once.

**Example 1:**
```
Input: strs = ["eat","tea","tan","ate","nat","bat"]
Output: [["ate","eat","tea"],["bat"],["nat","tan"]]
```

**Example 2:**
```
Input: strs = [""]
Output: [[""]]
```

**Example 3:**
```
Input: strs = ["a"]
Output: [["a"]]
```',
    'MEDIUM',
    '1 <= strs.length <= 10^4
0 <= strs[i].length <= 100
strs[i] consists of lowercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'group-anagrams'), '["eat","tea","tan","ate","nat","bat"]', '[["ate","eat","tea"],["bat"],["nat","tan"]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'group-anagrams'), '[""]', '[[""]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'group-anagrams'), '["a"]', '[["a"]]', FALSE, 3);

-- Problem: Merge Intervals — 2D integer array output
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Merge Intervals',
    'merge-intervals',
    'Given an array of `intervals` where `intervals[i] = [start_i, end_i]`, merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.

**Example 1:**
```
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
Explanation: Since intervals [1,3] and [2,6] overlap, merge them into [1,6].
```

**Example 2:**
```
Input: intervals = [[1,4],[4,5]]
Output: [[1,5]]
Explanation: Intervals [1,4] and [4,5] are considered overlapping.
```',
    'MEDIUM',
    '1 <= intervals.length <= 10^4
intervals[i].length == 2
0 <= start_i <= end_i <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'merge-intervals'), '[[1,3],[2,6],[8,10],[15,18]]', '[[1,6],[8,10],[15,18]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'merge-intervals'), '[[1,4],[4,5]]', '[[1,5]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'merge-intervals'), '[[1,4],[0,4]]', '[[0,4]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'merge-intervals'), '[[1,4],[2,3]]', '[[1,4]]', FALSE, 4);

-- Problem: 3Sum — 2D integer array output (order-independent, sorted canonical form)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    '3Sum',
    '3sum',
    'Given an integer array `nums`, return all the triplets `[nums[i], nums[j], nums[k]]` such that `i != j`, `i != k`, and `j != k`, and `nums[i] + nums[j] + nums[k] == 0`.

Notice that the solution set must not contain duplicate triplets.

**Example 1:**
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
Explanation:
nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0.
nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0.
The distinct triplets are [-1,0,1] and [-1,-1,2].
```

**Example 2:**
```
Input: nums = [0,1,1]
Output: []
Explanation: The only possible triplet does not sum up to 0.
```

**Example 3:**
```
Input: nums = [0,0,0]
Output: [[0,0,0]]
```',
    'MEDIUM',
    '3 <= nums.length <= 3000
-10^5 <= nums[i] <= 10^5',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = '3sum'), '[-1,0,1,2,-1,-4]', '[[-1,-1,2],[-1,0,1]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = '3sum'), '[0,1,1]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = '3sum'), '[0,0,0]', '[[0,0,0]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = '3sum'), '[-2,0,1,1,2]', '[[-2,0,2],[-2,1,1]]', FALSE, 4);

-- Problem: Permutations — 2D integer array output (order-independent, sorted canonical form)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Permutations',
    'permutations',
    'Given an array `nums` of distinct integers, return all the possible permutations. You can return the answer in any order.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]
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
```',
    'MEDIUM',
    '1 <= nums.length <= 6
-10 <= nums[i] <= 10
All the integers of nums are unique.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'permutations'), '[1,2,3]', '[[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'permutations'), '[0,1]', '[[0,1],[1,0]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'permutations'), '[1]', '[[1]]', FALSE, 3);

-- Problem: Subsets — 2D integer array output (order-independent, sorted canonical form)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Subsets',
    'subsets',
    'Given an integer array `nums` of unique elements, return all possible subsets (the power set).

The solution set must not contain duplicate subsets. Return the solution in any order.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]
```

**Example 2:**
```
Input: nums = [0]
Output: [[],[0]]
```',
    'MEDIUM',
    '1 <= nums.length <= 10
-10 <= nums[i] <= 10
All the numbers of nums are unique.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'subsets'), '[1,2,3]', '[[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'subsets'), '[0]', '[[],[0]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'subsets'), '[1,2]', '[[],[1],[1,2],[2]]', FALSE, 3);

-- Problem: Combination Sum — 2D integer array output (order-independent, sorted canonical form)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Combination Sum',
    'combination-sum',
    'Given an array of distinct integers `candidates` and a target integer `target`, return a list of all unique combinations of `candidates` where the chosen numbers sum to `target`. You may return the combinations in any order.

The same number may be chosen from `candidates` an unlimited number of times. Two combinations are unique if the frequency of at least one of the chosen numbers is different.

**Example 1:**
```
Input: candidates = [2,3,6,7], target = 7
Output: [[2,2,3],[7]]
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
```',
    'MEDIUM',
    '1 <= candidates.length <= 30
2 <= candidates[i] <= 40
All elements of candidates are distinct.
1 <= target <= 40',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'combination-sum'), '[2,3,6,7]
7', '[[2,2,3],[7]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'combination-sum'), '[2,3,5]
8', '[[2,2,2,2],[2,3,3],[3,5]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'combination-sum'), '[2]
1', '[]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'combination-sum'), '[1]
2', '[[1,1]]', FALSE, 4);

-- Problem: Clone Graph — adjacency list output
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Clone Graph',
    'clone-graph',
    'Given a reference of a node in a connected undirected graph, return a deep copy (clone) of the graph.

Each node in the graph contains a value (`int`) and a list (`List[Node]`) of its neighbors.

The graph is represented in the test cases using an adjacency list. An adjacency list is a collection of unordered lists used to represent a finite graph. Each list describes the set of neighbors of a node in the graph.

The given node will always be the first node with `val = 1`.

**Example 1:**
```
Input: adjList = [[2,4],[1,3],[2,4],[1,3]]
Output: [[2,4],[1,3],[2,4],[1,3]]
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
Explanation: The graph is empty.
```',
    'MEDIUM',
    'The number of nodes in the graph is in the range [0, 100].
1 <= Node.val <= 100
Node.val is unique for each node.
There are no repeated edges and no self-loops in the graph.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'clone-graph'), '[[2,4],[1,3],[2,4],[1,3]]', '[[2,4],[1,3],[2,4],[1,3]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'clone-graph'), '[[]]', '[[]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'clone-graph'), '[]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'clone-graph'), '[[2],[1]]', '[[2],[1]]', FALSE, 4);

-- Problem: N-Queens — list of string lists output (order-independent, sorted canonical form)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'N-Queens',
    'n-queens',
    'The n-queens puzzle is the problem of placing `n` queens on an `n x n` chessboard such that no two queens attack each other.

Given an integer `n`, return all distinct solutions to the n-queens puzzle. You may return the answer in any order.

Each solution contains a distinct board configuration of the n-queens'' placement, where `''Q''` and `''.''` both indicate a queen and an empty space, respectively.

**Example 1:**
```
Input: n = 4
Output: [["..Q.","Q...","...Q",".Q.."],[".Q..","...Q","Q...","..Q."]]
```

**Example 2:**
```
Input: n = 1
Output: [["Q"]]
```',
    'HARD',
    '1 <= n <= 9',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'n-queens'), '4', '[["..Q.","Q...","...Q",".Q.."],[".Q..","...Q","Q...","..Q."]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'n-queens'), '1', '[["Q"]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'n-queens'), '2', '[]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'n-queens'), '3', '[]', FALSE, 4);

-- Problem: Accounts Merge — 2D string array output (sorted)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Accounts Merge',
    'accounts-merge',
    'Given a list of `accounts` where each element `accounts[i]` is a list of strings, where the first element `accounts[i][0]` is a name, and the rest of the elements are emails representing emails of the account.

Now, we would like to merge these accounts. Two accounts definitely belong to the same person if there is some common email to both accounts. Note that even if two accounts have the same name, they may belong to different people as people could have the same name. A person can have any number of accounts initially, but all of their accounts definitely have the same name.

After merging the accounts, return the accounts in the following format: the first element of each account is the name, and the rest of the elements are emails in sorted order. The accounts themselves can be returned in any order.

**Example 1:**
```
Input: accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
Output: [["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["John","johnnybravo@mail.com"],["Mary","mary@mail.com"]]
```

**Example 2:**
```
Input: accounts = [["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]
Output: [["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"]]
```',
    'MEDIUM',
    '1 <= accounts.length <= 1000
2 <= accounts[i].length <= 10
1 <= accounts[i][j].length <= 30
accounts[i][0] consists of English letters.
accounts[i][j] (for j > 0) is a valid email.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'accounts-merge'), '[["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]', '[["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["John","johnnybravo@mail.com"],["Mary","mary@mail.com"]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'accounts-merge'), '[["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]', '[["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'accounts-merge'), '[["Alex","Alex5@m.co","Alex4@m.co","Alex0@m.co"],["Ethan","Ethan3@m.co","Ethan3@m.co","Ethan0@m.co"]]', '[["Alex","Alex0@m.co","Alex4@m.co","Alex5@m.co"],["Ethan","Ethan0@m.co","Ethan3@m.co"]]', FALSE, 3);
