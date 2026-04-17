-- Improve descriptions: batch 18

------------------------------------------------------------
-- longest-climb
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` matrix of integers, find the length of the **longest strictly increasing path**.

From any cell, you may move in four directions: up, down, left, or right. You can only move to an adjacent cell if its value is **strictly greater** than the current cell''s value. The path does not need to start or end at any particular position.

Return the length of the longest increasing path in the matrix.

**Example 1:**
```
Input: matrix = [[9,9,4],[6,6,8],[2,1,1]]
Output: 4
Explanation: The longest increasing path is 1 -> 2 -> 6 -> 9, which has length 4.
```

**Example 2:**
```
Input: matrix = [[3,4,5],[3,2,6],[2,2,1]]
Output: 4
Explanation: One valid longest path is 3 -> 4 -> 5 -> 6.
```

**Example 3:**
```
Input: matrix = [[1]]
Output: 1
Explanation: A single cell counts as a path of length 1.
```'
WHERE slug = 'longest-climb';

UPDATE problem_translations
SET description = 'Given an `m x n` matrix of integers, find the length of the **longest strictly increasing path**.

From any cell, you may move in four directions: up, down, left, or right. You can only move to an adjacent cell if its value is **strictly greater** than the current cell''s value. The path does not need to start or end at any particular position.

Return the length of the longest increasing path in the matrix.

**Example 1:**
```
Input: matrix = [[9,9,4],[6,6,8],[2,1,1]]
Output: 4
Explanation: The longest increasing path is 1 -> 2 -> 6 -> 9, which has length 4.
```

**Example 2:**
```
Input: matrix = [[3,4,5],[3,2,6],[2,2,1]]
Output: 4
Explanation: One valid longest path is 3 -> 4 -> 5 -> 6.
```

**Example 3:**
```
Input: matrix = [[1]]
Output: 1
Explanation: A single cell counts as a path of length 1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-climb')
  AND locale = 'en';

------------------------------------------------------------
-- hand-grouping
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `hand` representing a collection of cards and an integer `groupSize`.

Determine whether the cards can be rearranged into groups where each group contains exactly `groupSize` **consecutive** integers. Each card must belong to exactly one group.

Return `true` if such a grouping is possible, or `false` otherwise.

**Example 1:**
```
Input: hand = [1,2,3,6,2,3,4,7,8], groupSize = 3
Output: true
Explanation: The cards can be split into [1,2,3], [2,3,4], and [6,7,8].
```

**Example 2:**
```
Input: hand = [1,2,3,4,5], groupSize = 4
Output: false
Explanation: 5 cards cannot be evenly divided into groups of 4.
```

**Example 3:**
```
Input: hand = [5,1], groupSize = 1
Output: true
Explanation: Every card forms its own group of size 1.
```'
WHERE slug = 'hand-grouping';

UPDATE problem_translations
SET description = 'You are given an integer array `hand` representing a collection of cards and an integer `groupSize`.

Determine whether the cards can be rearranged into groups where each group contains exactly `groupSize` **consecutive** integers. Each card must belong to exactly one group.

Return `true` if such a grouping is possible, or `false` otherwise.

**Example 1:**
```
Input: hand = [1,2,3,6,2,3,4,7,8], groupSize = 3
Output: true
Explanation: The cards can be split into [1,2,3], [2,3,4], and [6,7,8].
```

**Example 2:**
```
Input: hand = [1,2,3,4,5], groupSize = 4
Output: false
Explanation: 5 cards cannot be evenly divided into groups of 4.
```

**Example 3:**
```
Input: hand = [5,1], groupSize = 1
Output: true
Explanation: Every card forms its own group of size 1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hand-grouping')
  AND locale = 'en';

------------------------------------------------------------
-- label-splitter
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` consisting of lowercase English letters, partition it into as many segments as possible so that each letter appears in **at most one** segment.

The segments, when concatenated in order, must reconstruct the original string `s`.

