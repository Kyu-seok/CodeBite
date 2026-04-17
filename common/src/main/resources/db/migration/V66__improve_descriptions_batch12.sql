-- Improve descriptions: batch 12

------------------------------------------------------------
-- car-convoy (Car Convoy / Car Fleet)
------------------------------------------------------------
UPDATE problems
SET description = 'There are `n` cars driving along a single-lane road toward a destination at mile marker `target`. You are given two integer arrays `position` and `speed`, both of length `n`, where `position[i]` is the starting mile marker of the `i`-th car and `speed[i]` is its speed in miles per hour.

A car cannot pass another car ahead of it on the road. When a faster car catches up to a slower one, it joins that car and they travel together at the slower car''s speed. A **convoy** is a group of one or more cars traveling at the same speed because the lead car limits the rest.

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
Explanation: The car at position 4 is the slowest. All faster cars behind it eventually catch up, forming a single convoy.
```'
WHERE slug = 'car-convoy';

UPDATE problem_translations
SET description = 'There are `n` cars driving along a single-lane road toward a destination at mile marker `target`. You are given two integer arrays `position` and `speed`, both of length `n`, where `position[i]` is the starting mile marker of the `i`-th car and `speed[i]` is its speed in miles per hour.

A car cannot pass another car ahead of it on the road. When a faster car catches up to a slower one, it joins that car and they travel together at the slower car''s speed. A **convoy** is a group of one or more cars traveling at the same speed because the lead car limits the rest.

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
Explanation: The car at position 4 is the slowest. All faster cars behind it eventually catch up, forming a single convoy.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'car-convoy')
  AND locale = 'en';

------------------------------------------------------------
-- tallest-bar (Tallest Bar / Largest Rectangle in Histogram)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of non-negative integers `heights` representing a histogram where each element is the height of a bar with width `1`, return the area of the largest rectangle that can be formed within the histogram.

The rectangle must be aligned with the horizontal axis and must fit entirely under the bars.

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
```'
WHERE slug = 'tallest-bar';

UPDATE problem_translations
SET description = 'Given an array of non-negative integers `heights` representing a histogram where each element is the height of a bar with width `1`, return the area of the largest rectangle that can be formed within the histogram.

The rectangle must be aligned with the horizontal axis and must fit entirely under the bars.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tallest-bar')
  AND locale = 'en';

------------------------------------------------------------
-- space-rocks (Space Rocks / Asteroid Collision)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `rocks` representing space rocks in a row, determine the state of the rocks after all collisions.

The absolute value of each element represents the rock''s size, and the sign represents its direction: positive means moving right, negative means moving left.

Collision rules:
- Two rocks moving in the same direction never collide.
- When a right-moving rock meets a left-moving rock, the smaller one is destroyed.
- If both rocks are the same size, both are destroyed.
- Rocks that never encounter an opposing rock survive unchanged.

Return an array of the rocks that remain after all collisions.

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
```'
WHERE slug = 'space-rocks';

UPDATE problem_translations
SET description = 'Given an integer array `rocks` representing space rocks in a row, determine the state of the rocks after all collisions.

The absolute value of each element represents the rock''s size, and the sign represents its direction: positive means moving right, negative means moving left.

Collision rules:
- Two rocks moving in the same direction never collide.
- When a right-moving rock meets a left-moving rock, the smaller one is destroyed.
- If both rocks are the same size, both are destroyed.
- Rocks that never encounter an opposing rock survive unchanged.

Return an array of the rocks that remain after all collisions.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-rocks')
  AND locale = 'en';

------------------------------------------------------------
-- time-map (Time Map / Time Based Key-Value Store)
------------------------------------------------------------
UPDATE problems
SET description = 'Design a data structure that stores multiple values for the same key at different timestamps and retrieves the most recent value for a key at or before a given timestamp.

Implement the `TimeMap` class:

- `TimeMap()` initializes the data structure.
- `set(key, value, timestamp)` stores the `key`-`value` pair at the given `timestamp`.
- `get(key, timestamp)` returns the value associated with `key` at the largest timestamp less than or equal to `timestamp`. If no such value exists, return an empty string `""`.

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
```'
WHERE slug = 'time-map';

UPDATE problem_translations
SET description = 'Design a data structure that stores multiple values for the same key at different timestamps and retrieves the most recent value for a key at or before a given timestamp.

Implement the `TimeMap` class:

- `TimeMap()` initializes the data structure.
- `set(key, value, timestamp)` stores the `key`-`value` pair at the given `timestamp`.
- `get(key, timestamp)` returns the value associated with `key` at the largest timestamp less than or equal to `timestamp`. If no such value exists, return an empty string `""`.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map')
  AND locale = 'en';

------------------------------------------------------------
-- sorted-median (Sorted Median / Median of Two Sorted Arrays)
------------------------------------------------------------
UPDATE problems
SET description = 'Given two integer arrays `nums1` and `nums2`, both sorted in non-decreasing order, return the **median** of the two arrays combined.

The median is the middle value when all elements are arranged in order. If the total number of elements is even, the median is the average of the two middle values.

