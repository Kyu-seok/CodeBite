-- Improve descriptions: batch 2

------------------------------------------------------------
-- sorted-pair-sum
------------------------------------------------------------
UPDATE problems
SET description = 'Given a **1-indexed** array of integers `numbers` that is already sorted in non-decreasing order, find two numbers that add up to a specific `target` number.

Return the indices of the two numbers as an integer array `[index1, index2]`, where `1 <= index1 < index2 <= numbers.length`.

There is exactly one solution for each input. You may not use the same element twice. Your solution must use only constant extra space.

**Example 1:**
```
Input: numbers = [2,7,11,15], target = 9
Output: [1,2]
Explanation: The sum of 2 and 7 is 9. Therefore, index1 = 1, index2 = 2. We return [1, 2].
```

**Example 2:**
```
Input: numbers = [2,3,4], target = 6
Output: [1,3]
```

**Example 3:**
```
Input: numbers = [-1,0], target = -1
Output: [1,2]
```'
WHERE slug = 'sorted-pair-sum';

UPDATE problem_translations
SET description = 'Given a **1-indexed** array of integers `numbers` that is already sorted in non-decreasing order, find two numbers that add up to a specific `target` number.

Return the indices of the two numbers as an integer array `[index1, index2]`, where `1 <= index1 < index2 <= numbers.length`.

There is exactly one solution for each input. You may not use the same element twice. Your solution must use only constant extra space.

**Example 1:**
```
Input: numbers = [2,7,11,15], target = 9
Output: [1,2]
Explanation: The sum of 2 and 7 is 9. Therefore, index1 = 1, index2 = 2. We return [1, 2].
```

**Example 2:**
```
Input: numbers = [2,3,4], target = 6
Output: [1,3]
```

**Example 3:**
```
Input: numbers = [-1,0], target = -1
Output: [1,2]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-pair-sum')
  AND locale = 'en';

------------------------------------------------------------
-- three-sum
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, return all unique triplets `[nums[i], nums[j], nums[k]]` such that `i`, `j`, and `k` are all distinct indices, and `nums[i] + nums[j] + nums[k] == 0`.

The result must not contain duplicate triplets. You may return the triplets in any order.

**Example 1:**
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
Explanation: nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0. nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0. The distinct triplets are [-1,0,1] and [-1,-1,2].
```

**Example 2:**
```
Input: nums = [0,1,1]
Output: []
Explanation: The only possible triplet does not sum up to 0.
```

**Example 3:**
```
Input: nums = [0,0,0]
Output: [[0,0,0]]
```'
WHERE slug = 'three-sum';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, return all unique triplets `[nums[i], nums[j], nums[k]]` such that `i`, `j`, and `k` are all distinct indices, and `nums[i] + nums[j] + nums[k] == 0`.

The result must not contain duplicate triplets. You may return the triplets in any order.

**Example 1:**
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
Explanation: nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0. nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0. The distinct triplets are [-1,0,1] and [-1,-1,2].
```

**Example 2:**
```
Input: nums = [0,1,1]
Output: []
Explanation: The only possible triplet does not sum up to 0.
```

**Example 3:**
```
Input: nums = [0,0,0]
Output: [[0,0,0]]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'three-sum')
  AND locale = 'en';

------------------------------------------------------------
-- water-container
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the `i`-th line are `(i, 0)` and `(i, height[i])`.

Find two lines that, together with the x-axis, form a container that holds the most water. Return the maximum amount of water the container can store.

Note that you may not slant the container.

**Example 1:**
```
Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49
Explanation: The lines at index 1 and index 8 form a container that can hold 49 units of water.
```

**Example 2:**
```
Input: height = [1,1]
Output: 1
```'
WHERE slug = 'water-container';

UPDATE problem_translations
SET description = 'You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the `i`-th line are `(i, 0)` and `(i, height[i])`.

Find two lines that, together with the x-axis, form a container that holds the most water. Return the maximum amount of water the container can store.

Note that you may not slant the container.

**Example 1:**
```
Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49
Explanation: The lines at index 1 and index 8 form a container that can hold 49 units of water.
```

