-- Phase 3 Batch 2: Stack (#111-113) + Binary Search (#114-117)
-- 7 problems: car-convoy, tallest-bar, space-rocks, time-map, sorted-median, matrix-search-ii, ship-capacity

------------------------------------------------------------
-- Add Car Convoy problem
-- CodeBite original name: Car Convoy (inspired by Car Fleet, LC #853)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Car Convoy',
    'car-convoy',
    'There are `n` cars traveling along a single-lane road toward a destination at mile marker `target`. You are given two integer arrays `position` and `speed`, both of length `n`, where `position[i]` is the current mile marker of the `i`-th car and `speed[i]` is its speed in miles per hour.

A car can never pass another car ahead of it, but it can catch up and then travel at the same speed as the car in front. A **convoy** is a group of cars traveling together at the same speed (a single car also counts as a convoy).

Return the number of convoys that will arrive at the destination.

**Example 1:**
```
Input: target = 12, position = [10,8,0,5,3], speed = [2,4,1,1,3]
Output: 3
Explanation: The cars at positions 10 and 8 both reach the target in the same time and form one convoy. The car at position 3 catches up to the car at position 5, forming a second convoy. The car at position 0 travels alone as a third convoy.
```

**Example 2:**
```
Input: target = 10, position = [3], speed = [3]
Output: 1
```

**Example 3:**
```
Input: target = 100, position = [0,2,4], speed = [4,2,1]
Output: 1
Explanation: The car at position 4 is slowest and all faster cars behind it eventually catch up, forming a single convoy.
```',
    'MEDIUM',
    '1 <= n <= 10^5
0 <= position[i] < target <= 10^9
1 <= speed[i] <= 10^6
All values in `position` are distinct.',
    111,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'12\n[10,8,0,5,3]\n[2,4,1,1,3]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'10\n[3]\n[3]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'100\n[0,2,4]\n[4,2,1]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'10\n[6,8]\n[3,2]', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'20\n[0,5,10,15]\n[10,5,4,1]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'50\n[0,10,20,30,40]\n[5,5,5,5,5]', '5', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'car-convoy'),
    'en',
    'Car Convoy',
    'There are `n` cars traveling along a single-lane road toward a destination at mile marker `target`. You are given two integer arrays `position` and `speed`, both of length `n`, where `position[i]` is the current mile marker of the `i`-th car and `speed[i]` is its speed in miles per hour.

A car can never pass another car ahead of it, but it can catch up and then travel at the same speed as the car in front. A **convoy** is a group of cars traveling together at the same speed (a single car also counts as a convoy).

Return the number of convoys that will arrive at the destination.

**Example 1:**
```
Input: target = 12, position = [10,8,0,5,3], speed = [2,4,1,1,3]
Output: 3
Explanation: The cars at positions 10 and 8 both reach the target in the same time and form one convoy. The car at position 3 catches up to the car at position 5, forming a second convoy. The car at position 0 travels alone as a third convoy.
```

**Example 2:**
```
Input: target = 10, position = [3], speed = [3]
Output: 1
```

**Example 3:**
```
Input: target = 100, position = [0,2,4], speed = [4,2,1]
Output: 1
Explanation: The car at position 4 is slowest and all faster cars behind it eventually catch up, forming a single convoy.
```',
    '1 <= n <= 10^5
0 <= position[i] < target <= 10^9
1 <= speed[i] <= 10^6
All values in `position` are distinct.'
);

------------------------------------------------------------
-- Add Tallest Bar problem
-- CodeBite original name: Tallest Bar (inspired by LeetCode #84 Largest Rectangle in Histogram)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Tallest Bar',
    'tallest-bar',
    'Given an array of non-negative integers `heights` where each element represents the height of a bar in a histogram (all bars have a width of 1), find the area of the largest rectangle that can be formed within the histogram.

The rectangle must be aligned with the horizontal axis and fit entirely under the bars.

**Example 1:**
```
Input: heights = [2,1,5,6,2,3]
Output: 10
Explanation: The largest rectangle spans bars at indices 2 and 3 (heights 5 and 6), giving area = 5 * 2 = 10.
```

**Example 2:**
```
Input: heights = [2,4]
Output: 4
```

**Example 3:**
```
Input: heights = [6,2,5,4,5,1,6]
Output: 12
Explanation: The largest rectangle spans indices 2 through 4 (minimum height 4, width 3), giving area = 4 * 3 = 12.
```',
    'HARD',
    '1 <= heights.length <= 10^5
0 <= heights[i] <= 10^4',
    112,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[2,1,5,6,2,3]', '10', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[2,4]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[6,2,5,4,5,1,6]', '12', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[0,0,0]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[3,3,3,3,3]', '15', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[1,2,3,4,5]', '9', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[5,4,3,2,1]', '9', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tallest-bar'),
    'en',
    'Tallest Bar',
    'Given an array of non-negative integers `heights` where each element represents the height of a bar in a histogram (all bars have a width of 1), find the area of the largest rectangle that can be formed within the histogram.