Your solution must run in `O(log(m + n))` time, where `m` is the length of `nums1` and `n` is the length of `nums2`.

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
```'
WHERE slug = 'sorted-median';

UPDATE problem_translations
SET description = 'Given two integer arrays `nums1` and `nums2`, both sorted in non-decreasing order, return the **median** of the two arrays combined.

The median is the middle value when all elements are arranged in order. If the total number of elements is even, the median is the average of the two middle values.

Your solution must run in `O(log(m + n))` time, where `m` is the length of `nums1` and `n` is the length of `nums2`.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-median')
  AND locale = 'en';

------------------------------------------------------------
-- matrix-search-ii (Matrix Search II / Search a 2D Matrix II)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` integer matrix and an integer `target`, return `true` if `target` exists in the matrix, or `false` otherwise.

The matrix has the following properties:
- Each row is sorted in ascending order from left to right.
- Each column is sorted in ascending order from top to bottom.

Note that unlike a fully flattened sorted matrix, the first element of a row is **not** necessarily greater than the last element of the previous row.

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
```'
WHERE slug = 'matrix-search-ii';

UPDATE problem_translations
SET description = 'Given an `m x n` integer matrix and an integer `target`, return `true` if `target` exists in the matrix, or `false` otherwise.

The matrix has the following properties:
- Each row is sorted in ascending order from left to right.
- Each column is sorted in ascending order from top to bottom.

Note that unlike a fully flattened sorted matrix, the first element of a row is **not** necessarily greater than the last element of the previous row.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search-ii')
  AND locale = 'en';

------------------------------------------------------------
-- ship-capacity (Ship Capacity / Capacity to Ship Packages Within D Days)
------------------------------------------------------------
UPDATE problems
SET description = 'A conveyor belt has packages that must be shipped from one port to another within `days` days. The packages are given as an integer array `weights`, where `weights[i]` is the weight of the `i`-th package.

Each day, packages are loaded onto the ship in the order they appear on the belt. The ship carries packages sequentially until adding the next package would exceed its weight capacity. It then departs, and loading resumes the next day with the remaining packages. This repeats until all packages are shipped.

Return the minimum ship capacity that allows all packages to be shipped within `days` days.

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
```'
WHERE slug = 'ship-capacity';

UPDATE problem_translations
SET description = 'A conveyor belt has packages that must be shipped from one port to another within `days` days. The packages are given as an integer array `weights`, where `weights[i]` is the weight of the `i`-th package.

Each day, packages are loaded onto the ship in the order they appear on the belt. The ship carries packages sequentially until adding the next package would exceed its weight capacity. It then departs, and loading resumes the next day with the remaining packages. This repeats until all packages are shipped.

Return the minimum ship capacity that allows all packages to be shipped within `days` days.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ship-capacity')
  AND locale = 'en';

------------------------------------------------------------
-- recent-cache (Recent Cache / LRU Cache)
------------------------------------------------------------
UPDATE problems
SET description = 'Design a cache with a fixed maximum capacity that evicts the **least recently used** entry when full.

Implement the `RecentCache` class:

- `RecentCache(int capacity)` creates a cache with the given positive capacity.
- `int get(int key)` returns the value associated with `key` if it exists, or `-1` if not found. Accessing a key marks it as recently used.
- `void put(int key, int value)` inserts or updates the `key`-`value` pair. If the cache already contains `key`, update its value and mark it as recently used. If inserting a new key would exceed the capacity, evict the least recently used entry first.

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
```'
WHERE slug = 'recent-cache';

UPDATE problem_translations
SET description = 'Design a cache with a fixed maximum capacity that evicts the **least recently used** entry when full.

Implement the `RecentCache` class:

- `RecentCache(int capacity)` creates a cache with the given positive capacity.
- `int get(int key)` returns the value associated with `key` if it exists, or `-1` if not found. Accessing a key marks it as recently used.
- `void put(int key, int value)` inserts or updates the `key`-`value` pair. If the cache already contains `key`, update its value and mark it as recently used. If inserting a new key would exceed the capacity, evict the least recently used entry first.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache')
  AND locale = 'en';

------------------------------------------------------------
-- reverse-k-nodes (Reverse K Nodes / Reverse Nodes in k-Group)
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `head` of a singly linked list and an integer `k`, reverse the nodes in groups of `k` consecutive nodes and return the modified list.

If the number of remaining nodes at the end is fewer than `k`, leave them in their original order.

You must rearrange the node links themselves. Do not modify the values stored in the nodes.

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
```'
WHERE slug = 'reverse-k-nodes';

UPDATE problem_translations
SET description = 'Given the `head` of a singly linked list and an integer `k`, reverse the nodes in groups of `k` consecutive nodes and return the modified list.

If the number of remaining nodes at the end is fewer than `k`, leave them in their original order.

You must rearrange the node links themselves. Do not modify the values stored in the nodes.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-k-nodes')
  AND locale = 'en';

------------------------------------------------------------
-- swap-pairs (Swap Pairs / Swap Nodes in Pairs)
------------------------------------------------------------
UPDATE problems
SET description = 'Given the `head` of a singly linked list, swap every two adjacent nodes and return the head of the modified list.

You must rearrange the node links themselves. Do not modify the values stored in the nodes. If the list has an odd number of nodes, the last node remains in place.

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
```'
WHERE slug = 'swap-pairs';

UPDATE problem_translations
SET description = 'Given the `head` of a singly linked list, swap every two adjacent nodes and return the head of the modified list.

You must rearrange the node links themselves. Do not modify the values stored in the nodes. If the list has an odd number of nodes, the last node remains in place.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-pairs')
  AND locale = 'en';
