-- Improve descriptions: batch 10

------------------------------------------------------------
-- unique-paths (Grid Paths / Unique Paths)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given two integers `m` and `n` representing the dimensions of an `m x n` grid.

A robot starts at the top-left corner of the grid (position `[0, 0]`) and wants to reach the bottom-right corner (position `[m - 1, n - 1]`). The robot can only move **right** or **down** at each step.

Return the total number of unique paths the robot can take to reach the bottom-right corner.

**Example 1:**
```
Input: m = 3, n = 7
Output: 28
```

**Example 2:**
```
Input: m = 3, n = 2
Output: 3
Explanation: From the top-left corner, there are exactly 3 paths to the bottom-right corner:
1. Right -> Down -> Down
2. Down -> Down -> Right
3. Down -> Right -> Down
```'
WHERE slug = 'unique-paths';

UPDATE problem_translations
SET description = 'You are given two integers `m` and `n` representing the dimensions of an `m x n` grid.

A robot starts at the top-left corner of the grid (position `[0, 0]`) and wants to reach the bottom-right corner (position `[m - 1, n - 1]`). The robot can only move **right** or **down** at each step.

Return the total number of unique paths the robot can take to reach the bottom-right corner.

**Example 1:**
```
Input: m = 3, n = 7
Output: 28
```

**Example 2:**
```
Input: m = 3, n = 2
Output: 3
Explanation: From the top-left corner, there are exactly 3 paths to the bottom-right corner:
1. Right -> Down -> Down
2. Down -> Down -> Right
3. Down -> Right -> Down
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-paths')
  AND locale = 'en';

------------------------------------------------------------
-- longest-common-subseq (Common Subsequence / Longest Common Subsequence)
------------------------------------------------------------
UPDATE problems
SET description = 'Given two strings `text1` and `text2`, return the length of their **longest common subsequence**. If there is no common subsequence, return `0`.

A **subsequence** is a sequence of characters that appears in the same relative order but not necessarily contiguously. For example, `"ace"` is a subsequence of `"abcde"` because you can obtain it by deleting `b` and `d`.

**Example 1:**
```
Input: text1 = "abcde", text2 = "ace"
Output: 3
Explanation: The longest common subsequence is "ace" and its length is 3.
```

**Example 2:**
```
Input: text1 = "abc", text2 = "abc"
Output: 3
Explanation: The longest common subsequence is "abc" and its length is 3.
```

**Example 3:**
```
Input: text1 = "abc", text2 = "def"
Output: 0
Explanation: There is no common subsequence, so the result is 0.
```'
WHERE slug = 'longest-common-subseq';

UPDATE problem_translations
SET description = 'Given two strings `text1` and `text2`, return the length of their **longest common subsequence**. If there is no common subsequence, return `0`.

A **subsequence** is a sequence of characters that appears in the same relative order but not necessarily contiguously. For example, `"ace"` is a subsequence of `"abcde"` because you can obtain it by deleting `b` and `d`.

**Example 1:**
```
Input: text1 = "abcde", text2 = "ace"
Output: 3
Explanation: The longest common subsequence is "ace" and its length is 3.
```

**Example 2:**
```
Input: text1 = "abc", text2 = "abc"
Output: 3
Explanation: The longest common subsequence is "abc" and its length is 3.
```

**Example 3:**
```
Input: text1 = "abc", text2 = "def"
Output: 0
Explanation: There is no common subsequence, so the result is 0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-common-subseq')
  AND locale = 'en';

------------------------------------------------------------
-- edit-distance (Transform Distance / Edit Distance)
------------------------------------------------------------
UPDATE problems
SET description = 'Given two strings `word1` and `word2`, return the minimum number of operations required to convert `word1` into `word2`.

You may perform exactly three types of operations:
- **Insert** a character
- **Delete** a character
- **Replace** a character

Each operation counts as one step.

**Example 1:**
```
Input: word1 = "horse", word2 = "ros"
Output: 3
Explanation:
horse -> rorse (replace ''h'' with ''r'')
rorse -> rose (remove ''r'')
rose -> ros (remove ''e'')
```

**Example 2:**
```
Input: word1 = "intention", word2 = "execution"
Output: 5
Explanation:
intention -> inention (remove ''t'')
inention -> enention (replace ''i'' with ''e'')
enention -> exention (replace ''n'' with ''x'')
exention -> exection (replace ''n'' with ''c'')
exection -> execution (insert ''u'')
```'
WHERE slug = 'edit-distance';

UPDATE problem_translations
SET description = 'Given two strings `word1` and `word2`, return the minimum number of operations required to convert `word1` into `word2`.

You may perform exactly three types of operations:
- **Insert** a character
- **Delete** a character
- **Replace** a character

Each operation counts as one step.

**Example 1:**
```
Input: word1 = "horse", word2 = "ros"
Output: 3
Explanation:
horse -> rorse (replace ''h'' with ''r'')
rorse -> rose (remove ''r'')
rose -> ros (remove ''e'')
```

