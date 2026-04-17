-- Improve descriptions: batch 15

------------------------------------------------------------
-- border-capture
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` board containing the characters `''X''` and `''O''`, modify the board **in-place** so that every `''O''` that is **not** connected to the border is flipped to `''X''`.

An `''O''` cell is considered **connected to the border** if there is a path of adjacent `''O''` cells (moving up, down, left, or right) that reaches any cell on the first row, last row, first column, or last column. All other `''O''` regions that are fully enclosed by `''X''` cells should be captured and flipped.

Return the modified board.

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
```'
WHERE slug = 'border-capture';

UPDATE problem_translations
SET description = 'Given an `m x n` board containing the characters `''X''` and `''O''`, modify the board **in-place** so that every `''O''` that is **not** connected to the border is flipped to `''X''`.

An `''O''` cell is considered **connected to the border** if there is a path of adjacent `''O''` cells (moving up, down, left, or right) that reaches any cell on the first row, last row, first column, or last column. All other `''O''` regions that are fully enclosed by `''X''` cells should be captured and flipped.

Return the modified board.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'border-capture')
  AND locale = 'en';

------------------------------------------------------------
-- word-chain
------------------------------------------------------------
UPDATE problems
SET description = 'Given two words, `beginWord` and `endWord`, along with a list of valid words `wordList`, find the length of the **shortest transformation chain** from `beginWord` to `endWord`.

Each step in the chain changes exactly **one letter**, and every intermediate word must exist in `wordList`. The `beginWord` does not need to be in `wordList`, but `endWord` must be present.

Return the **total number of words** in the shortest chain, including both `beginWord` and `endWord`. If no valid chain exists, return `0`.

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
```'
WHERE slug = 'word-chain';

UPDATE problem_translations
SET description = 'Given two words, `beginWord` and `endWord`, along with a list of valid words `wordList`, find the length of the **shortest transformation chain** from `beginWord` to `endWord`.

Each step in the chain changes exactly **one letter**, and every intermediate word must exist in `wordList`. The `beginWord` does not need to be in `wordList`, but `endWord` must be present.

Return the **total number of words** in the shortest chain, including both `beginWord` and `endWord`. If no valid chain exists, return `0`.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-chain')
  AND locale = 'en';

------------------------------------------------------------
-- shortest-grid-path
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `n x n` binary grid, find the length of the shortest path from the **top-left** cell `(0, 0)` to the **bottom-right** cell `(n - 1, n - 1)`.

You may move in all **8 directions**: horizontal, vertical, and diagonal. Each cell in the path must have a value of `0` (clear). A cell with value `1` is blocked and cannot be traversed.

The **length** of a path is the total number of cells visited, including both the start and end cells. If no valid path exists, return `-1`.

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
Explanation: One valid shortest path is (0,0) -> (0,1) -> (1,2) -> (2,2), visiting 4 cells.
```

**Example 3:**
```
Input: grid = [[1,0,0],[1,1,0],[1,1,0]]
Output: -1
Explanation: The starting cell (0,0) is blocked, so no path exists.
```'
WHERE slug = 'shortest-grid-path';

UPDATE problem_translations
SET description = 'Given an `n x n` binary grid, find the length of the shortest path from the **top-left** cell `(0, 0)` to the **bottom-right** cell `(n - 1, n - 1)`.

You may move in all **8 directions**: horizontal, vertical, and diagonal. Each cell in the path must have a value of `0` (clear). A cell with value `1` is blocked and cannot be traversed.

The **length** of a path is the total number of cells visited, including both the start and end cells. If no valid path exists, return `-1`.

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
Explanation: One valid shortest path is (0,0) -> (0,1) -> (1,2) -> (2,2), visiting 4 cells.
```

**Example 3:**
```
Input: grid = [[1,0,0],[1,1,0],[1,1,0]]
Output: -1
Explanation: The starting cell (0,0) is blocked, so no path exists.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-grid-path')
  AND locale = 'en';

------------------------------------------------------------
-- room-explorer
------------------------------------------------------------
UPDATE problems
SET description = 'You are given `n` rooms numbered from `0` to `n - 1`. Each room may contain a set of keys that unlock other rooms. All rooms are locked except for room `0`, which is open from the start.

When you enter a room, you collect all the keys inside it. You can then use any collected key to open the corresponding room.