Return an array of integers representing the length of each segment.

**Example 1:**
```
Input: s = "abacbc"
Output: [6]
Explanation: Characters ''a'', ''b'', and ''c'' all overlap, so the entire string is one segment.
```

**Example 2:**
```
Input: s = "abcadefg"
Output: [4,4]
Explanation: ''a'' appears at indices 0 and 3, forcing the first segment to be "abca" (length 4). The remaining "defg" has no shared characters, forming the second segment (length 4).
```

**Example 3:**
```
Input: s = "xyz"
Output: [1,1,1]
Explanation: Each character appears only once, so every character can be its own segment.
```'
WHERE slug = 'label-splitter';

UPDATE problem_translations
SET description = 'Given a string `s` consisting of lowercase English letters, partition it into as many segments as possible so that each letter appears in **at most one** segment.

The segments, when concatenated in order, must reconstruct the original string `s`.

Return an array of integers representing the length of each segment.

**Example 1:**
```
Input: s = "abacbc"
Output: [6]
Explanation: Characters ''a'', ''b'', and ''c'' all overlap, so the entire string is one segment.
```

**Example 2:**
```
Input: s = "abcadefg"
Output: [4,4]
Explanation: ''a'' appears at indices 0 and 3, forcing the first segment to be "abca" (length 4). The remaining "defg" has no shared characters, forming the second segment (length 4).
```

**Example 3:**
```
Input: s = "xyz"
Output: [1,1,1]
Explanation: Each character appears only once, so every character can be its own segment.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-splitter')
  AND locale = 'en';

------------------------------------------------------------
-- flexible-brackets
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` containing only the characters `''(''`, `'')''`, and `''*''`, determine whether the string can represent a valid bracket sequence.

The `''*''` character is **flexible**. It can be treated as:
- An opening bracket `''(''`
- A closing bracket `'')''`
- An empty string (removed entirely)

A bracket sequence is valid if every opening bracket has a matching closing bracket in the correct order.

Return `true` if the string can be made valid, or `false` otherwise.

**Example 1:**
```
Input: s = "(*))"
Output: true
Explanation: The ''*'' can act as ''('' to balance the extra '')''.
```

**Example 2:**
```
Input: s = "(**)"
Output: true
Explanation: Both ''*'' characters can be treated as empty strings, leaving "()" which is valid.
```

**Example 3:**
```
Input: s = ")("
Output: false
Explanation: No wildcards are available to fix the ordering.
```'
WHERE slug = 'flexible-brackets';

UPDATE problem_translations
SET description = 'Given a string `s` containing only the characters `''(''`, `'')''`, and `''*''`, determine whether the string can represent a valid bracket sequence.

The `''*''` character is **flexible**. It can be treated as:
- An opening bracket `''(''`
- A closing bracket `'')''`
- An empty string (removed entirely)

A bracket sequence is valid if every opening bracket has a matching closing bracket in the correct order.

Return `true` if the string can be made valid, or `false` otherwise.

**Example 1:**
```
Input: s = "(*))"
Output: true
Explanation: The ''*'' can act as ''('' to balance the extra '')''.
```

**Example 2:**
```
Input: s = "(**)"
Output: true
Explanation: Both ''*'' characters can be treated as empty strings, leaving "()" which is valid.
```

