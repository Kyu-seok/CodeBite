-- Phase 2 Batch 6: 9 problems — Greedy (2) + Intervals (3) + Heap (2) + Math (1) + Bits (1)

------------------------------------------------------------
-- GREEDY
------------------------------------------------------------

-- Jump Game II
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Jump Game II',
    'jump-game-ii',
    'You are given a **0-indexed** array of integers `nums` of length `n`. You are initially positioned at `nums[0]`.

Each element `nums[i]` represents the maximum length of a forward jump from index `i`.

Return the minimum number of jumps to reach `nums[n - 1]`.

**Example 1:**
```
Input: nums = [2,3,1,1,4]
Output: 2
Explanation: The minimum number of jumps to reach the last index is 2. Jump 1 step from index 0 to 1, then 3 steps to the last index.
```

**Example 2:**
```
Input: nums = [2,3,0,1,4]
Output: 2
```',
    'MEDIUM',
    '1 <= nums.length <= 10^4
0 <= nums[i] <= 1000
It is guaranteed that you can reach nums[n - 1].',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[2,3,1,1,4]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[2,3,0,1,4]', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1,2,3]', '2', FALSE, 4);

-- Gas Station
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Gas Station',
    'gas-station',
    'There are `n` gas stations along a circular route, where the amount of gas at the `i`-th station is `gas[i]`.

You have a car with an unlimited gas tank and it costs `cost[i]` of gas to travel from the `i`-th station to its next `(i + 1)`-th station. You begin the journey with an empty tank at one of the gas stations.

Given two integer arrays `gas` and `cost`, return the starting gas station''s index if you can travel around the circuit once in the clockwise direction, otherwise return `-1`. If there exists a solution, it is **guaranteed** to be **unique**.

**Example 1:**
```
Input: gas = [1,2,3,4,5], cost = [3,4,5,1,2]
Output: 3
```

**Example 2:**
```
Input: gas = [2,3,4], cost = [3,4,3]
Output: -1
```',
    'MEDIUM',
    'n == gas.length == cost.length
1 <= n <= 10^5
0 <= gas[i], cost[i] <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'gas-station'), '[1,2,3,4,5]
[3,4,5,1,2]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), '[2,3,4]
[3,4,3]', '-1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), '[5,1,2,3,4]
[4,4,1,5,1]', '4', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), '[3]
[3]', '0', FALSE, 4);

------------------------------------------------------------
-- INTERVALS
------------------------------------------------------------

-- Insert Interval
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Insert Interval',
    'insert-interval',
    'You are given an array of non-overlapping intervals `intervals` where `intervals[i] = [start, end]` represent the start and end of the `i`-th interval and `intervals` is sorted in ascending order by `start`. You are also given an interval `newInterval = [start, end]` that represents the interval to be inserted.

Insert `newInterval` into `intervals` such that `intervals` is still sorted in ascending order by `start` and `intervals` still does not have any overlapping intervals (merge overlapping intervals if necessary).

Return `intervals` after the insertion.

**Example 1:**
```
Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
Output: [[1,5],[6,9]]
```

**Example 2:**
```
Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
Output: [[1,2],[3,10],[12,16]]
```',
    'MEDIUM',
    '0 <= intervals.length <= 10^4
intervals[i].length == 2
0 <= start <= end <= 10^5
intervals is sorted by start in ascending order.
newInterval.length == 2
0 <= start <= end <= 10^5',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), '[[1,3],[6,9]]
[2,5]', '[[1,5],[6,9]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), '[[1,2],[3,5],[6,7],[8,10],[12,16]]
[4,8]', '[[1,2],[3,10],[12,16]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), '[]
[5,7]', '[[5,7]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), '[[1,5]]
[2,3]', '[[1,5]]', FALSE, 4);

-- Non-overlapping (Non-overlapping Intervals)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Non-overlapping Intervals',
    'non-overlapping',
    'Given an array of intervals `intervals` where `intervals[i] = [start, end]`, return the minimum number of intervals you need to remove to make the rest of the intervals non-overlapping.

**Example 1:**
```
Input: intervals = [[1,2],[2,3],[3,4],[1,3]]
Output: 1
Explanation: [1,3] can be removed and the rest of the intervals are non-overlapping.
```

**Example 2:**
```
Input: intervals = [[1,2],[1,2],[1,2]]
Output: 2
Explanation: You need to remove two [1,2] to make the rest of the intervals non-overlapping.
```

**Example 3:**
```
Input: intervals = [[1,2],[2,3]]
Output: 0
Explanation: You don''t need to remove any of the intervals since they''re already non-overlapping.
```',
    'MEDIUM',
    '1 <= intervals.length <= 10^5
intervals[i].length == 2
-5 * 10^4 <= start < end <= 5 * 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,2],[2,3],[3,4],[1,3]]', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,2],[1,2],[1,2]]', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,2],[2,3]]', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,100],[11,22],[1,11],[2,12]]', '2', FALSE, 4);

-- Meeting Rooms (Meeting Rooms II)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Meeting Rooms',
    'meeting-rooms',
    'Given an array of meeting time intervals `intervals` where `intervals[i] = [start, end]`, return the minimum number of conference rooms required.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: 1
