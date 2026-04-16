-- Phase 3 Batch 6: Advanced Graphs (#147-153)
-- 7 problems: point-connector, signal-time, budget-flights, rising-tide, symbol-order, extra-edge, airport-route

------------------------------------------------------------
-- Add Point Connector problem
-- CodeBite original name: Point Connector (inspired by LeetCode #1584 Min Cost to Connect All Points)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Point Connector',
    'point-connector',
    'Given an array `points` where `points[i] = [xi, yi]` represents a point on a 2D plane, return the minimum total cost to connect all the points together. The cost of connecting two points is defined as the Manhattan distance between them: `|xi - xj| + |yi - yj|`.

Each point can be connected to any other point, and the set of connections must form a network where every point is reachable from every other point, either directly or through other connected points. Find the cheapest way to achieve this.

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
```',
    'MEDIUM',
    '1 <= points.length <= 1000
-10^6 <= xi, yi <= 10^6
All points are distinct.',
    147,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[2,2],[3,10],[5,2],[7,0]]', '20', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[3,12],[-2,5],[-4,1]]', '18', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0]]', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[1,1],[1,0],[-1,1]]', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[5,5]]', '10', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[1,1],[2,2]]', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[100,100],[-100,-100],[100,-100],[-100,100]]', '800', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'point-connector'),
    'en',
    'Point Connector',
    'Given an array `points` where `points[i] = [xi, yi]` represents a point on a 2D plane, return the minimum total cost to connect all the points together. The cost of connecting two points is defined as the Manhattan distance between them: `|xi - xj| + |yi - yj|`.

Each point can be connected to any other point, and the set of connections must form a network where every point is reachable from every other point, either directly or through other connected points. Find the cheapest way to achieve this.

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
```',
    '1 <= points.length <= 1000
-10^6 <= xi, yi <= 10^6
All points are distinct.'
);

------------------------------------------------------------
-- Add Signal Time problem
-- CodeBite original name: Signal Time (inspired by LeetCode #743 Network Delay Time)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Signal Time',
    'signal-time',
    'You are given a directed weighted graph with `n` nodes labeled from `1` to `n`, and a list of directed edges where each edge is represented as `[source, destination, weight]`. A signal is sent from a given starting node `src`.

Return the **minimum time** it takes for the signal to reach **every** node in the graph. If it is impossible for all nodes to receive the signal, return `-1`.

**Example 1:**
```
Input: edges = [[2,1,1],[2,3,1],[3,4,1]], n = 4, src = 2
Output: 2
Explanation: The signal starts at node 2. It reaches node 1 and node 3 in 1 unit of time. Node 4 is reached via node 3 in 2 units. The last node to be reached takes 2 units total.
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
```',
    'MEDIUM',
    '1 <= n <= 100
1 <= edges.length <= 6000
edges[i].length == 3
1 <= source_i, dest_i <= n
source_i != dest_i
1 <= weight_i <= 100
All (source_i, dest_i) pairs are unique.',
    148,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[2,1,1],[2,3,1],[3,4,1]]\n4\n2', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1]]\n2\n2', '-1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,3],[1,3,5],[2,3,1]]\n3\n1', '4', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1],[2,3,2],[1,3,4]]\n3\n1', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1]]\n2\n1', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1],[2,1,1]]\n2\n1', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,10],[1,3,1],[3,2,1]]\n3\n1', '2', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'signal-time'),
    'en',
    'Signal Time',
    'You are given a directed weighted graph with `n` nodes labeled from `1` to `n`, and a list of directed edges where each edge is represented as `[source, destination, weight]`. A signal is sent from a given starting node `src`.

Return the **minimum time** it takes for the signal to reach **every** node in the graph. If it is impossible for all nodes to receive the signal, return `-1`.

**Example 1:**
```
Input: edges = [[2,1,1],[2,3,1],[3,4,1]], n = 4, src = 2
Output: 2
Explanation: The signal starts at node 2. It reaches node 1 and node 3 in 1 unit of time. Node 4 is reached via node 3 in 2 units. The last node to be reached takes 2 units total.
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
```',
    '1 <= n <= 100
1 <= edges.length <= 6000
edges[i].length == 3
1 <= source_i, dest_i <= n
source_i != dest_i
1 <= weight_i <= 100
All (source_i, dest_i) pairs are unique.'
);