The rectangle must be aligned with the horizontal axis and fit entirely under the bars.

**Example 1:**
```
Input: heights = [2,1,5,6,2,3]
Output: 10
Explanation: The largest rectangle spans bars at indices 2 and 3 (heights 5 and 6), giving area = 5 * 2 = 10.
```

**Example 2:**
```
Input: heights = [2,4]
Output: 4
```

**Example 3:**
```
Input: heights = [6,2,5,4,5,1,6]
Output: 12
Explanation: The largest rectangle spans indices 2 through 4 (minimum height 4, width 3), giving area = 4 * 3 = 12.
```',
    '1 <= heights.length <= 10^5
0 <= heights[i] <= 10^4'
);

------------------------------------------------------------
-- Add Space Rocks problem
-- CodeBite original name: Space Rocks (inspired by LeetCode #735 Asteroid Collision)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Space Rocks',
    'space-rocks',
    'Given an integer array `rocks` representing space rocks in a row, where the absolute value is the rock''s size and the sign indicates direction (positive = moving right, negative = moving left), determine the state of the rocks after all collisions.

Two rocks moving in the same direction will never collide. A rock moving right and a rock moving left will collide when they meet. During a collision, the smaller rock is destroyed. If both rocks are the same size, both are destroyed. Rocks that never meet any opposing rock survive unchanged.

**Example 1:**
```
Input: rocks = [5,10,-5]
Output: [5,10]
Explanation: The 10 and -5 collide, and 10 survives. The 5 and 10 never collide since they move in the same direction.
```

**Example 2:**
```
Input: rocks = [8,-8]
Output: []
Explanation: The 8 and -8 collide and both are destroyed since they are the same size.
```

**Example 3:**
```
Input: rocks = [-2,-1,1,2]
Output: [-2,-1,1,2]
Explanation: Rocks moving left are already to the left of rocks moving right, so no collisions occur.
```',
    'MEDIUM',
    '2 <= rocks.length <= 10^4
-1000 <= rocks[i] <= 1000
rocks[i] != 0',
    113,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[5,10,-5]', '[5,10]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[8,-8]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[-2,-1,1,2]', '[-2,-1,1,2]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[10,2,-5]', '[10]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[-1,-2,1,2]', '[-1,-2,1,2]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[1,-1,-2,3]', '[-2,3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[1,2,3,-4]', '[-4]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[5,5,-5,-5]', '[]', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'space-rocks'),
    'en',
    'Space Rocks',
    'Given an integer array `rocks` representing space rocks in a row, where the absolute value is the rock''s size and the sign indicates direction (positive = moving right, negative = moving left), determine the state of the rocks after all collisions.

Two rocks moving in the same direction will never collide. A rock moving right and a rock moving left will collide when they meet. During a collision, the smaller rock is destroyed. If both rocks are the same size, both are destroyed. Rocks that never meet any opposing rock survive unchanged.

**Example 1:**
```
Input: rocks = [5,10,-5]
Output: [5,10]
Explanation: The 10 and -5 collide, and 10 survives. The 5 and 10 never collide since they move in the same direction.
```

**Example 2:**
```
Input: rocks = [8,-8]
Output: []
Explanation: The 8 and -8 collide and both are destroyed since they are the same size.
```

**Example 3:**
```
Input: rocks = [-2,-1,1,2]
Output: [-2,-1,1,2]
Explanation: Rocks moving left are already to the left of rocks moving right, so no collisions occur.
```',
    '2 <= rocks.length <= 10^4
-1000 <= rocks[i] <= 1000
rocks[i] != 0'
);

------------------------------------------------------------
-- Add Time Map problem
-- CodeBite original name: Time Map (inspired by LeetCode #981 Time Based Key-Value Store)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Time Map',
    'time-map',
    'Design a data structure that can store multiple values for the same key at different timestamps, and retrieve the value associated with a key at a specific point in time.

Implement the `TimeMap` class:

- `TimeMap()` Initializes the data structure.
- `set(key, value, timestamp)` Stores the given `key`-`value` pair at the specified `timestamp`.
- `get(key, timestamp)` Returns the value that was set for `key` at the largest timestamp that is less than or equal to the given `timestamp`. If no such value exists, return an empty string `""`.

All timestamps provided to `set` are strictly increasing for each key.

**Example 1:**
```
Input: ["TimeMap","set","get","get","set","get"]
       [[],["foo","bar",1],["foo",1],["foo",3],["foo","bar2",4],["foo",4]]
Output: [null,null,"bar","bar",null,"bar2"]
Explanation: set("foo", "bar", 1) stores "bar" at timestamp 1. get("foo", 1) returns "bar". get("foo", 3) returns "bar" since timestamp 1 <= 3. set("foo", "bar2", 4) stores "bar2" at timestamp 4. get("foo", 4) returns "bar2".
```

**Example 2:**
```
Input: ["TimeMap","set","set","get","get","get"]
       [[],["hello","world",1],["hello","code",2],["hello",1],["hello",2],["hello",3]]
Output: [null,null,null,"world","code","code"]
Explanation: get("hello", 1) returns "world". get("hello", 2) returns "code". get("hello", 3) returns "code" since timestamp 2 <= 3.
```

**Example 3:**
```
Input: ["TimeMap","set","get","get"]
       [[],["key","val",5],["key",3],["key",5]]
Output: [null,null,"","val"]
Explanation: get("key", 3) returns "" because no value was set at or before timestamp 3. get("key", 5) returns "val".
```',
    'MEDIUM',
    '1 <= key.length, value.length <= 100
1 <= timestamp <= 10^7
All timestamps for set operations are strictly increasing per key
At most 2 * 10^5 calls to set and get',
    114,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","get","get","set","get"]\n[[],["foo","bar",1],["foo",1],["foo",3],["foo","bar2",4],["foo",4]]', '[null,null,"bar","bar",null,"bar2"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","get","get","get"]\n[[],["hello","world",1],["hello","code",2],["hello",1],["hello",2],["hello",3]]', '[null,null,null,"world","code","code"]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","get","get"]\n[[],["key","val",5],["key",3],["key",5]]', '[null,null,"","val"]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","set","get","get","get","get"]\n[[],["a","v1",1],["a","v2",5],["a","v3",10],["a",1],["a",4],["a",7],["a",15]]', '[null,null,null,null,"v1","v1","v2","v3"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","get","set","get","get"]\n[[],["missing",1],["x","found",2],["x",1],["x",2]]', '[null,"",null,"","found"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","set","get","get"]\n[[],["k","alpha",1],["k","beta",2],["j","gamma",1],["k",2],["j",1]]', '[null,null,null,null,"beta","gamma"]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'time-map'),
    'en',
    'Time Map',
    'Design a data structure that can store multiple values for the same key at different timestamps, and retrieve the value associated with a key at a specific point in time.