```',
    'MEDIUM',
    '1 <= intervals.length <= 10^4
0 <= start < end <= 10^6',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[0,30],[5,10],[15,20]]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[7,10],[2,4]]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[1,5],[2,3],[3,4],[4,6]]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[0,1],[1,2],[2,3]]', '1', FALSE, 4);

------------------------------------------------------------
-- HEAP / PRIORITY QUEUE
------------------------------------------------------------

-- Last Stone (Last Stone Weight)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Last Stone',
    'last-stone',
    'You are given an array of integers `stones` where `stones[i]` is the weight of the `i`-th stone.

We are playing a game with the stones. On each turn, we choose the **heaviest two stones** and smash them together. Suppose the heaviest two stones have weights `x` and `y` with `x <= y`. The result of this smash is:
- If `x == y`, both stones are destroyed, and
- If `x != y`, the stone of weight `x` is destroyed, and the stone of weight `y` has new weight `y - x`.

At the end of the game, there is **at most one** stone left. Return the weight of the last remaining stone. If there are no stones left, return `0`.

**Example 1:**
```
Input: stones = [2,7,4,1,8,1]
Output: 1
Explanation:
We combine 7 and 8 to get 1 so the array converts to [2,4,1,1,1] then,
we combine 2 and 4 to get 2 so the array converts to [2,1,1,1] then,
we combine 2 and 1 to get 1 so the array converts to [1,1,1] then,
we combine 1 and 1 to get 0 so the array converts to [1] then that is the value of the last stone.
```

**Example 2:**
```
Input: stones = [1]
Output: 1
```',
    'EASY',
    '1 <= stones.length <= 30
1 <= stones[i] <= 1000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[2,7,4,1,8,1]', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[1]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[3,7,2]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[2,2]', '0', FALSE, 4);

-- K Closest Points (K Closest Points to Origin)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'K Closest Points',
    'k-closest-points',
    'Given an array of `points` where `points[i] = [x, y]` represents a point on the X-Y plane and an integer `k`, return the `k` closest points to the origin `(0, 0)`.

The distance between two points on the X-Y plane is the Euclidean distance (i.e., `√(x1 - x2)² + (y1 - y2)²`).

You may return the answer in **any order**. The answer is **guaranteed** to be unique (except for the order that it is in).

**Example 1:**
```
Input: points = [[1,3],[-2,2]], k = 1
Output: [[-2,2]]
Explanation: The distance between (1, 3) and the origin is sqrt(10). The distance between (-2, 2) and the origin is sqrt(8). Since sqrt(8) < sqrt(10), (-2, 2) is closer.
```

**Example 2:**
```
Input: points = [[3,3],[5,-1],[-2,4]], k = 2
Output: [[3,3],[-2,4]]
```',
    'MEDIUM',
    '1 <= k <= points.length <= 10^4
-10^4 <= x, y <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), '[[1,3],[-2,2]]
1', '[[-2,2]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), '[[3,3],[5,-1],[-2,4]]
2', '[[-2,4],[3,3]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), '[[0,1],[1,0]]
2', '[[0,1],[1,0]]', FALSE, 3);

------------------------------------------------------------
-- MATH & GEOMETRY
------------------------------------------------------------

-- Spiral Matrix
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Spiral Matrix',
    'spiral-matrix',
    'Given an `m x n` matrix, return all elements of the matrix in spiral order.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]
```

**Example 2:**
```
Input: matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
Output: [1,2,3,4,8,12,11,10,9,5,6,7]
```',
    'MEDIUM',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 10
-100 <= matrix[i][j] <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2,3],[4,5,6],[7,8,9]]', '[1,2,3,6,9,8,7,4,5]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2,3,4],[5,6,7,8],[9,10,11,12]]', '[1,2,3,4,8,12,11,10,9,5,6,7]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1]]', '[1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2],[3,4]]', '[1,2,4,3]', FALSE, 4);

------------------------------------------------------------
-- BIT MANIPULATION
------------------------------------------------------------

-- Count Bits (Number of 1 Bits)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Count Bits',
    'count-bits',
    'Write a function that takes the binary representation of a positive integer and returns the number of set bits it has (also known as the Hamming weight).

**Example 1:**
```
Input: n = 11
Output: 3
Explanation: The input binary string 1011 has a total of three set bits.
```

**Example 2:**
```
Input: n = 128
Output: 1
Explanation: The input binary string 10000000 has a total of one set bit.
```

**Example 3:**
```
Input: n = 2147483645
Output: 30
```',
    'EASY',
    '1 <= n <= 2^31 - 1',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '11', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '128', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '2147483645', '30', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '255', '8', FALSE, 5);

------------------------------------------------------------
-- ENGLISH TRANSLATIONS
------------------------------------------------------------

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'jump-game-ii', 'gas-station',
    'insert-interval', 'non-overlapping', 'meeting-rooms',
    'last-stone', 'k-closest-points',
    'spiral-matrix', 'count-bits'
);