**Example 2:**
```
Input: word1 = "intention", word2 = "execution"
Output: 5
Explanation:
intention -> inention (remove ''t'')
inention -> enention (replace ''i'' with ''e'')
enention -> exention (replace ''n'' with ''x'')
exention -> exection (replace ''n'' with ''c'')
exection -> execution (insert ''u'')
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'edit-distance')
  AND locale = 'en';

------------------------------------------------------------
-- jump-game-ii (Farthest Jump / Jump Game II)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a **0-indexed** array of integers `nums` of length `n`. You start at index `0`.

Each element `nums[i]` represents the maximum number of positions you can jump forward from index `i`. For example, if `nums[i] = 3`, you can jump to index `i + 1`, `i + 2`, or `i + 3`.

Return the minimum number of jumps needed to reach the last index `nums[n - 1]`. The input is guaranteed to have a valid path to the end.

**Example 1:**
```
Input: nums = [2,3,1,1,4]
Output: 2
Explanation: Jump 1 step from index 0 to index 1, then 3 steps from index 1 to the last index.
```

**Example 2:**
```
Input: nums = [2,3,0,1,4]
Output: 2
```'
WHERE slug = 'jump-game-ii';

UPDATE problem_translations
SET description = 'You are given a **0-indexed** array of integers `nums` of length `n`. You start at index `0`.

Each element `nums[i]` represents the maximum number of positions you can jump forward from index `i`. For example, if `nums[i] = 3`, you can jump to index `i + 1`, `i + 2`, or `i + 3`.

Return the minimum number of jumps needed to reach the last index `nums[n - 1]`. The input is guaranteed to have a valid path to the end.

**Example 1:**
```
Input: nums = [2,3,1,1,4]
Output: 2
Explanation: Jump 1 step from index 0 to index 1, then 3 steps from index 1 to the last index.
```

**Example 2:**
```
Input: nums = [2,3,0,1,4]
Output: 2
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'jump-game-ii')
  AND locale = 'en';

------------------------------------------------------------
-- gas-station (Fuel Circuit / Gas Station)
------------------------------------------------------------
UPDATE problems
SET description = 'There are `n` gas stations arranged along a circular route. The amount of gas available at station `i` is `gas[i]`.

You have a car with an unlimited gas tank. Traveling from station `i` to station `i + 1` costs `cost[i]` units of gas. You begin the journey with an empty tank at one of the gas stations.

Given two integer arrays `gas` and `cost`, return the index of the starting gas station if you can complete one full clockwise loop around the circuit. If no valid starting station exists, return `-1`.

If a solution exists, it is **guaranteed** to be unique.

**Example 1:**
```
Input: gas = [1,2,3,4,5], cost = [3,4,5,1,2]
Output: 3
```

**Example 2:**
```
Input: gas = [2,3,4], cost = [3,4,3]
Output: -1
```'
WHERE slug = 'gas-station';

UPDATE problem_translations
SET description = 'There are `n` gas stations arranged along a circular route. The amount of gas available at station `i` is `gas[i]`.

You have a car with an unlimited gas tank. Traveling from station `i` to station `i + 1` costs `cost[i]` units of gas. You begin the journey with an empty tank at one of the gas stations.

Given two integer arrays `gas` and `cost`, return the index of the starting gas station if you can complete one full clockwise loop around the circuit. If no valid starting station exists, return `-1`.

If a solution exists, it is **guaranteed** to be unique.

**Example 1:**
```
Input: gas = [1,2,3,4,5], cost = [3,4,5,1,2]
Output: 3
```

**Example 2:**
```
Input: gas = [2,3,4], cost = [3,4,3]
Output: -1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gas-station')
  AND locale = 'en';

------------------------------------------------------------
-- insert-interval (Gap Insertion / Insert Interval)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an array of non-overlapping intervals `intervals` where `intervals[i] = [start, end]`, sorted in ascending order by `start`.

You are also given a new interval `newInterval = [start, end]`. Insert `newInterval` into `intervals` so that the array remains sorted and non-overlapping. Merge any overlapping intervals as needed.

Return the updated array of intervals after the insertion.

**Example 1:**
```
Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
Output: [[1,5],[6,9]]
```

**Example 2:**
```
Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
Output: [[1,2],[3,10],[12,16]]
```'
WHERE slug = 'insert-interval';

UPDATE problem_translations
SET description = 'You are given an array of non-overlapping intervals `intervals` where `intervals[i] = [start, end]`, sorted in ascending order by `start`.

You are also given a new interval `newInterval = [start, end]`. Insert `newInterval` into `intervals` so that the array remains sorted and non-overlapping. Merge any overlapping intervals as needed.

Return the updated array of intervals after the insertion.

**Example 1:**
```
Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
Output: [[1,5],[6,9]]
```

**Example 2:**
```
Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
Output: [[1,2],[3,10],[12,16]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'insert-interval')
  AND locale = 'en';

------------------------------------------------------------
-- non-overlapping (Overlap Remover / Non-overlapping Intervals)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of intervals `intervals` where `intervals[i] = [start, end]`, return the **minimum number of intervals you need to remove** so that the remaining intervals do not overlap.