Implement the `TimeMap` class:

- `TimeMap()` Initializes the data structure.
- `set(key, value, timestamp)` Stores the given `key`-`value` pair at the specified `timestamp`.
- `get(key, timestamp)` Returns the value that was set for `key` at the largest timestamp that is less than or equal to the given `timestamp`. If no such value exists, return an empty string `""`.

All timestamps provided to `set` are strictly increasing for each key.

**Example 1:**
```
Input: ["TimeMap","set","get","get","set","get"]
       [[],["foo","bar",1],["foo",1],["foo",3],["foo","bar2",4],["foo",4]]
Output: [null,null,"bar","bar",null,"bar2"]
Explanation: set("foo", "bar", 1) stores "bar" at timestamp 1. get("foo", 1) returns "bar". get("foo", 3) returns "bar" since timestamp 1 <= 3. set("foo", "bar2", 4) stores "bar2" at timestamp 4. get("foo", 4) returns "bar2".
```

**Example 2:**
```
Input: ["TimeMap","set","set","get","get","get"]
       [[],["hello","world",1],["hello","code",2],["hello",1],["hello",2],["hello",3]]
Output: [null,null,null,"world","code","code"]
Explanation: get("hello", 1) returns "world". get("hello", 2) returns "code". get("hello", 3) returns "code" since timestamp 2 <= 3.
```

