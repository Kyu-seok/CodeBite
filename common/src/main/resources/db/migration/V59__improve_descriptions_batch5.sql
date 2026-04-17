-- Improve descriptions: batch 5
-- Slugs: house-thief, coin-picker, longest-ascending, word-segmentation,
--         largest-subarray, reach-the-end, overlap-merge, rotate-grid,
--         lone-element, kth-largest-stream

------------------------------------------------------------
-- house-thief
------------------------------------------------------------
UPDATE problems
SET description = 'You are a thief planning to rob houses along a street. Each house has a certain amount of money stashed. However, adjacent houses have linked security systems -- if two adjacent houses are broken into on the same night, the police will be alerted.

Given an integer array `nums` where `nums[i]` represents the amount of money in the `i`th house, return the maximum amount of money you can rob tonight without triggering the alarm.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3). Total = 1 + 3 = 4.
```

**Example 2:**
```
Input: nums = [2,7,9,3,1]
Output: 12
Explanation: Rob house 1 (money = 2), rob house 3 (money = 9) and rob house 5 (money = 1). Total = 2 + 9 + 1 = 12.
```'
WHERE slug = 'house-thief';

UPDATE problem_translations
SET description = 'You are a thief planning to rob houses along a street. Each house has a certain amount of money stashed. However, adjacent houses have linked security systems -- if two adjacent houses are broken into on the same night, the police will be alerted.

Given an integer array `nums` where `nums[i]` represents the amount of money in the `i`th house, return the maximum amount of money you can rob tonight without triggering the alarm.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3). Total = 1 + 3 = 4.
```

**Example 2:**
```
Input: nums = [2,7,9,3,1]
Output: 12
Explanation: Rob house 1 (money = 2), rob house 3 (money = 9) and rob house 5 (money = 1). Total = 2 + 9 + 1 = 12.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief')
  AND locale = 'en';

------------------------------------------------------------
-- coin-picker
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `coins` representing coin denominations and an integer `amount` representing a target sum.

Return the fewest number of coins needed to make up that amount. If the amount cannot be made up by any combination of the given coins, return `-1`.

You may use each coin denomination an unlimited number of times.

**Example 1:**
```
Input: coins = [1,5,10], amount = 12
Output: 3
Explanation: 12 = 10 + 1 + 1
```

**Example 2:**
```
Input: coins = [2], amount = 3
Output: -1
Explanation: There is no way to make 3 using only coins of value 2.
```

**Example 3:**
```
Input: coins = [1], amount = 0
Output: 0
Explanation: No coins are needed to make an amount of 0.
```'
WHERE slug = 'coin-picker';

UPDATE problem_translations
SET description = 'You are given an integer array `coins` representing coin denominations and an integer `amount` representing a target sum.

Return the fewest number of coins needed to make up that amount. If the amount cannot be made up by any combination of the given coins, return `-1`.

You may use each coin denomination an unlimited number of times.

**Example 1:**
```
Input: coins = [1,5,10], amount = 12
Output: 3
Explanation: 12 = 10 + 1 + 1
```

**Example 2:**
```
Input: coins = [2], amount = 3
Output: -1
Explanation: There is no way to make 3 using only coins of value 2.
```

**Example 3:**
```
Input: coins = [1], amount = 0
Output: 0
Explanation: No coins are needed to make an amount of 0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'coin-picker')
  AND locale = 'en';

------------------------------------------------------------
-- longest-ascending
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, return the length of the longest strictly increasing **subsequence**.

A **subsequence** is a sequence derived from the array by deleting zero or more elements without changing the order of the remaining elements. For example, `[3,6,7]` is a subsequence of `[0,3,1,6,2,7]`.

**Example 1:**
```
Input: nums = [10,9,2,5,3,7,101,18]
Output: 4
Explanation: The longest increasing subsequence is [2,3,7,101], therefore the length is 4.
```

**Example 2:**
```
Input: nums = [0,1,0,3,2,3]
Output: 4
```

**Example 3:**
```
Input: nums = [7,7,7,7,7,7,7]
Output: 1
Explanation: Every element is the same, so the longest strictly increasing subsequence has length 1.
```'
WHERE slug = 'longest-ascending';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, return the length of the longest strictly increasing **subsequence**.

A **subsequence** is a sequence derived from the array by deleting zero or more elements without changing the order of the remaining elements. For example, `[3,6,7]` is a subsequence of `[0,3,1,6,2,7]`.