**Example 2:**
```
Input: height = [1,1]
Output: 1
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'water-container')
  AND locale = 'en';

------------------------------------------------------------
-- stock-profit
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`-th day.

You want to maximize your profit by choosing a single day to buy one stock and a different day in the future to sell it. Return the maximum profit you can achieve from this transaction.

If no profit is possible, return `0`.

**Example 1:**
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
```

**Example 2:**
```
Input: prices = [7,6,4,3,1]
Output: 0
Explanation: In this case, no transactions are done and the max profit = 0.
```'
WHERE slug = 'stock-profit';

UPDATE problem_translations
SET description = 'You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`-th day.

You want to maximize your profit by choosing a single day to buy one stock and a different day in the future to sell it. Return the maximum profit you can achieve from this transaction.

If no profit is possible, return `0`.

**Example 1:**
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: Buy on day 2 (price = 1) and sell on day 5 (price = 6), profit = 6-1 = 5.
```

**Example 2:**
```
Input: prices = [7,6,4,3,1]
Output: 0
Explanation: In this case, no transactions are done and the max profit = 0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-profit')
  AND locale = 'en';

------------------------------------------------------------
-- unique-substring
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s`, find the length of the longest substring that contains no repeating characters.

A **substring** is a contiguous sequence of characters within the string.

**Example 1:**
```
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

**Example 2:**
```
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

**Example 3:**
```
Input: s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
```'
WHERE slug = 'unique-substring';

UPDATE problem_translations
SET description = 'Given a string `s`, find the length of the longest substring that contains no repeating characters.

A **substring** is a contiguous sequence of characters within the string.

**Example 1:**
```
Input: s = "abcabcbb"
Output: 3
Explanation: The answer is "abc", with the length of 3.
```

**Example 2:**
```
Input: s = "bbbbb"
Output: 1
Explanation: The answer is "b", with the length of 1.
```

**Example 3:**
```
Input: s = "pwwkew"
Output: 3
Explanation: The answer is "wke", with the length of 3.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-substring')
  AND locale = 'en';

------------------------------------------------------------
-- character-swap
------------------------------------------------------------
UPDATE problems
SET description = 'You are given a string `s` consisting of uppercase English letters and an integer `k`. You can pick any character in the string and replace it with any other uppercase English letter. You can perform this operation at most `k` times.

Return the length of the longest substring that contains only one distinct letter after performing at most `k` replacements.

**Example 1:**
```
Input: s = "ABAB", k = 2
Output: 4
Explanation: Replace the two ''A''s with two ''B''s or vice versa.
```

**Example 2:**
```
Input: s = "AABABBA", k = 1
Output: 4
Explanation: Replace the one ''B'' in the middle with ''A'' and form "AABAAABA". The substring "AAAA" has length 4.
```'
WHERE slug = 'character-swap';

UPDATE problem_translations
SET description = 'You are given a string `s` consisting of uppercase English letters and an integer `k`. You can pick any character in the string and replace it with any other uppercase English letter. You can perform this operation at most `k` times.

Return the length of the longest substring that contains only one distinct letter after performing at most `k` replacements.

**Example 1:**
```
Input: s = "ABAB", k = 2
Output: 4
Explanation: Replace the two ''A''s with two ''B''s or vice versa.
```

**Example 2:**
```
Input: s = "AABABBA", k = 1
Output: 4
Explanation: Replace the one ''B'' in the middle with ''A'' and form "AABAAABA". The substring "AAAA" has length 4.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'character-swap')
  AND locale = 'en';

------------------------------------------------------------
-- smallest-window
------------------------------------------------------------
UPDATE problems
SET description = 'Given two strings `s` and `t`, return the shortest substring of `s` that contains every character in `t`, including duplicates. If no such substring exists, return the empty string `""`.

Each character in `t` must appear in the window at least as many times as it appears in `t`. If there are multiple windows of the same minimum length, return the one that appears first.

**Example 1:**
```
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: The minimum window substring "BANC" includes ''A'', ''B'', and ''C'' from string t.
```

**Example 2:**
```
Input: s = "a", t = "a"
Output: "a"
```

**Example 3:**
```
Input: s = "a", t = "aa"
Output: ""
Explanation: Both ''a''s from t must be included in the window. Since the largest window of s only has one ''a'', return empty string.
```'
WHERE slug = 'smallest-window';

UPDATE problem_translations
SET description = 'Given two strings `s` and `t`, return the shortest substring of `s` that contains every character in `t`, including duplicates. If no such substring exists, return the empty string `""`.

Each character in `t` must appear in the window at least as many times as it appears in `t`. If there are multiple windows of the same minimum length, return the one that appears first.

**Example 1:**
```
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: The minimum window substring "BANC" includes ''A'', ''B'', and ''C'' from string t.
```

**Example 2:**
```
Input: s = "a", t = "a"
Output: "a"
```

**Example 3:**
```
Input: s = "a", t = "aa"
Output: ""
Explanation: Both ''a''s from t must be included in the window. Since the largest window of s only has one ''a'', return empty string.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-window')
  AND locale = 'en';