Two intervals `[a, b]` and `[c, d]` are considered non-overlapping if `b <= c` or `d <= a`.

**Example 1:**
```
Input: intervals = [[1,2],[2,3],[3,4],[1,3]]
Output: 1
Explanation: Removing [1,3] makes the remaining intervals non-overlapping.
```

**Example 2:**
```
Input: intervals = [[1,2],[1,2],[1,2]]
Output: 2
Explanation: You need to remove two of the three [1,2] intervals to eliminate all overlaps.
```

**Example 3:**
```
Input: intervals = [[1,2],[2,3]]
Output: 0
Explanation: The intervals are already non-overlapping, so no removal is needed.
```'
WHERE slug = 'non-overlapping';

UPDATE problem_translations
SET description = 'Given an array of intervals `intervals` where `intervals[i] = [start, end]`, return the **minimum number of intervals you need to remove** so that the remaining intervals do not overlap.

Two intervals `[a, b]` and `[c, d]` are considered non-overlapping if `b <= c` or `d <= a`.

**Example 1:**
```
Input: intervals = [[1,2],[2,3],[3,4],[1,3]]
Output: 1
Explanation: Removing [1,3] makes the remaining intervals non-overlapping.
```

**Example 2:**
```
Input: intervals = [[1,2],[1,2],[1,2]]
Output: 2
Explanation: You need to remove two of the three [1,2] intervals to eliminate all overlaps.
```

**Example 3:**
```
Input: intervals = [[1,2],[2,3]]
Output: 0
Explanation: The intervals are already non-overlapping, so no removal is needed.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'non-overlapping')
  AND locale = 'en';

------------------------------------------------------------
-- meeting-rooms (Room Scheduler / Meeting Rooms)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of meeting time intervals `intervals` where `intervals[i] = [start, end]`, return the **minimum number of conference rooms** required to hold all meetings.

Meetings may overlap in time, and each overlapping meeting needs its own room. A room becomes available as soon as its current meeting ends.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
Explanation: The meeting [0,30] overlaps with both [5,10] and [15,20], but [5,10] and [15,20] do not overlap with each other. Two rooms are sufficient.
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: 1
Explanation: The two meetings do not overlap, so one room is enough.
```'
WHERE slug = 'meeting-rooms';

UPDATE problem_translations
SET description = 'Given an array of meeting time intervals `intervals` where `intervals[i] = [start, end]`, return the **minimum number of conference rooms** required to hold all meetings.

Meetings may overlap in time, and each overlapping meeting needs its own room. A room becomes available as soon as its current meeting ends.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
Explanation: The meeting [0,30] overlaps with both [5,10] and [15,20], but [5,10] and [15,20] do not overlap with each other. Two rooms are sufficient.
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: 1
Explanation: The two meetings do not overlap, so one room is enough.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'meeting-rooms')
  AND locale = 'en';

------------------------------------------------------------
-- spiral-matrix (Spiral Walk / Spiral Matrix)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` matrix of integers, return all elements of the matrix in **spiral order**.

Spiral order starts at the top-left corner and proceeds right across the first row, then down the last column, then left across the bottom row, then up the first column, and continues inward following the same pattern.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]
```

**Example 2:**
```
Input: matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
Output: [1,2,3,4,8,12,11,10,9,5,6,7]
```'
WHERE slug = 'spiral-matrix';

UPDATE problem_translations
SET description = 'Given an `m x n` matrix of integers, return all elements of the matrix in **spiral order**.

Spiral order starts at the top-left corner and proceeds right across the first row, then down the last column, then left across the bottom row, then up the first column, and continues inward following the same pattern.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]
```

**Example 2:**
```
Input: matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
Output: [1,2,3,4,8,12,11,10,9,5,6,7]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spiral-matrix')
  AND locale = 'en';

------------------------------------------------------------
-- count-bits (Bit Counter / Count Bits)
------------------------------------------------------------
UPDATE problems
SET description = 'Given a positive integer `n`, return the number of **set bits** (1s) in its binary representation. This is also known as the **Hamming weight**.

**Example 1:**
```
Input: n = 11
Output: 3
Explanation: The binary representation of 11 is 1011, which has three set bits.
```

**Example 2:**
```
Input: n = 128
Output: 1
Explanation: The binary representation of 128 is 10000000, which has one set bit.
```

**Example 3:**
```
Input: n = 2147483645
Output: 30
```'
WHERE slug = 'count-bits';

UPDATE problem_translations
SET description = 'Given a positive integer `n`, return the number of **set bits** (1s) in its binary representation. This is also known as the **Hamming weight**.

**Example 1:**
```
Input: n = 11
Output: 3
Explanation: The binary representation of 11 is 1011, which has three set bits.
```

**Example 2:**
```
Input: n = 128
Output: 1
Explanation: The binary representation of 128 is 10000000, which has one set bit.
```

**Example 3:**
```
Input: n = 2147483645
Output: 30
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-bits')
  AND locale = 'en';