Return `true` if you can eventually visit **every** room, or `false` otherwise.

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
```'
WHERE slug = 'room-explorer';

UPDATE problem_translations
SET description = 'You are given `n` rooms numbered from `0` to `n - 1`. Each room may contain a set of keys that unlock other rooms. All rooms are locked except for room `0`, which is open from the start.

When you enter a room, you collect all the keys inside it. You can then use any collected key to open the corresponding room.

Return `true` if you can eventually visit **every** room, or `false` otherwise.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-explorer')
  AND locale = 'en';

------------------------------------------------------------
-- two-colorable
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an undirected graph represented as an adjacency list, where `graph[i]` contains the indices of all nodes directly connected to node `i`.

Determine whether the graph is **two-colorable** (also known as bipartite): can you assign one of two colors to every node such that no two adjacent nodes share the same color?

Return `true` if such a coloring exists, or `false` otherwise. Note that the graph may contain multiple disconnected components.

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
```'
WHERE slug = 'two-colorable';

UPDATE problem_translations
SET description = 'You are given an undirected graph represented as an adjacency list, where `graph[i]` contains the indices of all nodes directly connected to node `i`.

Determine whether the graph is **two-colorable** (also known as bipartite): can you assign one of two colors to every node such that no two adjacent nodes share the same color?

Return `true` if such a coloring exists, or `false` otherwise. Note that the graph may contain multiple disconnected components.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'two-colorable')
  AND locale = 'en';

------------------------------------------------------------
-- equation-solver
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of variable pairs `equations` and a corresponding array `values`, where `equations[i] = [Ai, Bi]` and `values[i]` represents the result of `Ai / Bi`.

For example, if `equations = [["a","b"],["b","c"]]` and `values = [2.0, 3.0]`, then `a / b = 2.0` and `b / c = 3.0`.

Given a list of `queries` where each query is a pair of variables, compute the result of dividing the first by the second using the known relationships. If a result cannot be determined, return `-1.0` for that query. Variables that do not appear in any equation are always unknown.

Note that if `a / b = k`, then `b / a = 1 / k`.

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
```'
WHERE slug = 'equation-solver';

UPDATE problem_translations
SET description = 'You are given a list of variable pairs `equations` and a corresponding array `values`, where `equations[i] = [Ai, Bi]` and `values[i]` represents the result of `Ai / Bi`.

For example, if `equations = [["a","b"],["b","c"]]` and `values = [2.0, 3.0]`, then `a / b = 2.0` and `b / c = 3.0`.

Given a list of `queries` where each query is a pair of variables, compute the result of dividing the first by the second using the known relationships. If a result cannot be determined, return `-1.0` for that query. Variables that do not appear in any equation are always unknown.

Note that if `a / b = k`, then `b / a = 1 / k`.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equation-solver')
  AND locale = 'en';

------------------------------------------------------------
-- point-connector
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `points` where `points[i] = [xi, yi]` represents a point on a 2D plane, return the **minimum total cost** to connect all points.

The cost of connecting two points `[xi, yi]` and `[xj, yj]` is the **Manhattan distance** between them: `|xi - xj| + |yi - yj|`.

The connections must form a network where every point is reachable from every other point, either directly or through intermediate connections. This is equivalent to finding the **minimum spanning tree** of the complete graph.

**Example 1:**
```
Input: points = [[0,0],[2,2],[3,10],[5,2],[7,0]]
Output: 20
Explanation: One optimal set of connections uses edges with costs 4 + 3 + 9 + 4 = 20.
```

**Example 2:**
```
Input: points = [[3,12],[-2,5],[-4,1]]
Output: 18
Explanation: Connect [-4,1] to [-2,5] (cost 6) and [-2,5] to [3,12] (cost 12) for a total of 18.
```

**Example 3:**
```
Input: points = [[0,0]]
Output: 0
Explanation: With only one point, no connections are needed.
```'
WHERE slug = 'point-connector';

UPDATE problem_translations
SET description = 'Given an array `points` where `points[i] = [xi, yi]` represents a point on a 2D plane, return the **minimum total cost** to connect all points.

The cost of connecting two points `[xi, yi]` and `[xj, yj]` is the **Manhattan distance** between them: `|xi - xj| + |yi - yj|`.

The connections must form a network where every point is reachable from every other point, either directly or through intermediate connections. This is equivalent to finding the **minimum spanning tree** of the complete graph.

**Example 1:**
```
Input: points = [[0,0],[2,2],[3,10],[5,2],[7,0]]
Output: 20
Explanation: One optimal set of connections uses edges with costs 4 + 3 + 9 + 4 = 20.
```

**Example 2:**
```
Input: points = [[3,12],[-2,5],[-4,1]]
Output: 18
Explanation: Connect [-4,1] to [-2,5] (cost 6) and [-2,5] to [3,12] (cost 12) for a total of 18.
```

**Example 3:**
```
Input: points = [[0,0]]
Output: 0
Explanation: With only one point, no connections are needed.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'point-connector')
  AND locale = 'en';