**Example 3:**
```
Input: ["TimeMap","set","get","get"]
       [[],["key","val",5],["key",3],["key",5]]
Output: [null,null,"","val"]
Explanation: get("key", 3) returns "" because no value was set at or before timestamp 3. get("key", 5) returns "val".
```',
    '1 <= key.length, value.length <= 100
1 <= timestamp <= 10^7
All timestamps for set operations are strictly increasing per key
At most 2 * 10^5 calls to set and get'
);

------------------------------------------------------------
-- Add Sorted Median problem
-- CodeBite original name: Sorted Median (inspired by LeetCode #4 Median of Two Sorted Arrays)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Sorted Median',
    'sorted-median',
    'Given two integer arrays `nums1` and `nums2`, each sorted in non-decreasing order, find the **median** of the combined sorted sequence. Your solution must run in `O(log(m + n))` time, where `m` and `n` are the lengths of the two arrays.

The median is the middle value when all elements are arranged in order. If the total number of elements is even, the median is the average of the two middle values.

**Example 1:**
```
Input: nums1 = [1,3], nums2 = [2]
Output: 2.0
Explanation: The merged sequence is [1,2,3]. The middle element is 2.
```

**Example 2:**
```
Input: nums1 = [1,2], nums2 = [3,4]
Output: 2.5
Explanation: The merged sequence is [1,2,3,4]. The two middle elements are 2 and 3, so the median is (2 + 3) / 2 = 2.5.
```

**Example 3:**
```
Input: nums1 = [], nums2 = [7]
Output: 7.0
Explanation: One array is empty, so the median is simply 7.
```',
    'HARD',
    '0 <= nums1.length, nums2.length <= 1000
1 <= nums1.length + nums2.length <= 2000
-10^6 <= nums1[i], nums2[i] <= 10^6
Both arrays are sorted in non-decreasing order.',
    115,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,3]\n[2]', '2.0', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,2]\n[3,4]', '2.5', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[]\n[7]', '7.0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,2,3,4,5]\n[6,7,8,9,10]', '5.5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[2]\n[]', '2.0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,1,1]\n[1,1,1]', '1.0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[-5,-3,0]\n[-1,2,4]', '-0.5', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[100000]\n[-100000]', '0.0', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sorted-median'),
    'en',
    'Sorted Median',
    'Given two integer arrays `nums1` and `nums2`, each sorted in non-decreasing order, find the **median** of the combined sorted sequence. Your solution must run in `O(log(m + n))` time, where `m` and `n` are the lengths of the two arrays.

The median is the middle value when all elements are arranged in order. If the total number of elements is even, the median is the average of the two middle values.

**Example 1:**
```
Input: nums1 = [1,3], nums2 = [2]
Output: 2.0
Explanation: The merged sequence is [1,2,3]. The middle element is 2.
```

**Example 2:**
```
Input: nums1 = [1,2], nums2 = [3,4]
Output: 2.5
Explanation: The merged sequence is [1,2,3,4]. The two middle elements are 2 and 3, so the median is (2 + 3) / 2 = 2.5.
```

**Example 3:**
```
Input: nums1 = [], nums2 = [7]
Output: 7.0
Explanation: One array is empty, so the median is simply 7.
```',
    '0 <= nums1.length, nums2.length <= 1000
1 <= nums1.length + nums2.length <= 2000
-10^6 <= nums1[i], nums2[i] <= 10^6
Both arrays are sorted in non-decreasing order.'
);

------------------------------------------------------------
-- Add Matrix Search II problem
-- CodeBite original name: Matrix Search II (inspired by LeetCode #240 Search a 2D Matrix II)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Matrix Search II',
    'matrix-search-ii',
    'Given an `m x n` integer matrix `matrix` and an integer `target`, return `true` if `target` exists in the matrix, or `false` otherwise.

Each row of the matrix is sorted in ascending order from left to right. Each column is sorted in ascending order from top to bottom. Note that unlike a fully flattened sorted matrix, the first element of a row is **not** necessarily greater than the last element of the previous row.

**Example 1:**
```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 5
Output: true
```

**Example 2:**
```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 20
Output: false
```

**Example 3:**
```
Input: matrix = [[-5,-3],[2,4]], target = -3
Output: true
Explanation: -3 is found in the first row.
```',
    'MEDIUM',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 300
-10^9 <= matrix[i][j] <= 10^9
-10^9 <= target <= 10^9',
    116,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]\n5', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]\n20', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[-5,-3],[2,4]]\n-3', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1]]\n1', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1]]\n2', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15],[16,17,18,19,20],[21,22,23,24,25]]\n15', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,3,5],[2,4,6],[3,5,7]]\n0', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]\n30', 'true', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'matrix-search-ii'),
    'en',
    'Matrix Search II',
    'Given an `m x n` integer matrix `matrix` and an integer `target`, return `true` if `target` exists in the matrix, or `false` otherwise.

