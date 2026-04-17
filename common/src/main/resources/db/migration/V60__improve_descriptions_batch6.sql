-- Improve descriptions: batch 6
-- Slugs: color-sort, next-arrangement, first-missing-positive,
--         rain-collector, move-zeroes, substring-permutation,
--         window-maximum, polish-notation, parentheses-generator,
--         temperature-wait

------------------------------------------------------------
-- color-sort
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `nums` containing only the values `0`, `1`, and `2`, sort it **in-place** so that all `0`s come first, followed by all `1`s, then all `2`s.

You must solve this without using any built-in sort function.

**Example 1:**
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
Explanation: The three distinct values are grouped in ascending order.
```

**Example 2:**
```
Input: nums = [2,0,1]
Output: [0,1,2]
```

**Example 3:**
```
Input: nums = [0]
Output: [0]
```'
WHERE slug = 'color-sort';

UPDATE problem_translations
SET description = 'Given an array `nums` containing only the values `0`, `1`, and `2`, sort it **in-place** so that all `0`s come first, followed by all `1`s, then all `2`s.

You must solve this without using any built-in sort function.

**Example 1:**
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
Explanation: The three distinct values are grouped in ascending order.
```

**Example 2:**
```
Input: nums = [2,0,1]
Output: [0,1,2]
```

**Example 3:**
```
Input: nums = [0]
Output: [0]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'color-sort')
  AND locale = 'en';

------------------------------------------------------------
-- next-arrangement
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of integers `nums`, rearrange it into the **lexicographically next greater permutation** of its elements.

If no such arrangement exists (the array is sorted in descending order), rearrange it into the lowest possible order (ascending sort).

The replacement must be done **in-place** using only constant extra memory.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [1,3,2]
Explanation: The next permutation after [1,2,3] is [1,3,2].
```

**Example 2:**
```
Input: nums = [3,2,1]
Output: [1,2,3]
Explanation: No next permutation exists, so rearrange to the smallest.
```

**Example 3:**
```
Input: nums = [1,1,5]
Output: [1,5,1]
```'
WHERE slug = 'next-arrangement';

UPDATE problem_translations
SET description = 'Given an array of integers `nums`, rearrange it into the **lexicographically next greater permutation** of its elements.

If no such arrangement exists (the array is sorted in descending order), rearrange it into the lowest possible order (ascending sort).