**Example 3:**
```
Input: s = ")("
Output: false
Explanation: No wildcards are available to fix the ordering.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flexible-brackets')
  AND locale = 'en';

------------------------------------------------------------
-- triplet-former
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of `triplets`, where each triplet is an array of three integers `[a, b, c]`. You are also given a `target` triplet `[x, y, z]`.

You may select any subset of triplets and combine them by taking the **maximum** value at each position. If you select triplets `t1, t2, ..., tk`, the result is `[max(t1[0], ..., tk[0]), max(t1[1], ..., tk[1]), max(t1[2], ..., tk[2])]`.

Return `true` if it is possible to form the exact `target` triplet this way, or `false` otherwise.

A triplet can only be selected if **none** of its values exceed the corresponding value in the target. For example, `[2, 5, 3]` cannot be used when the target is `[2, 4, 5]` because `5 > 4` at position 1.

**Example 1:**
```
Input: triplets = [[2,5,3],[1,8,4],[1,7,5]], target = [2,7,5]
Output: true
Explanation: Select triplets [2,5,3] and [1,7,5]. Taking the max at each position gives [2,7,5].
```

**Example 2:**
```
Input: triplets = [[3,4,5],[4,5,6]], target = [3,2,5]
Output: false
Explanation: No combination of triplets can produce [3,2,5] because no triplet has 2 at position 1.
```

**Example 3:**
```
Input: triplets = [[2,5,3],[2,3,4],[1,2,5],[5,2,3]], target = [5,5,5]
Output: true
Explanation: Select [2,5,3] and [1,2,5] and [5,2,3]. Max at each position gives [5,5,5].
```'
WHERE slug = 'triplet-former';

UPDATE problem_translations
SET description = 'You are given a list of `triplets`, where each triplet is an array of three integers `[a, b, c]`. You are also given a `target` triplet `[x, y, z]`.

You may select any subset of triplets and combine them by taking the **maximum** value at each position. If you select triplets `t1, t2, ..., tk`, the result is `[max(t1[0], ..., tk[0]), max(t1[1], ..., tk[1]), max(t1[2], ..., tk[2])]`.

Return `true` if it is possible to form the exact `target` triplet this way, or `false` otherwise.

A triplet can only be selected if **none** of its values exceed the corresponding value in the target. For example, `[2, 5, 3]` cannot be used when the target is `[2, 4, 5]` because `5 > 4` at position 1.

**Example 1:**
```
Input: triplets = [[2,5,3],[1,8,4],[1,7,5]], target = [2,7,5]
Output: true
Explanation: Select triplets [2,5,3] and [1,7,5]. Taking the max at each position gives [2,7,5].
```

**Example 2:**
```
Input: triplets = [[3,4,5],[4,5,6]], target = [3,2,5]
Output: false
Explanation: No combination of triplets can produce [3,2,5] because no triplet has 2 at position 1.
```

**Example 3:**
```
Input: triplets = [[2,5,3],[2,3,4],[1,2,5],[5,2,3]], target = [5,5,5]
Output: true
Explanation: Select [2,5,3] and [1,2,5] and [5,2,3]. Max at each position gives [5,5,5].
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triplet-former')
  AND locale = 'en';

------------------------------------------------------------
-- height-queue
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of `people`, where each person is represented by a pair `[h, k]`:

- `h` is the person''s height.
- `k` is the number of people **in front** of this person who have a height **greater than or equal to** `h`.

The people are given in no particular order. Reconstruct and return the queue such that every person''s `k` value is correctly satisfied.

A valid arrangement is guaranteed to exist.

**Example 1:**
```
Input: people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
Output: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]
```

**Example 2:**
```
Input: people = [[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]
Output: [[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]
```

**Example 3:**
```
Input: people = [[3,0],[3,1]]
Output: [[3,0],[3,1]]
```'
WHERE slug = 'height-queue';

UPDATE problem_translations
SET description = 'You are given a list of `people`, where each person is represented by a pair `[h, k]`:

- `h` is the person''s height.
- `k` is the number of people **in front** of this person who have a height **greater than or equal to** `h`.

The people are given in no particular order. Reconstruct and return the queue such that every person''s `k` value is correctly satisfied.

A valid arrangement is guaranteed to exist.

**Example 1:**
```
Input: people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
Output: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]
```

**Example 2:**
```
Input: people = [[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]
Output: [[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]
```

