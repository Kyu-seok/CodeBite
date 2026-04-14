-- Phase 2 Batch 4: 5 new problems — Backtracking (2) + Graphs (3)
-- queen-placement already exists and will be renumbered in the wiring migration.

------------------------------------------------------------
-- BACKTRACKING
------------------------------------------------------------

-- Word Search
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Word Search',
    'word-search',
    'Given an `m x n` grid of characters `board` and a string `word`, return `true` if `word` exists in the grid.

The word can be constructed from letters of sequentially adjacent cells, where adjacent cells are horizontally or vertically neighboring. The same letter cell may not be used more than once.

**Example 1:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true
```

**Example 2:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true
```

**Example 3:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
```',
    'MEDIUM',
    'm == board.length
n == board[i].length
1 <= m, n <= 6
1 <= word.length <= 15
board and word consists of only lowercase and uppercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-search'), '[["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]]
ABCCED', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'word-search'), '[["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]]
SEE', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'word-search'), '[["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]]
ABCB', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'word-search'), '[["a"]]
a', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-search'), '[["a","b"],["c","d"]]
cdba', 'true', FALSE, 5);

-- Phone Combos (Letter Combinations of a Phone Number)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Phone Combos',
    'phone-combos',
    'Given a string containing digits from `2-9` inclusive, return all possible letter combinations that the number could represent. Return the answer in **any order**.

A mapping of digits to letters (just like on the telephone buttons):
- 2: abc, 3: def, 4: ghi, 5: jkl, 6: mno, 7: pqrs, 8: tuv, 9: wxyz

**Example 1:**
```
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]
```

**Example 2:**
```
Input: digits = ""
Output: []
```

**Example 3:**
```
Input: digits = "2"
Output: ["a","b","c"]
```',
    'MEDIUM',
    '0 <= digits.length <= 4
digits[i] is a digit in the range [''2'', ''9''].',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '23', '["ad","ae","af","bd","be","bf","cd","ce","cf"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '2', '["a","b","c"]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '79', '["pw","px","py","pz","qw","qx","qy","qz","rw","rx","ry","rz","sw","sx","sy","sz"]', FALSE, 4);

------------------------------------------------------------
-- GRAPHS
------------------------------------------------------------

-- Pacific Atlantic (Pacific Atlantic Water Flow)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Pacific Atlantic',
    'pacific-atlantic',
    'There is an `m x n` rectangular island that borders both the Pacific Ocean and Atlantic Ocean. The Pacific Ocean touches the island''s left and top edges, and the Atlantic Ocean touches the island''s right and bottom edges.

The island is partitioned into a grid of square cells. You are given an `m x n` integer matrix `heights` where `heights[r][c]` represents the height above sea level of the cell at coordinate `(r, c)`.

The island receives rain. Rain water can flow to neighboring cells directly north, south, east, and west if the neighboring cell''s height is **less than or equal to** the current cell''s height. Water can flow from any cell adjacent to an ocean into the ocean.

Return a **2D list** of grid coordinates where rain water can flow to **both** the Pacific and Atlantic oceans.

**Example 1:**
```
Input: heights = [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]
```

**Example 2:**
```
Input: heights = [[1]]
Output: [[0,0]]
```',
    'MEDIUM',
    'm == heights.length
n == heights[r].length
1 <= m, n <= 200
0 <= heights[r][c] <= 10^5',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]', '[[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1]]', '[[0,0]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1,1],[1,1]]', '[[0,0],[0,1],[1,0],[1,1]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[10,10,10],[10,1,10],[10,10,10]]', '[[0,0],[0,1],[0,2],[1,0],[1,2],[2,0],[2,1],[2,2]]', FALSE, 4);

-- Course Order (Course Schedule II)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Course Order',
    'course-order',
    'There are a total of `numCourses` courses you have to take, labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [a, b]` indicates that you must take course `b` first if you want to take course `a`.

Return the ordering of courses you should take to finish all courses. If there are many valid answers, return **any** of them. If it is impossible to finish all courses, return **an empty array**.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: [0,1]
Explanation: There are 2 courses to take. To take course 1 you should have finished course 0. So the correct order is [0,1].
```

**Example 2:**
```
Input: numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]
Output: [0,1,2,3] or [0,2,1,3]
```

**Example 3:**
```
Input: numCourses = 1, prerequisites = []
Output: [0]
```',
    'MEDIUM',
    '1 <= numCourses <= 2000
0 <= prerequisites.length <= numCourses * (numCourses - 1)
prerequisites[i].length == 2
0 <= a, b < numCourses
a != b
All the pairs [a, b] are distinct.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'course-order'), '2
[[1,0]]', '[0,1]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'course-order'), '4
[[1,0],[2,0],[3,1],[3,2]]', '[0,1,2,3]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'course-order'), '1
[]', '[0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'course-order'), '2
[[1,0],[0,1]]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'course-order'), '3
[[0,1],[0,2],[1,2]]', '[2,1,0]', FALSE, 5);

-- Connected Components (Number of Connected Components)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Connected Components',
    'connected-components',
    'You have a graph of `n` nodes. You are given an integer `n` and an array `edges` where `edges[i] = [a, b]` indicates that there is an edge between `a` and `b` in the graph.

Return the number of connected components in the graph.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[1,2],[3,4]]
Output: 2
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[3,4]]
Output: 1
```',
    'MEDIUM',
    '1 <= n <= 2000
0 <= edges.length <= 5000
edges[i].length == 2
0 <= a, b < n
a != b
There are no repeated edges.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'connected-components'), '5
[[0,1],[1,2],[3,4]]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), '5
[[0,1],[1,2],[2,3],[3,4]]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), '4
[]', '4', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), '1
[]', '1', FALSE, 4);

-- Rotting Oranges
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Rotting Oranges',
    'rotting-oranges',
    'You are given an `m x n` grid where each cell can have one of three values:
- `0` representing an empty cell,
- `1` representing a fresh orange, or
- `2` representing a rotten orange.

Every minute, any fresh orange that is 4-directionally adjacent to a rotten orange becomes rotten.

Return the minimum number of minutes that must elapse until no cell has a fresh orange. If this is impossible, return `-1`.

**Example 1:**
```
Input: grid = [[2,1,1],[1,1,0],[0,1,1]]
Output: 4
```

**Example 2:**
```
Input: grid = [[2,1,1],[0,1,1],[1,0,1]]
Output: -1
Explanation: The orange in the bottom left corner is never reached.
```

**Example 3:**
```
Input: grid = [[0,2]]
Output: 0
Explanation: Since there are no fresh oranges, the answer is 0.
```',
    'MEDIUM',
    'm == grid.length
n == grid[i].length
1 <= m, n <= 10
grid[i][j] is 0, 1, or 2.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1,1],[1,1,0],[0,1,1]]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1,1],[0,1,1],[1,0,1]]', '-1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[0,2]]', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[0]]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,2],[1,1]]', '1', FALSE, 5);

------------------------------------------------------------
-- ENGLISH TRANSLATIONS
------------------------------------------------------------

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'word-search', 'phone-combos',
    'pacific-atlantic', 'course-order', 'connected-components', 'rotting-oranges'
);