------------------------------------------------------------
-- signal-time
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a directed, weighted graph with `n` nodes labeled from `1` to `n`. Each edge is represented as `[source, destination, weight]`, indicating a one-way connection with the given travel time.

A signal is sent from a starting node `src`. Return the **minimum time** it takes for the signal to reach **every** node in the graph. If any node is unreachable from `src`, return `-1`.

The answer is the longest shortest-path distance from `src` to any other node, since all signals propagate simultaneously.

**Example 1:**
```
Input: edges = [[2,1,1],[2,3,1],[3,4,1]], n = 4, src = 2
Output: 2
Explanation: The signal starts at node 2. It reaches nodes 1 and 3 in 1 unit of time. Node 4 is reached via node 3 in 2 units. The last node to be reached takes 2 units total.
```

**Example 2:**
```
Input: edges = [[1,2,1]], n = 2, src = 2
Output: -1
Explanation: Node 2 can reach no other nodes, but node 1 exists and never receives the signal.
```

**Example 3:**
```
Input: edges = [[1,2,3],[1,3,5],[2,3,1]], n = 3, src = 1
Output: 4
Explanation: The signal reaches node 2 in 3 units and node 3 in 4 units (going through node 2 is faster than the direct path of weight 5).
```'
WHERE slug = 'signal-time';

UPDATE problem_translations
SET description = 'You are given a directed, weighted graph with `n` nodes labeled from `1` to `n`. Each edge is represented as `[source, destination, weight]`, indicating a one-way connection with the given travel time.

A signal is sent from a starting node `src`. Return the **minimum time** it takes for the signal to reach **every** node in the graph. If any node is unreachable from `src`, return `-1`.

The answer is the longest shortest-path distance from `src` to any other node, since all signals propagate simultaneously.

**Example 1:**
```
Input: edges = [[2,1,1],[2,3,1],[3,4,1]], n = 4, src = 2
Output: 2
Explanation: The signal starts at node 2. It reaches nodes 1 and 3 in 1 unit of time. Node 4 is reached via node 3 in 2 units. The last node to be reached takes 2 units total.
```

**Example 2:**
```
Input: edges = [[1,2,1]], n = 2, src = 2
Output: -1
Explanation: Node 2 can reach no other nodes, but node 1 exists and never receives the signal.
```

**Example 3:**
```
Input: edges = [[1,2,3],[1,3,5],[2,3,1]], n = 3, src = 1
Output: 4
Explanation: The signal reaches node 2 in 3 units and node 3 in 4 units (going through node 2 is faster than the direct path of weight 5).
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'signal-time')
  AND locale = 'en';

------------------------------------------------------------
-- budget-flights
------------------------------------------------------------
UPDATE problems
SET description = 'You are planning a trip across `n` cities labeled from `0` to `n - 1`. You are given an array `flights` where `flights[i] = [from, to, price]` represents a one-way flight from city `from` to city `to` costing `price` dollars.

Given a starting city `src`, a destination city `dst`, and a maximum number of layovers `k`, return the **cheapest total price** to travel from `src` to `dst` using **at most** `k` intermediate stops.

If no such route exists, return `-1`.

**Example 1:**
```
Input: n = 4, flights = [[0,1,100],[1,2,100],[2,0,100],[1,3,600],[2,3,200]], src = 0, dst = 3, k = 1
Output: 700
Explanation: The route 0 -> 1 -> 3 costs 100 + 600 = 700. The cheaper path 0 -> 1 -> 2 -> 3 costs 400 but uses 2 stops.
```

**Example 2:**
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 1
Output: 200
Explanation: The route 0 -> 1 -> 2 costs 100 + 100 = 200, which is cheaper than the direct flight costing 500.
```