**Example 3:**
```
Input: people = [[3,0],[3,1]]
Output: [[3,0],[3,1]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-queue')
  AND locale = 'en';

------------------------------------------------------------
-- almost-sorted
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, determine whether it is possible to make the array **non-decreasing** by modifying **at most one** element.

An array is non-decreasing if `nums[i] <= nums[i + 1]` for every valid index `i` where `0 <= i < nums.length - 1`.

Return `true` if the array can be made non-decreasing with at most one change, or `false` otherwise.

**Example 1:**
```
Input: nums = [4,2,3]
Output: true
Explanation: Changing 4 to 1 results in [1,2,3], which is non-decreasing.
```

**Example 2:**
```
Input: nums = [4,2,1]
Output: false
Explanation: No single change can make this array non-decreasing.
```

**Example 3:**
```
Input: nums = [3,4,2,3]
Output: false
```'
WHERE slug = 'almost-sorted';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, determine whether it is possible to make the array **non-decreasing** by modifying **at most one** element.

An array is non-decreasing if `nums[i] <= nums[i + 1]` for every valid index `i` where `0 <= i < nums.length - 1`.

Return `true` if the array can be made non-decreasing with at most one change, or `false` otherwise.

**Example 1:**
```
Input: nums = [4,2,3]
Output: true
Explanation: Changing 4 to 1 results in [1,2,3], which is non-decreasing.
```

**Example 2:**
```
Input: nums = [4,2,1]
Output: false
Explanation: No single change can make this array non-decreasing.
```

**Example 3:**
```
Input: nums = [3,4,2,3]
Output: false
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'almost-sorted')
  AND locale = 'en';

------------------------------------------------------------
-- room-checker
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of time intervals `intervals` where each interval is a pair `[start, end]` representing a scheduled booking, determine whether all bookings can be attended without any overlap.

Two bookings conflict if one starts before the other ends. Bookings that share an endpoint (one ends exactly when the other starts) do **not** conflict.

Return `true` if no bookings overlap, or `false` otherwise.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: false
Explanation: The booking [0,30] overlaps with both [5,10] and [15,20].
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: true
```

**Example 3:**
```
Input: intervals = [[1,5],[5,10],[10,15]]
Output: true
Explanation: Bookings that start exactly when another ends do not conflict.
```'
WHERE slug = 'room-checker';

UPDATE problem_translations
SET description = 'Given an array of time intervals `intervals` where each interval is a pair `[start, end]` representing a scheduled booking, determine whether all bookings can be attended without any overlap.

Two bookings conflict if one starts before the other ends. Bookings that share an endpoint (one ends exactly when the other starts) do **not** conflict.

Return `true` if no bookings overlap, or `false` otherwise.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: false
Explanation: The booking [0,30] overlaps with both [5,10] and [15,20].
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: true
```