------------------------------------------------------------
-- Add Budget Flights problem
-- CodeBite original name: Budget Flights (inspired by Cheapest Flights Within K Stops, LC #787)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Budget Flights',
    'budget-flights',
    'You are planning a trip across `n` cities labeled from `0` to `n - 1`. You are given an array `flights` where `flights[i] = [from, to, price]` represents a one-way flight from city `from` to city `to` costing `price` dollars.

Given a starting city `src`, a destination city `dst`, and a maximum number of layovers `k`, return the cheapest total price to travel from `src` to `dst` using at most `k` intermediate stops. If no such route exists, return `-1`.

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
```',
    'MEDIUM',
    '1 <= n <= 100
0 <= flights.length <= n * (n - 1) / 2
flights[i].length == 3
0 <= from, to < n
from != to
1 <= price <= 10000
0 <= src, dst, k < n
src != dst',
    149,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'4\n[[0,1,100],[1,2,100],[2,0,100],[1,3,600],[2,3,200]]\n0\n3\n1', '700', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'3\n[[0,1,100],[1,2,100],[0,2,500]]\n0\n2\n1', '200', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'3\n[[0,1,100],[1,2,100],[0,2,500]]\n0\n2\n0', '500', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'3\n[[0,1,100],[1,2,100]]\n0\n2\n0', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'5\n[[0,1,5],[1,2,5],[0,3,2],[3,1,2],[1,4,1],[4,2,1]]\n0\n2\n2', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'2\n[[0,1,50]]\n0\n1\n0', '50', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'budget-flights'),
    'en',
    'Budget Flights',
    'You are planning a trip across `n` cities labeled from `0` to `n - 1`. You are given an array `flights` where `flights[i] = [from, to, price]` represents a one-way flight from city `from` to city `to` costing `price` dollars.

Given a starting city `src`, a destination city `dst`, and a maximum number of layovers `k`, return the cheapest total price to travel from `src` to `dst` using at most `k` intermediate stops. If no such route exists, return `-1`.

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
```',
    '1 <= n <= 100
0 <= flights.length <= n * (n - 1) / 2
flights[i].length == 3
0 <= from, to < n
from != to
1 <= price <= 10000
0 <= src, dst, k < n
src != dst'
);

------------------------------------------------------------
-- Add Rising Tide problem
-- CodeBite original name: Rising Tide (inspired by Swim in Rising Water, LC #778)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Rising Tide',
    'rising-tide',
    'You are given an `n x n` integer grid `elevation` where each cell represents the height of terrain at that position. Water begins rising from time `t = 0`. At time `t`, every cell with elevation `<= t` is submerged and can be traversed.

Starting from the top-left corner `(0, 0)`, you want to reach the bottom-right corner `(n - 1, n - 1)`. At each step, you may move to an adjacent cell (up, down, left, or right) as long as **both** your current cell and the destination cell are submerged at time `t`.

Return the minimum value of `t` at which a path exists from the top-left to the bottom-right.

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
```',
    'HARD',
    'n == elevation.length == elevation[i].length
1 <= n <= 50
0 <= elevation[i][j] < n * n
All values in elevation are unique',
    150,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,2],[1,3]]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,1,2,3,4],[24,23,22,21,5],[12,13,14,15,16],[11,17,18,19,20],[10,9,8,7,6]]', '16', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[3,2],[0,1]]', '3', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0]]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[0,1,3],[5,8,2],[4,6,7]]', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rising-tide'), '[[6,2,0],[3,8,1],[4,5,7]]', '7', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rising-tide'),
    'en',
    'Rising Tide',
    'You are given an `n x n` integer grid `elevation` where each cell represents the height of terrain at that position. Water begins rising from time `t = 0`. At time `t`, every cell with elevation `<= t` is submerged and can be traversed.

Starting from the top-left corner `(0, 0)`, you want to reach the bottom-right corner `(n - 1, n - 1)`. At each step, you may move to an adjacent cell (up, down, left, or right) as long as **both** your current cell and the destination cell are submerged at time `t`.

Return the minimum value of `t` at which a path exists from the top-left to the bottom-right.

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
```',
    'n == elevation.length == elevation[i].length
1 <= n <= 50
0 <= elevation[i][j] < n * n
All values in elevation are unique'
);