The replacement must be done **in-place** using only constant extra memory.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [1,3,2]
Explanation: The next permutation after [1,2,3] is [1,3,2].
```

**Example 2:**
```
Input: nums = [3,2,1]
Output: [1,2,3]
Explanation: No next permutation exists, so rearrange to the smallest.
```

**Example 3:**
```
Input: nums = [1,1,5]
Output: [1,5,1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-arrangement')
  AND locale = 'en';

------------------------------------------------------------
-- first-missing-positive
------------------------------------------------------------
UPDATE problems
SET description = 'Given an unsorted integer array `nums`, return the smallest positive integer that is missing from the array.

Your solution must run in **O(n)** time and use **O(1)** auxiliary space.

**Example 1:**
```
Input: nums = [1,2,0]
Output: 3
Explanation: The values 1 and 2 are present, so the first missing positive is 3.
```

**Example 2:**
```
Input: nums = [3,4,-1,1]
Output: 2
Explanation: 1 is present but 2 is missing.
```

**Example 3:**
```
Input: nums = [7,8,9,11,12]
Output: 1
Explanation: The smallest positive integer 1 is not in the array.
```'
WHERE slug = 'first-missing-positive';

UPDATE problem_translations
SET description = 'Given an unsorted integer array `nums`, return the smallest positive integer that is missing from the array.

Your solution must run in **O(n)** time and use **O(1)** auxiliary space.

**Example 1:**
```
Input: nums = [1,2,0]
Output: 3
Explanation: The values 1 and 2 are present, so the first missing positive is 3.
```

**Example 2:**
```
Input: nums = [3,4,-1,1]
Output: 2
Explanation: 1 is present but 2 is missing.
```

**Example 3:**
```
Input: nums = [7,8,9,11,12]
Output: 1
Explanation: The smallest positive integer 1 is not in the array.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'first-missing-positive')
  AND locale = 'en';

------------------------------------------------------------
-- rain-collector
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `height` of `n` non-negative integers where each element represents the elevation of a bar with width 1, compute how much water can be trapped between the bars after raining.

Water collects in the gaps between taller bars. The amount of water above each bar is determined by the minimum of the tallest bar to its left and the tallest bar to its right, minus the bar''s own height.

**Example 1:**
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: The elevation map traps 6 units of rain water.
```

**Example 2:**
```
Input: height = [4,2,0,3,2,5]
Output: 9
```'
WHERE slug = 'rain-collector';

UPDATE problem_translations
SET description = 'Given an array `height` of `n` non-negative integers where each element represents the elevation of a bar with width 1, compute how much water can be trapped between the bars after raining.

Water collects in the gaps between taller bars. The amount of water above each bar is determined by the minimum of the tallest bar to its left and the tallest bar to its right, minus the bar''s own height.

**Example 1:**
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: The elevation map traps 6 units of rain water.
```

**Example 2:**
```
Input: height = [4,2,0,3,2,5]
Output: 9
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rain-collector')
  AND locale = 'en';

------------------------------------------------------------
-- move-zeroes
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, move all `0`s to the end while maintaining the relative order of the non-zero elements.

You must modify the array **in-place** without making a copy.

**Example 1:**
```
Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]
Explanation: All non-zero elements retain their original order, and all zeros are shifted to the end.
```

**Example 2:**
```
Input: nums = [0]
Output: [0]
```'
WHERE slug = 'move-zeroes';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, move all `0`s to the end while maintaining the relative order of the non-zero elements.

You must modify the array **in-place** without making a copy.

**Example 1:**
```
Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]
Explanation: All non-zero elements retain their original order, and all zeros are shifted to the end.
```

**Example 2:**
```
Input: nums = [0]
Output: [0]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'move-zeroes')
  AND locale = 'en';

------------------------------------------------------------
-- substring-permutation
------------------------------------------------------------
UPDATE problems
SET description = 'Given two strings `s1` and `s2`, return `true` if `s2` contains any permutation of `s1` as a substring, or `false` otherwise.

In other words, check whether any rearrangement of the characters in `s1` appears as a contiguous sequence within `s2`.

**Example 1:**
```
Input: s1 = "ab", s2 = "eidbaooo"
Output: true
Explanation: s2 contains "ba", which is a permutation of s1.
```

**Example 2:**
```
Input: s1 = "ab", s2 = "eidboaoo"
Output: false
Explanation: No contiguous substring of s2 is a permutation of s1.
```'
WHERE slug = 'substring-permutation';

UPDATE problem_translations
SET description = 'Given two strings `s1` and `s2`, return `true` if `s2` contains any permutation of `s1` as a substring, or `false` otherwise.

In other words, check whether any rearrangement of the characters in `s1` appears as a contiguous sequence within `s2`.

**Example 1:**
```
Input: s1 = "ab", s2 = "eidbaooo"
Output: true
Explanation: s2 contains "ba", which is a permutation of s1.
```

**Example 2:**
```
Input: s1 = "ab", s2 = "eidboaoo"
Output: false
Explanation: No contiguous substring of s2 is a permutation of s1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'substring-permutation')
  AND locale = 'en';

------------------------------------------------------------
-- window-maximum
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of integers `nums` and an integer `k`, a sliding window of size `k` moves from left to right across the array, one position at a time. At each position, you can see exactly `k` elements in the window.

Return an array containing the maximum value from each window position.

**Example 1:**
```
Input: nums = [1,3,-1,-3,5,3,6,7], k = 3
Output: [3,3,5,5,6,7]
Explanation:
Window position                Max
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```

**Example 2:**
```
Input: nums = [1], k = 1
Output: [1]
```'
WHERE slug = 'window-maximum';

UPDATE problem_translations
SET description = 'Given an array of integers `nums` and an integer `k`, a sliding window of size `k` moves from left to right across the array, one position at a time. At each position, you can see exactly `k` elements in the window.

Return an array containing the maximum value from each window position.

**Example 1:**
```
Input: nums = [1,3,-1,-3,5,3,6,7], k = 3
Output: [3,3,5,5,6,7]
Explanation:
Window position                Max
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```