**Example 3:**
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 0
Output: 500
Explanation: With 0 layovers allowed, only the direct flight 0 -> 2 at cost 500 is valid.
```'
WHERE slug = 'budget-flights';

UPDATE problem_translations
SET description = 'You are planning a trip across `n` cities labeled from `0` to `n - 1`. You are given an array `flights` where `flights[i] = [from, to, price]` represents a one-way flight from city `from` to city `to` costing `price` dollars.

Given a starting city `src`, a destination city `dst`, and a maximum number of layovers `k`, return the **cheapest total price** to travel from `src` to `dst` using **at most** `k` intermediate stops.

If no such route exists, return `-1`.

**Example 1:**
```
Input: n = 4, flights = [[0,1,100],[1,2,100],[2,0,100],[1,3,600],[2,3,200]], src = 0, dst = 3, k = 1
Output: 700
Explanation: The route 0 -> 1 -> 3 costs 100 + 600 = 700. The cheaper path 0 -> 1 -> 2 -> 3 costs 400 but uses 2 stops.
```

**Example 2:**
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 1
Output: 200
Explanation: The route 0 -> 1 -> 2 costs 100 + 100 = 200, which is cheaper than the direct flight costing 500.
```

**Example 3:**
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 0
Output: 500
Explanation: With 0 layovers allowed, only the direct flight 0 -> 2 at cost 500 is valid.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'budget-flights')
  AND locale = 'en';

------------------------------------------------------------
-- rising-tide
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an `n x n` integer grid `elevation` where each cell represents the height of terrain at that position. Water begins rising from time `t = 0`. At time `t`, every cell with elevation `<= t` is submerged and can be traversed.

Starting from the top-left corner `(0, 0)`, you want to reach the bottom-right corner `(n - 1, n - 1)`. At each step, you may move to an adjacent cell (up, down, left, or right) as long as **both** your current cell and the destination cell have elevation `<= t`.

Return the **minimum value of `t`** at which a path exists from the top-left to the bottom-right corner.

**Example 1:**
```
Input: elevation = [[0,2],[1,3]]
Output: 3
Explanation: At t = 3, all cells are submerged and the path (0,0) -> (1,0) -> (1,1) is valid.
```

**Example 2:**
```
Input: elevation = [[0,1,2,3,4],[24,23,22,21,5],[12,13,14,15,16],[11,17,18,19,20],[10,9,8,7,6]]
Output: 16
Explanation: At t = 16, a path exists that snakes around the grid following cells with elevation <= 16.
```

**Example 3:**
```
Input: elevation = [[3,2],[0,1]]
Output: 3
Explanation: At t = 3, the path (0,0) -> (0,1) -> (1,1) or (0,0) -> (1,0) -> (1,1) becomes available.
```'
WHERE slug = 'rising-tide';

UPDATE problem_translations
SET description = 'You are given an `n x n` integer grid `elevation` where each cell represents the height of terrain at that position. Water begins rising from time `t = 0`. At time `t`, every cell with elevation `<= t` is submerged and can be traversed.

Starting from the top-left corner `(0, 0)`, you want to reach the bottom-right corner `(n - 1, n - 1)`. At each step, you may move to an adjacent cell (up, down, left, or right) as long as **both** your current cell and the destination cell have elevation `<= t`.

Return the **minimum value of `t`** at which a path exists from the top-left to the bottom-right corner.

**Example 1:**
```
Input: elevation = [[0,2],[1,3]]
Output: 3
Explanation: At t = 3, all cells are submerged and the path (0,0) -> (1,0) -> (1,1) is valid.
```

**Example 2:**
```
Input: elevation = [[0,1,2,3,4],[24,23,22,21,5],[12,13,14,15,16],[11,17,18,19,20],[10,9,8,7,6]]
Output: 16
Explanation: At t = 16, a path exists that snakes around the grid following cells with elevation <= 16.
```

**Example 3:**
```
Input: elevation = [[3,2],[0,1]]
Output: 3
Explanation: At t = 3, the path (0,0) -> (0,1) -> (1,1) or (0,0) -> (1,0) -> (1,1) becomes available.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rising-tide')
  AND locale = 'en';