Each row of the matrix is sorted in ascending order from left to right. Each column is sorted in ascending order from top to bottom. Note that unlike a fully flattened sorted matrix, the first element of a row is **not** necessarily greater than the last element of the previous row.

**Example 1:**
```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 5
Output: true
```

**Example 2:**
```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 20
Output: false
```

**Example 3:**
```
Input: matrix = [[-5,-3],[2,4]], target = -3
Output: true
Explanation: -3 is found in the first row.
```',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 300
-10^9 <= matrix[i][j] <= 10^9
-10^9 <= target <= 10^9'
);

------------------------------------------------------------
-- Add Ship Capacity problem
-- CodeBite original name: Ship Capacity (inspired by LeetCode #1011 Capacity to Ship Packages Within D Days)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Ship Capacity',
    'ship-capacity',
    'A conveyor belt has packages that must be shipped from one port to another within `days` days. The packages are given as an integer array `weights` where `weights[i]` is the weight of the `i`-th package on the belt.

Each day, packages are loaded onto the ship in the order they appear on the belt. The ship carries packages sequentially until adding the next package would exceed its weight capacity. It then departs, and the remaining packages are loaded starting the next day. This process repeats until all packages are shipped.

Return the minimum weight capacity of the ship that allows all packages to be shipped within `days` days.

**Example 1:**
```
Input: weights = [1,2,3,4,5,6,7,8,9,10], days = 5
Output: 15
Explanation: A capacity of 15 ships the packages in 5 days: [1,2,3,4,5], [6,7], [8], [9], [10].
```

**Example 2:**
```
Input: weights = [3,2,2,4,1,4], days = 3
Output: 6
Explanation: A capacity of 6 ships the packages in 3 days: [3,2], [2,4], [1,4].
```

**Example 3:**
```
Input: weights = [1,2,3,1,1], days = 4
Output: 3
Explanation: A capacity of 3 ships the packages in 4 days: [1,2], [3], [1,1], with one day to spare.
```',
    'MEDIUM',
    '1 <= days <= weights.length <= 5 * 10^4
1 <= weights[i] <= 500',
    117,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,2,3,4,5,6,7,8,9,10]\n5', '15', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[3,2,2,4,1,4]\n3', '6', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,2,3,1,1]\n4', '3', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[10]\n1', '10', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,1,1,1,1]\n1', '5', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,1,1,1,1]\n5', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[500,500,500,500]\n2', '1000', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[7,2,5,10,8]\n2', '18', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ship-capacity'),
    'en',
    'Ship Capacity',
    'A conveyor belt has packages that must be shipped from one port to another within `days` days. The packages are given as an integer array `weights` where `weights[i]` is the weight of the `i`-th package on the belt.

Each day, packages are loaded onto the ship in the order they appear on the belt. The ship carries packages sequentially until adding the next package would exceed its weight capacity. It then departs, and the remaining packages are loaded starting the next day. This process repeats until all packages are shipped.

Return the minimum weight capacity of the ship that allows all packages to be shipped within `days` days.

**Example 1:**
```
Input: weights = [1,2,3,4,5,6,7,8,9,10], days = 5
Output: 15
Explanation: A capacity of 15 ships the packages in 5 days: [1,2,3,4,5], [6,7], [8], [9], [10].
```

**Example 2:**
```
Input: weights = [3,2,2,4,1,4], days = 3
Output: 6
Explanation: A capacity of 6 ships the packages in 3 days: [3,2], [2,4], [1,4].
```

**Example 3:**
```
Input: weights = [1,2,3,1,1], days = 4
Output: 3
Explanation: A capacity of 3 ships the packages in 4 days: [1,2], [3], [1,1], with one day to spare.
```',
    '1 <= days <= weights.length <= 5 * 10^4
1 <= weights[i] <= 500'
);