**Example 1:**
```
Input: nums = [10,9,2,5,3,7,101,18]
Output: 4
Explanation: The longest increasing subsequence is [2,3,7,101], therefore the length is 4.
```

**Example 2:**
```
Input: nums = [0,1,0,3,2,3]
Output: 4
```

**Example 3:**
```
Input: nums = [7,7,7,7,7,7,7]
Output: 1
Explanation: Every element is the same, so the longest strictly increasing subsequence has length 1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-ascending')
  AND locale = 'en';

------------------------------------------------------------
-- word-segmentation
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` and a list of strings `wordDict` (the dictionary), return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

The same dictionary word may be reused multiple times in the segmentation.

**Example 1:**
```
Input: s = "codebite", wordDict = ["code","bite"]
Output: true
Explanation: "codebite" can be segmented as "code bite".
```

**Example 2:**
```
Input: s = "applepenapple", wordDict = ["apple","pen"]
Output: true
Explanation: "applepenapple" can be segmented as "apple pen apple". The word "apple" is reused.
```

**Example 3:**
```
Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
Output: false
Explanation: No valid segmentation exists for "catsandog" using the given dictionary.
```'
WHERE slug = 'word-segmentation';

UPDATE problem_translations
SET description = 'Given a string `s` and a list of strings `wordDict` (the dictionary), return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

The same dictionary word may be reused multiple times in the segmentation.

**Example 1:**
```
Input: s = "codebite", wordDict = ["code","bite"]
Output: true
Explanation: "codebite" can be segmented as "code bite".
```

**Example 2:**
```
Input: s = "applepenapple", wordDict = ["apple","pen"]
Output: true
Explanation: "applepenapple" can be segmented as "apple pen apple". The word "apple" is reused.
```

**Example 3:**
```
Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
Output: false
Explanation: No valid segmentation exists for "catsandog" using the given dictionary.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-segmentation')
  AND locale = 'en';

------------------------------------------------------------
-- largest-subarray
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, find the contiguous subarray with the largest sum and return that sum.

A **subarray** is a contiguous non-empty sequence of elements within the array.

**Example 1:**
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: The subarray [4,-1,2,1] has the largest sum 6.
```

**Example 2:**
```
Input: nums = [1]
Output: 1
Explanation: The subarray [1] has the largest sum 1.
```

**Example 3:**
```
Input: nums = [5,4,-1,7,8]
Output: 23
Explanation: The subarray [5,4,-1,7,8] has the largest sum 23.
```'
WHERE slug = 'largest-subarray';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, find the contiguous subarray with the largest sum and return that sum.

A **subarray** is a contiguous non-empty sequence of elements within the array.

**Example 1:**
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: The subarray [4,-1,2,1] has the largest sum 6.
```

**Example 2:**
```
Input: nums = [1]
Output: 1
Explanation: The subarray [1] has the largest sum 1.
```

**Example 3:**
```
Input: nums = [5,4,-1,7,8]
Output: 23
Explanation: The subarray [5,4,-1,7,8] has the largest sum 23.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-subarray')
  AND locale = 'en';

------------------------------------------------------------
-- reach-the-end
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `nums`. You start at the first index, and each element `nums[i]` represents the maximum number of positions you can jump forward from index `i`.

Return `true` if you can reach the last index, or `false` otherwise.

**Example 1:**
```
Input: nums = [2,3,1,1,4]
Output: true
Explanation: Jump 1 step from index 0 to 1, then 3 steps to the last index.
```

**Example 2:**
```
Input: nums = [3,2,1,0,4]
Output: false
Explanation: You will always arrive at index 3 no matter what. Its maximum jump length is 0, which makes it impossible to reach the last index.
```'
WHERE slug = 'reach-the-end';

UPDATE problem_translations
SET description = 'You are given an integer array `nums`. You start at the first index, and each element `nums[i]` represents the maximum number of positions you can jump forward from index `i`.

Return `true` if you can reach the last index, or `false` otherwise.

**Example 1:**
```
Input: nums = [2,3,1,1,4]
Output: true
Explanation: Jump 1 step from index 0 to 1, then 3 steps to the last index.
```