**Example 2:**
```
Input: nums = [1], k = 1
Output: [1]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'window-maximum')
  AND locale = 'en';

------------------------------------------------------------
-- polish-notation
------------------------------------------------------------
UPDATE problems
SET description = 'Evaluate an arithmetic expression written in **Reverse Polish Notation** (RPN).

The valid operators are `+`, `-`, `*`, and `/`. Each operand is either an integer or a sub-expression. Division between two integers truncates toward zero.

The input is guaranteed to be a valid RPN expression that always produces a result, with no division by zero.

**Example 1:**
```
Input: tokens = ["2","1","+","3","*"]
Output: 9
Explanation: ((2 + 1) * 3) = 9
```

**Example 2:**
```
Input: tokens = ["4","13","5","/","+"]
Output: 6
Explanation: (4 + (13 / 5)) = 6
```

**Example 3:**
```
Input: tokens = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
Output: 22
Explanation: ((10 * (6 / ((9 + 3) * -11))) + 17) + 5 = 22
```'
WHERE slug = 'polish-notation';

UPDATE problem_translations
SET description = 'Evaluate an arithmetic expression written in **Reverse Polish Notation** (RPN).

The valid operators are `+`, `-`, `*`, and `/`. Each operand is either an integer or a sub-expression. Division between two integers truncates toward zero.

The input is guaranteed to be a valid RPN expression that always produces a result, with no division by zero.

**Example 1:**
```
Input: tokens = ["2","1","+","3","*"]
Output: 9
Explanation: ((2 + 1) * 3) = 9
```

**Example 2:**
```
Input: tokens = ["4","13","5","/","+"]
Output: 6
Explanation: (4 + (13 / 5)) = 6
```

**Example 3:**
```
Input: tokens = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
Output: 22
Explanation: ((10 * (6 / ((9 + 3) * -11))) + 17) + 5 = 22
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'polish-notation')
  AND locale = 'en';

------------------------------------------------------------
-- parentheses-generator
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer `n` representing the number of pairs of parentheses, return all combinations of **well-formed parentheses** that can be generated.

A combination is well-formed if every opening parenthesis `(` has a corresponding closing parenthesis `)` and they are properly nested.

**Example 1:**
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]
Explanation: All 5 valid arrangements of 3 pairs of parentheses.
```

**Example 2:**
```
Input: n = 1
Output: ["()"]
```'
WHERE slug = 'parentheses-generator';

UPDATE problem_translations
SET description = 'Given an integer `n` representing the number of pairs of parentheses, return all combinations of **well-formed parentheses** that can be generated.

A combination is well-formed if every opening parenthesis `(` has a corresponding closing parenthesis `)` and they are properly nested.

**Example 1:**
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]
Explanation: All 5 valid arrangements of 3 pairs of parentheses.
```

**Example 2:**
```
Input: n = 1
Output: ["()"]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'parentheses-generator')
  AND locale = 'en';

------------------------------------------------------------
-- temperature-wait
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of integers `temperatures` representing daily temperatures, return an array `answer` where `answer[i]` is the number of days you have to wait after day `i` to reach a warmer temperature.

If there is no future day with a higher temperature, set `answer[i]` to `0`.

**Example 1:**
```
Input: temperatures = [73,74,75,71,69,72,76,73]
Output: [1,1,4,2,1,1,0,0]
Explanation: For day 0 (73), the next warmer day is day 1 (74), so answer[0] = 1. For day 2 (75), the next warmer day is day 6 (76), so answer[2] = 4.
```

**Example 2:**
```
Input: temperatures = [30,40,50,60]
Output: [1,1,1,0]
Explanation: Each day is warmer than the previous, except the last day which has no warmer future day.
```

**Example 3:**
```
Input: temperatures = [30,60,90]
Output: [1,1,0]
```'
WHERE slug = 'temperature-wait';

UPDATE problem_translations
SET description = 'Given an array of integers `temperatures` representing daily temperatures, return an array `answer` where `answer[i]` is the number of days you have to wait after day `i` to reach a warmer temperature.

If there is no future day with a higher temperature, set `answer[i]` to `0`.

**Example 1:**
```
Input: temperatures = [73,74,75,71,69,72,76,73]
Output: [1,1,4,2,1,1,0,0]
Explanation: For day 0 (73), the next warmer day is day 1 (74), so answer[0] = 1. For day 2 (75), the next warmer day is day 6 (76), so answer[2] = 4.
```

**Example 2:**
```
Input: temperatures = [30,40,50,60]
Output: [1,1,1,0]
Explanation: Each day is warmer than the previous, except the last day which has no warmer future day.
```

**Example 3:**
```
Input: temperatures = [30,60,90]
Output: [1,1,0]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'temperature-wait')
  AND locale = 'en';
