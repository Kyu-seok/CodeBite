-- Phase 3 Batch 5: Graphs (#139-146)
-- 8 problems: valid-tree, gate-distance, border-capture, word-chain, shortest-grid-path, room-explorer, two-colorable, equation-solver

------------------------------------------------------------
-- Add Valid Tree problem
-- CodeBite original name: Valid Tree (inspired by LeetCode #261 Graph Valid Tree)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Valid Tree',
    'valid-tree',
    'You are given `n` nodes labeled from `0` to `n - 1` and a list of undirected `edges`, where each edge connects two nodes. Determine whether these nodes and edges form a valid tree.

A valid tree must satisfy two conditions: it is fully connected (every node is reachable from every other node), and it contains no cycles.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
Explanation: All 5 nodes are connected and there are no cycles.
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: There is a cycle between nodes 1, 2, and 3.
```

**Example 3:**
```
Input: n = 4, edges = [[0,1],[2,3]]
Output: false
Explanation: The graph has two disconnected components, so it is not a valid tree.
```',
    'MEDIUM',
    '1 <= n <= 2000
0 <= edges.length <= 5000
edges[i].length == 2
0 <= edges[i][0], edges[i][1] < n
There are no self-loops or duplicate edges.',
    139,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'5\n[[0,1],[0,2],[0,3],[1,4]]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'5\n[[0,1],[1,2],[2,3],[1,3],[1,4]]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'4\n[[0,1],[2,3]]', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'1\n[]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'2\n[[0,1]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'3\n[[0,1]]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'6\n[[0,1],[1,2],[2,3],[3,4],[4,5]]', 'true', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'valid-tree'),
    'en',
    'Valid Tree',
    'You are given `n` nodes labeled from `0` to `n - 1` and a list of undirected `edges`, where each edge connects two nodes. Determine whether these nodes and edges form a valid tree.

A valid tree must satisfy two conditions: it is fully connected (every node is reachable from every other node), and it contains no cycles.

**Example 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
Explanation: All 5 nodes are connected and there are no cycles.
```

**Example 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: There is a cycle between nodes 1, 2, and 3.
```

**Example 3:**
```
Input: n = 4, edges = [[0,1],[2,3]]
Output: false
Explanation: The graph has two disconnected components, so it is not a valid tree.
```',
    '1 <= n <= 2000
0 <= edges.length <= 5000
edges[i].length == 2
0 <= edges[i][0], edges[i][1] < n
There are no self-loops or duplicate edges.'
);

------------------------------------------------------------
-- Add Gate Distance problem
-- CodeBite original name: Gate Distance (inspired by Walls and Gates, LC #286)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Gate Distance',
    'gate-distance',
    'You are given an `m x n` 2D grid where each cell contains one of three values:

- `-1` representing a barrier (impassable)
- `0` representing a gate (destination)
- `2147483647` representing an open space

Fill each open space with the number of steps needed to reach its **nearest gate**. If it is impossible to reach any gate from a given space, leave it as `2147483647`. Movement is restricted to the four cardinal directions (up, down, left, right).

Modify the grid **in-place** and return it.

**Example 1:**
```
Input: grid = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
Explanation: The two gates are at positions (0,2) and (3,0). Each open space is labeled with its shortest path to the nearest gate.
```

**Example 2:**
```
Input: grid = [[0,-1],[2147483647,2147483647]]
Output: [[0,-1],[1,2]]
```

**Example 3:**
```
Input: grid = [[2147483647]]
Output: [[2147483647]]
Explanation: There are no gates, so the open space remains unreachable.
```',
    'MEDIUM',
    '1 <= m, n <= 250
grid[i][j] is -1, 0, or 2147483647',
    140,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]', '[[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0,-1],[2147483647,2147483647]]', '[[0,-1],[1,2]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[2147483647]]', '[[2147483647]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0,2147483647,2147483647],[2147483647,2147483647,2147483647],[2147483647,2147483647,0]]', '[[0,1,2],[1,2,1],[2,1,0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0,0],[0,0]]', '[[0,0],[0,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[-1,-1],[-1,2147483647]]', '[[-1,-1],[-1,2147483647]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0]]', '[[0]]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'gate-distance';

------------------------------------------------------------
-- Add Border Capture problem
-- CodeBite original name: Border Capture (inspired by Surrounded Regions, LC #130)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Border Capture',
    'border-capture',
    'Given an `m x n` board containing the characters `''X''` and `''O''`, modify the board **in-place** so that every `''O''` that is **not** connected to the border of the board is flipped to `''X''`.

An `''O''` cell is considered connected to the border if there is a path of adjacent `''O''` cells (up, down, left, right) that reaches any cell on the first row, last row, first column, or last column. All other `''O''` regions that are fully enclosed by `''X''` should be captured.

**Example 1:**
```
Input: board = [["X","X","X","X"],["X","O","O","X"],["X","X","O","X"],["X","O","X","X"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","O","X","X"]]
Explanation: The O at position (3,1) is on the last row, so it stays. The interior O''s at (1,1), (1,2), and (2,2) are fully surrounded, so they are captured.
```

**Example 2:**
```
Input: board = [["X"]]
Output: [["X"]]
```

**Example 3:**
```
Input: board = [["O","O"],["O","O"]]
Output: [["O","O"],["O","O"]]
Explanation: All O cells are on the border, so none are captured.
```',
    'MEDIUM',
    'm == board.length
n == board[i].length
1 <= m, n <= 200
board[i][j] is ''X'' or ''O''',
    141,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","X","X","X"],["X","O","O","X"],["X","X","O","X"],["X","O","X","X"]]', '[["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","O","X","X"]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X"]]', '[["X"]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["O","O"],["O","O"]]', '[["O","O"],["O","O"]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","O","X"],["O","X","O"],["X","O","X"]]', '[["X","O","X"],["O","X","O"],["X","O","X"]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","X","X","X","X"],["X","O","O","O","X"],["X","O","X","O","X"],["X","O","O","O","X"],["X","X","X","X","X"]]', '[["X","X","X","X","X"],["X","X","X","X","X"],["X","X","X","X","X"],["X","X","X","X","X"],["X","X","X","X","X"]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["O","X","O"],["X","O","X"],["O","X","O"]]', '[["O","X","O"],["X","X","X"],["O","X","O"]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","X","X"],["X","O","X"],["X","X","X"]]', '[["X","X","X"],["X","X","X"],["X","X","X"]]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'border-capture';

------------------------------------------------------------
-- Add Word Chain problem
-- CodeBite original name: Word Chain (inspired by Word Ladder, LC #127)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Word Chain',
    'word-chain',
    'Given two words, `beginWord` and `endWord`, along with a list of valid words `wordList`, find the length of the shortest transformation chain from `beginWord` to `endWord` such that:

- Each step in the chain changes exactly **one letter**.
- Every intermediate word in the chain must exist in `wordList`.

Return the **total number of words** in the shortest chain (including both `beginWord` and `endWord`). If no valid chain exists, return `0`.

Note that `beginWord` does not need to be in `wordList`, but `endWord` must be.

**Example 1:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
Output: 5
Explanation: hit -> hot -> dot -> dog -> cog (5 words total)
```

**Example 2:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log"]
Output: 0
Explanation: The endWord "cog" is not in wordList, so no chain is possible.
```

**Example 3:**
```
Input: beginWord = "a", endWord = "c", wordList = ["a","b","c"]
Output: 2
Explanation: a -> c (2 words total)
```',
    'HARD',
    '1 <= beginWord.length <= 10
endWord.length == beginWord.length
1 <= wordList.length <= 5000
wordList[i].length == beginWord.length
beginWord, endWord, and wordList[i] consist of lowercase English letters
beginWord != endWord',
    142,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'hit\ncog\n["hot","dot","dog","lot","log","cog"]', '5', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'hit\ncog\n["hot","dot","dog","lot","log"]', '0', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'a\nc\n["a","b","c"]', '2', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'hot\ndog\n["hot","dog","dot"]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'cat\ndog\n["cot","cog","dog","cat"]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'ab\ncd\n["ad","bd","cd"]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'abc\nxyz\n["abd","xyd","xyz"]', '0', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'word-chain';

------------------------------------------------------------
-- Add Shortest Grid Path problem
-- CodeBite original name: Shortest Grid Path (inspired by Shortest Path in Binary Matrix, LC #1091)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Shortest Grid Path',
    'shortest-grid-path',
    'Given an `n x n` binary grid, find the length of the shortest path from the **top-left** cell `(0, 0)` to the **bottom-right** cell `(n - 1, n - 1)`. You may move in all **8 directions** (horizontal, vertical, and diagonal). Each cell in the path must have a value of `0` (clear). A cell with value `1` is blocked and cannot be traversed.

The **length** of a path is the total number of cells visited along that path, including both the start and end cells.

If no such path exists, return `-1`.

**Example 1:**
```
Input: grid = [[0,1],[1,0]]
Output: 2
Explanation: The path (0,0) -> (1,1) moves diagonally and visits 2 cells.
```

**Example 2:**
```
Input: grid = [[0,0,0],[1,1,0],[1,1,0]]
Output: 4
Explanation: One valid shortest path is (0,0) -> (0,1) -> (0,2) -> (1,2) -> (2,2), but (0,0) -> (0,1) -> (1,2) -> (2,2) visits only 4 cells.
```

**Example 3:**
```
Input: grid = [[1,0,0],[1,1,0],[1,1,0]]
Output: -1
Explanation: The starting cell (0,0) is blocked, so no path exists.
```',
    'MEDIUM',
    'n == grid.length
n == grid[i].length
1 <= n <= 100
grid[i][j] is 0 or 1',
    143,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,1],[1,0]]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0,0],[1,1,0],[1,1,0]]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[1,0,0],[1,1,0],[1,1,0]]', '-1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0]]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0,0],[0,1,0],[0,0,0]]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0,1,0],[1,0,1,0],[1,0,0,0],[0,0,0,0]]', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[1]]', '-1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'shortest-grid-path';

------------------------------------------------------------
-- Add Room Explorer problem
-- CodeBite original name: Room Explorer (inspired by Keys and Rooms, LC #841)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Room Explorer',
    'room-explorer',
    'You are given `n` rooms numbered from `0` to `n - 1`. Each room may contain a set of keys that unlock other rooms. All rooms are locked except for room `0`, which is open from the start.

Your task is to determine whether it is possible to visit **every** room by collecting and using keys. When you enter a room, you collect all the keys inside it and can use any of them to open the corresponding room.

Return `true` if you can eventually enter all `n` rooms, or `false` otherwise.

**Example 1:**
```
Input: rooms = [[1],[2],[3],[]]
Output: true
Explanation: Start in room 0 and pick up key 1. Open room 1, pick up key 2. Open room 2, pick up key 3. Open room 3. All 4 rooms visited.
```

**Example 2:**
```
Input: rooms = [[1,3],[3,0,1],[2],[0]]
Output: false
Explanation: Room 0 gives keys to rooms 1 and 3. Neither room 1 nor room 3 provides a key to room 2, so room 2 can never be reached.
```

**Example 3:**
```
Input: rooms = [[]]
Output: true
Explanation: There is only one room, and it is already open.
```',
    'MEDIUM',
    '1 <= n <= 1000
0 <= rooms[i].length <= n
0 <= rooms[i][j] < n
All values in rooms[i] are unique',
    144,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1],[2],[3],[]]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1,3],[3,0,1],[2],[0]]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[]]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1,2,3],[],[],[]]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[],[2],[]]', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1],[2],[0]]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1,2],[3],[3],[]]', 'true', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'room-explorer';

------------------------------------------------------------
-- Add Two Colorable problem
-- CodeBite original name: Two Colorable (inspired by Is Graph Bipartite?, LC #785)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Two Colorable',
    'two-colorable',
    'You are given an undirected graph represented as an adjacency list, where `graph[i]` contains the indices of all nodes directly connected to node `i`.

Determine whether the graph is **two-colorable**: can you assign one of two colors to every node such that no two adjacent nodes share the same color?

Return `true` if such a coloring exists, or `false` otherwise.

**Example 1:**
```
Input: graph = [[1,3],[0,2],[1,3],[0,2]]
Output: true
Explanation: Assign color A to nodes 0 and 2, and color B to nodes 1 and 3. No two neighbors share a color.
```

**Example 2:**
```
Input: graph = [[1,2,3],[0,2],[0,1,3],[0,2]]
Output: false
Explanation: Nodes 0, 1, and 2 are all mutually connected, forming a triangle. It is impossible to color three mutually adjacent nodes with only two colors.
```

**Example 3:**
```
Input: graph = [[],[]]
Output: true
Explanation: Two isolated nodes can each be given any color without conflict.
```',
    'MEDIUM',
    '1 <= graph.length <= 100
0 <= graph[i].length < graph.length
graph[i] does not contain i (no self-loops)
If graph[i] contains j, then graph[j] contains i (undirected)
The graph may not be connected',
    145,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,3],[0,2],[1,3],[0,2]]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,2,3],[0,2],[0,1,3],[0,2]]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[],[]]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[]]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1],[0],[3],[2]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,2],[0,2],[0,1]]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[3],[2],[1,3],[0,2]]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,2,3],[0],[0,3],[0,2]]', 'false', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'two-colorable';

------------------------------------------------------------
-- Add Equation Solver problem
-- CodeBite original name: Equation Solver (inspired by Evaluate Division, LC #399)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Equation Solver',
    'equation-solver',
    'You are given a list of variable pairs along with their division results. For example, if `equations = [["a","b"],["b","c"]]` and `values = [2.0,3.0]`, this means `a / b = 2.0` and `b / c = 3.0`.

Given a list of `queries` where each query is a pair of variables, compute the result of dividing the first variable by the second using the known relationships. If a result cannot be determined from the given information, return `-1.0` for that query.

Note that if `a / b = 2.0`, then `b / a = 0.5`. Variables that do not appear in any equation are always unknown.

**Example 1:**
```
Input: equations = [["a","b"],["b","c"]], values = [2.0,3.0], queries = [["a","c"],["b","a"],["a","e"],["a","a"],["x","x"]]
Output: [6.00000,0.50000,-1.00000,1.00000,-1.00000]
Explanation: a/c = (a/b) * (b/c) = 2.0 * 3.0 = 6.0; b/a = 1/2.0 = 0.5; "e" is unknown so a/e = -1.0; a/a = 1.0; "x" never appeared so x/x = -1.0.
```

**Example 2:**
```
Input: equations = [["a","b"],["b","c"],["bc","cd"]], values = [1.5,2.5,5.0], queries = [["a","c"],["c","b"],["bc","cd"],["cd","bc"]]
Output: [3.75000,0.40000,5.00000,0.20000]
```

**Example 3:**
```
Input: equations = [["a","b"]], values = [0.5], queries = [["a","b"],["b","a"],["a","c"]]
Output: [0.50000,2.00000,-1.00000]
```',
    'MEDIUM',
    '1 <= equations.length <= 20
equations[i].length == 2
1 <= equations[i][0].length, equations[i][1].length <= 5
values.length == equations.length
0.0 < values[i] <= 20.0
1 <= queries.length <= 20
queries[i].length == 2
1 <= queries[i][0].length, queries[i][1].length <= 5
Variables consist of lowercase English letters and digits',
    146,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["b","c"]]\n[2.0,3.0]\n[["a","c"],["b","a"],["a","e"],["a","a"],["x","x"]]', '[6.00000,0.50000,-1.00000,1.00000,-1.00000]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["b","c"],["bc","cd"]]\n[1.5,2.5,5.0]\n[["a","c"],["c","b"],["bc","cd"],["cd","bc"]]', '[3.75000,0.40000,5.00000,0.20000]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"]]\n[0.5]\n[["a","b"],["b","a"],["a","c"]]', '[0.50000,2.00000,-1.00000]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["c","d"]]\n[2.0,3.0]\n[["a","d"],["b","c"]]', '[-1.00000,-1.00000]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["b","c"],["c","d"]]\n[2.0,3.0,4.0]\n[["a","d"],["d","a"]]', '[24.00000,0.04167]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["x","y"],["y","z"],["z","w"]]\n[1.0,1.0,1.0]\n[["x","w"],["w","x"],["x","x"]]', '[1.00000,1.00000,1.00000]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug = 'equation-solver';