**Example 2:**
```
Input: nums = [3,2,1,0,4]
Output: false
Explanation: You will always arrive at index 3 no matter what. Its maximum jump length is 0, which makes it impossible to reach the last index.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reach-the-end')
  AND locale = 'en';

------------------------------------------------------------
-- overlap-merge
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of `intervals` where `intervals[i] = [start_i, end_i]`, merge all overlapping intervals and return an array of the non-overlapping intervals that cover all the intervals in the input.

Two intervals overlap if they share any point in common. For example, `[1,3]` and `[2,6]` overlap, but `[1,2]` and `[3,4]` do not.

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
```'
WHERE slug = 'overlap-merge';

UPDATE problem_translations
SET description = 'Given an array of `intervals` where `intervals[i] = [start_i, end_i]`, merge all overlapping intervals and return an array of the non-overlapping intervals that cover all the intervals in the input.

Two intervals overlap if they share any point in common. For example, `[1,3]` and `[2,6]` overlap, but `[1,2]` and `[3,4]` do not.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'overlap-merge')
  AND locale = 'en';

------------------------------------------------------------
-- rotate-grid
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an `n x n` 2D `matrix` representing an image. Rotate the image by 90 degrees clockwise.

You must rotate the image **in-place**, meaning you must modify the input matrix directly. Do not allocate a separate 2D matrix for the rotation.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**Example 2:**
```
Input: matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
Output: [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```'
WHERE slug = 'rotate-grid';

UPDATE problem_translations
SET description = 'You are given an `n x n` 2D `matrix` representing an image. Rotate the image by 90 degrees clockwise.

You must rotate the image **in-place**, meaning you must modify the input matrix directly. Do not allocate a separate 2D matrix for the rotation.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**Example 2:**
```
Input: matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
Output: [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotate-grid')
  AND locale = 'en';

------------------------------------------------------------
-- lone-element
------------------------------------------------------------
UPDATE problems
SET description = 'Given a non-empty array of integers `nums`, every element appears exactly twice except for one. Find and return that single element.

You must implement a solution with O(n) time complexity and O(1) extra space.

**Example 1:**
```
Input: nums = [2,2,1]
Output: 1
```

**Example 2:**
```
Input: nums = [4,1,2,1,2]
Output: 4
Explanation: Elements 1 and 2 each appear twice. The element 4 appears only once.
```

**Example 3:**
```
Input: nums = [1]
Output: 1
```'
WHERE slug = 'lone-element';

UPDATE problem_translations
SET description = 'Given a non-empty array of integers `nums`, every element appears exactly twice except for one. Find and return that single element.

You must implement a solution with O(n) time complexity and O(1) extra space.

**Example 1:**
```
Input: nums = [2,2,1]
Output: 1
```

**Example 2:**
```
Input: nums = [4,1,2,1,2]
Output: 4
Explanation: Elements 1 and 2 each appear twice. The element 4 appears only once.
```

**Example 3:**
```
Input: nums = [1]
Output: 1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lone-element')
  AND locale = 'en';

------------------------------------------------------------
-- kth-largest-stream
------------------------------------------------------------
UPDATE problems
SET description = 'Design a class that finds the `k`th largest element in a stream of integers. Note that this is the `k`th largest element in sorted order, not the `k`th distinct element.

Implement the `KthLargest` class:

- `KthLargest(int k, int[] nums)` -- Initializes the object with the integer `k` and an initial stream of integers `nums`.
- `int add(int val)` -- Appends the integer `val` to the stream and returns the `k`th largest element in the stream so far.

**Example 1:**
```
Input:
["KthLargest", "add", "add", "add", "add", "add"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);
kthLargest.add(3);   // return 4
kthLargest.add(5);   // return 5
kthLargest.add(10);  // return 5
kthLargest.add(9);   // return 8
kthLargest.add(4);   // return 8
```'
WHERE slug = 'kth-largest-stream';

UPDATE problem_translations
SET description = 'Design a class that finds the `k`th largest element in a stream of integers. Note that this is the `k`th largest element in sorted order, not the `k`th distinct element.

Implement the `KthLargest` class:

- `KthLargest(int k, int[] nums)` -- Initializes the object with the integer `k` and an initial stream of integers `nums`.
- `int add(int val)` -- Appends the integer `val` to the stream and returns the `k`th largest element in the stream so far.

**Example 1:**
```
Input:
["KthLargest", "add", "add", "add", "add", "add"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);
kthLargest.add(3);   // return 4
kthLargest.add(5);   // return 5
kthLargest.add(10);  // return 5
kthLargest.add(9);   // return 8
kthLargest.add(4);   // return 8
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-largest-stream')
  AND locale = 'en';