**Example 3:**
```
Input: intervals = [[1,5],[5,10],[10,15]]
Output: true
Explanation: Bookings that start exactly when another ends do not conflict.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-checker')
  AND locale = 'en';

------------------------------------------------------------
-- query-intervals
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a 2D integer array `intervals` where each element `[start, end]` represents an **inclusive** interval, and an integer array `queries` where each value is a point on the number line.

For each query, find the **size** of the smallest interval that contains that point. The size of an interval `[start, end]` is `end - start + 1`. If no interval contains the query point, the answer is `-1`.

Return an array where the `i`-th element is the answer for `queries[i]`.

**Example 1:**
```
Input: intervals = [[1,4],[2,4],[3,6],[2,8]], queries = [2,3,4,5]
Output: [3,3,3,4]
Explanation: For query 2, intervals [1,4] (size 4), [2,4] (size 3), and [2,8] (size 7) all contain it. The smallest is [2,4] with size 3. For query 5, only [3,6] (size 4) and [2,8] (size 7) contain it. The smallest is size 4.
```

**Example 2:**
```
Input: intervals = [[2,3],[2,5],[1,8],[20,25]], queries = [2,19,5,22]
Output: [2,-1,4,6]
Explanation: For query 19, no interval contains it, so the answer is -1. For query 22, only [20,25] (size 6) contains it.
```

**Example 3:**
```
Input: intervals = [[1,1]], queries = [1,2]
Output: [1,-1]
Explanation: The only interval [1,1] has size 1 and contains query 1, but not query 2.
```'
WHERE slug = 'query-intervals';

UPDATE problem_translations
SET description = 'You are given a 2D integer array `intervals` where each element `[start, end]` represents an **inclusive** interval, and an integer array `queries` where each value is a point on the number line.

For each query, find the **size** of the smallest interval that contains that point. The size of an interval `[start, end]` is `end - start + 1`. If no interval contains the query point, the answer is `-1`.

Return an array where the `i`-th element is the answer for `queries[i]`.

**Example 1:**
```
Input: intervals = [[1,4],[2,4],[3,6],[2,8]], queries = [2,3,4,5]
Output: [3,3,3,4]
Explanation: For query 2, intervals [1,4] (size 4), [2,4] (size 3), and [2,8] (size 7) all contain it. The smallest is [2,4] with size 3. For query 5, only [3,6] (size 4) and [2,8] (size 7) contain it. The smallest is size 4.
```

**Example 2:**
```
Input: intervals = [[2,3],[2,5],[1,8],[20,25]], queries = [2,19,5,22]
Output: [2,-1,4,6]
Explanation: For query 19, no interval contains it, so the answer is -1. For query 22, only [20,25] (size 6) contains it.
```

**Example 3:**
```
Input: intervals = [[1,1]], queries = [1,2]
Output: [1,-1]
Explanation: The only interval [1,1] has size 1 and contains query 1, but not query 2.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'query-intervals')
  AND locale = 'en';

------------------------------------------------------------
-- arrow-shooter
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a list of `targets` floating in 2D space. Each target is represented as a horizontal segment `[start, end]`, spanning from x-coordinate `start` to `end` (inclusive on both sides).

You can shoot vertical arrows upward from the x-axis. An arrow fired at position `x` destroys every target where `start <= x <= end`.

Return the **minimum** number of arrows needed to destroy all targets.

**Example 1:**
```
Input: targets = [[10,16],[2,8],[1,6],[7,12]]
Output: 2
Explanation: One way is to shoot at x = 6 (hits [2,8] and [1,6]) and at x = 11 (hits [10,16] and [7,12]).
```

**Example 2:**
```
Input: targets = [[1,2],[3,4],[5,6],[7,8]]
Output: 4
Explanation: No two targets overlap, so each requires its own arrow.
```

**Example 3:**
```
Input: targets = [[1,2],[2,3],[3,4],[4,5]]
Output: 2
Explanation: Shoot at x = 2 (hits [1,2] and [2,3]) and at x = 4 (hits [3,4] and [4,5]).
```'
WHERE slug = 'arrow-shooter';

UPDATE problem_translations
SET description = 'You are given a list of `targets` floating in 2D space. Each target is represented as a horizontal segment `[start, end]`, spanning from x-coordinate `start` to `end` (inclusive on both sides).

You can shoot vertical arrows upward from the x-axis. An arrow fired at position `x` destroys every target where `start <= x <= end`.

Return the **minimum** number of arrows needed to destroy all targets.

**Example 1:**
```
Input: targets = [[10,16],[2,8],[1,6],[7,12]]
Output: 2
Explanation: One way is to shoot at x = 6 (hits [2,8] and [1,6]) and at x = 11 (hits [10,16] and [7,12]).
```

**Example 2:**
```
Input: targets = [[1,2],[3,4],[5,6],[7,8]]
Output: 4
Explanation: No two targets overlap, so each requires its own arrow.
```

**Example 3:**
```
Input: targets = [[1,2],[2,3],[3,4],[4,5]]
Output: 2
Explanation: Shoot at x = 2 (hits [1,2] and [2,3]) and at x = 4 (hits [3,4] and [4,5]).
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'arrow-shooter')
  AND locale = 'en';