------------------------------------------------------------
-- Add Symbol Order problem
-- CodeBite original name: Symbol Order (inspired by LeetCode #269 Alien Dictionary)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Symbol Order',
    'symbol-order',
    'You are given a list of words sorted in the alphabetical order of an unknown language. The language uses the same lowercase English letters, but possibly in a different order.

Derive the ordering of characters in this language by analyzing the sorted word list. Return a string containing the characters in the correct order. If there is no valid ordering (for example, due to contradictory rules), return an empty string `""`.

**Note:** If a word is a prefix of another word that appears earlier in the list (e.g., `"abc"` comes before `"ab"`), the ordering is invalid.

**Example 1:**
```
Input: words = ["wrt","wrf","er","ett","rftt"]
Output: "wertf"
Explanation: Comparing adjacent pairs gives us: t before f, w before e, r before t, and e before r. Combining these yields the order w -> e -> r -> t -> f.
```

**Example 2:**
```
Input: words = ["z","x"]
Output: "zx"
Explanation: From the pair z, x we learn that z comes before x in this language.
```

**Example 3:**
```
Input: words = ["abc","ab"]
Output: ""
Explanation: "abc" appears before "ab", but "ab" is a prefix of "abc". A shorter prefix must come first in a valid ordering, so this input is contradictory.
```',
    'HARD',
    'The input list contains at least 1 word.
All words consist of lowercase English letters only.
There may be characters that have no ordering constraints relative to each other; in such cases, the test inputs are designed so that only one valid ordering exists.',
    151,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["wrt","wrf","er","ett","rftt"]', 'wertf', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["z","x"]', 'zx', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["abc","ab"]', '', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["a"]', 'a', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["ab","ac","bc"]', 'abc', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["x","y","x"]', '', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["pq","p"]', '', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'symbol-order'),
    'en',
    'Symbol Order',
    'You are given a list of words sorted in the alphabetical order of an unknown language. The language uses the same lowercase English letters, but possibly in a different order.

Derive the ordering of characters in this language by analyzing the sorted word list. Return a string containing the characters in the correct order. If there is no valid ordering (for example, due to contradictory rules), return an empty string `""`.

**Note:** If a word is a prefix of another word that appears earlier in the list (e.g., `"abc"` comes before `"ab"`), the ordering is invalid.

**Example 1:**
```
Input: words = ["wrt","wrf","er","ett","rftt"]
Output: "wertf"
Explanation: Comparing adjacent pairs gives us: t before f, w before e, r before t, and e before r. Combining these yields the order w -> e -> r -> t -> f.
```

**Example 2:**
```
Input: words = ["z","x"]
Output: "zx"
Explanation: From the pair z, x we learn that z comes before x in this language.
```

**Example 3:**
```
Input: words = ["abc","ab"]
Output: ""
Explanation: "abc" appears before "ab", but "ab" is a prefix of "abc". A shorter prefix must come first in a valid ordering, so this input is contradictory.
```',
    'The input list contains at least 1 word.
All words consist of lowercase English letters only.
There may be characters that have no ordering constraints relative to each other; in such cases, the test inputs are designed so that only one valid ordering exists.'
);

------------------------------------------------------------
-- Add Extra Edge problem
-- CodeBite original name: Extra Edge (inspired by Redundant Connection, LC #684)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Extra Edge',
    'extra-edge',
    'You are given a graph that was originally a tree with `n` nodes labeled from `1` to `n`, but one additional edge has been added. The graph is represented as an array `edges` where `edges[i] = [a, b]` indicates an undirected connection between nodes `a` and `b`.

Find and return the edge that was added to the tree, causing a cycle. If there are multiple edges that could be removed to restore the tree, return the one that appears last in the `edges` array.

**Example 1:**
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: The tree originally connected 1-2 and 1-3. The edge [2,3] creates a cycle 1-2-3-1.
```

**Example 2:**
```
Input: edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]
Output: [1,4]
Explanation: Removing [1,4] breaks the cycle 1-2-3-4-1 and restores a valid tree.
```

**Example 3:**
```
Input: edges = [[1,2],[1,3],[1,4],[3,4]]
Output: [3,4]
Explanation: The edge [3,4] forms a cycle with the paths through node 1.
```',
    'MEDIUM',
    'n == edges.length
3 <= n <= 1000
edges[i].length == 2
1 <= edges[i][0], edges[i][1] <= n
edges[i][0] != edges[i][1]
No duplicate edges exist
The graph is connected and contains exactly one cycle',
    152,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[1,3],[2,3]]', '[2,3]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[2,3],[3,4],[1,4],[1,5]]', '[1,4]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[1,3],[1,4],[3,4]]', '[3,4]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[2,3],[3,1]]', '[3,1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[2,3],[3,4],[4,5],[5,6],[6,3]]', '[6,3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[3,4],[1,2],[2,3],[1,4]]', '[1,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[1,3],[2,4],[2,5],[3,5]]', '[3,5]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'extra-edge'),
    'en',
    'Extra Edge',
    'You are given a graph that was originally a tree with `n` nodes labeled from `1` to `n`, but one additional edge has been added. The graph is represented as an array `edges` where `edges[i] = [a, b]` indicates an undirected connection between nodes `a` and `b`.

Find and return the edge that was added to the tree, causing a cycle. If there are multiple edges that could be removed to restore the tree, return the one that appears last in the `edges` array.

**Example 1:**
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: The tree originally connected 1-2 and 1-3. The edge [2,3] creates a cycle 1-2-3-1.
```

**Example 2:**
```
Input: edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]
Output: [1,4]
Explanation: Removing [1,4] breaks the cycle 1-2-3-4-1 and restores a valid tree.
```