------------------------------------------------------------
-- bracket-validator
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` containing only the characters `(`, `)`, `{`, `}`, `[`, and `]`, determine if the input string is valid.

A string is valid if:
1. Every open bracket is closed by the same type of bracket.
2. Open brackets are closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

**Example 1:**
```
Input: s = "()"
Output: true
```

**Example 2:**
```
Input: s = "()[]{}"
Output: true
```

**Example 3:**
```
Input: s = "(]"
Output: false
```'
WHERE slug = 'bracket-validator';

UPDATE problem_translations
SET description = 'Given a string `s` containing only the characters `(`, `)`, `{`, `}`, `[`, and `]`, determine if the input string is valid.

A string is valid if:
1. Every open bracket is closed by the same type of bracket.
2. Open brackets are closed in the correct order.
3. Every close bracket has a corresponding open bracket of the same type.

**Example 1:**
```
Input: s = "()"
Output: true
```

**Example 2:**
```
Input: s = "()[]{}"
Output: true
```

**Example 3:**
```
Input: s = "(]"
Output: false
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bracket-validator')
  AND locale = 'en';

------------------------------------------------------------
-- minimum-stack
------------------------------------------------------------
UPDATE problems
SET description = 'Design a stack that supports push, pop, top, and retrieving the minimum element, all in constant time.

Implement the `MinStack` class with the following methods:
- `MinStack()` initializes the stack object.
- `void push(int val)` pushes the element `val` onto the stack.
- `void pop()` removes the element on the top of the stack.
- `int top()` returns the top element of the stack.
- `int getMin()` returns the minimum element in the stack.

Each method must run in `O(1)` time complexity.

**Example 1:**
```
Input:
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]
Output: [null,null,null,null,-3,null,0,-2]
```'
WHERE slug = 'minimum-stack';

UPDATE problem_translations
SET description = 'Design a stack that supports push, pop, top, and retrieving the minimum element, all in constant time.

Implement the `MinStack` class with the following methods:
- `MinStack()` initializes the stack object.
- `void push(int val)` pushes the element `val` onto the stack.
- `void pop()` removes the element on the top of the stack.
- `int top()` returns the top element of the stack.
- `int getMin()` returns the minimum element in the stack.

Each method must run in `O(1)` time complexity.

**Example 1:**
```
Input:
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]
Output: [null,null,null,null,-3,null,0,-2]
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'minimum-stack')
  AND locale = 'en';

------------------------------------------------------------
-- basic-binary-search
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of integers `nums` sorted in ascending order, and an integer `target`, return the index of `target` in the array. If `target` does not exist in the array, return `-1`.

You must write an algorithm with `O(log n)` runtime complexity.

**Example 1:**
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9 exists in nums and its index is 4.
```

**Example 2:**
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
Explanation: 2 does not exist in nums so return -1.
```'
WHERE slug = 'basic-binary-search';

UPDATE problem_translations
SET description = 'Given an array of integers `nums` sorted in ascending order, and an integer `target`, return the index of `target` in the array. If `target` does not exist in the array, return `-1`.

You must write an algorithm with `O(log n)` runtime complexity.

**Example 1:**
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9 exists in nums and its index is 4.
```

**Example 2:**
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
Explanation: 2 does not exist in nums so return -1.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'basic-binary-search')
  AND locale = 'en';