**Example 3:**
```
Input: edges = [[1,2],[1,3],[1,4],[3,4]]
Output: [3,4]
Explanation: The edge [3,4] forms a cycle with the paths through node 1.
```',
    'n == edges.length
3 <= n <= 1000
edges[i].length == 2
1 <= edges[i][0], edges[i][1] <= n
edges[i][0] != edges[i][1]
No duplicate edges exist
The graph is connected and contains exactly one cycle'
);

------------------------------------------------------------
-- Add Airport Route problem
-- CodeBite original name: Airport Route (inspired by Reconstruct Itinerary, LC #332)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Airport Route',
    'airport-route',
    'You are given a list of airline `tickets`, where each ticket is represented as `[departure, arrival]` with airport codes as strings. All tickets belong to a traveler whose journey begins at `"JFK"`.

Your task is to reconstruct the complete travel itinerary that uses every ticket exactly once. If there are multiple valid itineraries, return the one that comes first in lexicographical order when compared step by step.

It is guaranteed that at least one valid itinerary exists.

**Example 1:**
```
Input: tickets = [["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]
Output: ["JFK","MUC","LHR","SFO","SJC"]
Explanation: The journey is JFK -> MUC -> LHR -> SFO -> SJC, using all four tickets.
```

**Example 2:**
```
Input: tickets = [["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
Output: ["JFK","ATL","JFK","SFO","ATL","SFO"]
Explanation: Although ["JFK","SFO","ATL","JFK","ATL","SFO"] also uses all tickets, the answer ["JFK","ATL",...] is lexicographically smaller because "ATL" < "SFO" at the second position.
```

**Example 3:**
```
Input: tickets = [["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]
Output: ["JFK","NRT","JFK","KUL"]
Explanation: Choosing JFK -> KUL first would leave us stuck, so the valid path is JFK -> NRT -> JFK -> KUL.
```',
    'HARD',
    '1 <= tickets.length <= 300
tickets[i].length == 2
departure_i and arrival_i consist of 3 uppercase English letters
departure_i != arrival_i
All tickets form at least one valid itinerary
The itinerary always starts from "JFK"',
    153,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]', '["JFK","MUC","LHR","SFO","SJC"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]', '["JFK","ATL","JFK","SFO","ATL","SFO"]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]', '["JFK","NRT","JFK","KUL"]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","AAA"],["AAA","JFK"],["JFK","BBB"],["BBB","JFK"]]', '["JFK","AAA","JFK","BBB","JFK"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","AAA"]]', '["JFK","AAA"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","BBB"],["JFK","AAA"],["AAA","JFK"]]', '["JFK","AAA","JFK","BBB"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["EZE","TIA"],["EZE","HBA"],["AXA","TIA"],["JFK","AXA"],["ANU","JFK"],["ADL","ANU"],["TIA","AUA"],["ANU","AUA"],["ADL","EZE"],["ADL","EZE"],["EZE","ADL"],["AXA","EZE"],["AUA","AXA"],["JFK","ADL"],["AUA","ANU"],["TIA","ADL"],["HBA","EZE"],["AUA","ADL"]]', '["JFK","ADL","ANU","AUA","ADL","EZE","ADL","EZE","HBA","EZE","TIA","ADL","EZE","TIA","AUA","ANU","JFK","AXA","EZE","AUA","AXA","TIA"]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'airport-route'),
    'en',
    'Airport Route',
    'You are given a list of airline `tickets`, where each ticket is represented as `[departure, arrival]` with airport codes as strings. All tickets belong to a traveler whose journey begins at `"JFK"`.

Your task is to reconstruct the complete travel itinerary that uses every ticket exactly once. If there are multiple valid itineraries, return the one that comes first in lexicographical order when compared step by step.

It is guaranteed that at least one valid itinerary exists.

**Example 1:**
```
Input: tickets = [["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]
Output: ["JFK","MUC","LHR","SFO","SJC"]
Explanation: The journey is JFK -> MUC -> LHR -> SFO -> SJC, using all four tickets.
```

**Example 2:**
```
Input: tickets = [["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
Output: ["JFK","ATL","JFK","SFO","ATL","SFO"]
Explanation: Although ["JFK","SFO","ATL","JFK","ATL","SFO"] also uses all tickets, the answer ["JFK","ATL",...] is lexicographically smaller because "ATL" < "SFO" at the second position.
```

**Example 3:**
```
Input: tickets = [["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]
Output: ["JFK","NRT","JFK","KUL"]
Explanation: Choosing JFK -> KUL first would leave us stuck, so the valid path is JFK -> NRT -> JFK -> KUL.
```',
    '1 <= tickets.length <= 300
tickets[i].length == 2
departure_i and arrival_i consist of 3 uppercase English letters
departure_i != arrival_i
All tickets form at least one valid itinerary
The itinerary always starts from "JFK"'
);

