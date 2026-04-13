-- Phase 2 Batch 1: Add 10 new problems with CodeBite original names
-- All problems use original names/descriptions distinct from any third-party source.

------------------------------------------------------------
-- ARRAYS & HASHING
------------------------------------------------------------

-- Color Sort (Dutch National Flag)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Color Sort',
    'color-sort',
    'Given an array `nums` containing only `0`s, `1`s, and `2`s, sort it **in-place** so that elements of the same value are adjacent, in the order `0`, `1`, `2`.

You must solve this problem without using the library''s sort function.

**Example 1:**
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
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
```',
    'MEDIUM',
    '1 <= nums.length <= 300
nums[i] is 0, 1, or 2',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[2,0,2,1,1,0]', '[0,0,1,1,2,2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[2,0,1]', '[0,1,2]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[0]', '[0]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[1,2,0,1,2,0]', '[0,0,1,1,2,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[2,2,2,1,1,0,0,0]', '[0,0,0,1,1,2,2,2]', FALSE, 5);

-- Next Arrangement (Next Permutation)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Next Arrangement',
    'next-arrangement',
    'Rearrange an array of integers `nums` into the lexicographically next greater permutation. If no such arrangement exists (i.e., the array is sorted in descending order), rearrange it to the lowest possible order (sorted ascending). The replacement must be **in-place** and use only constant extra memory.

**Example 1:**
```
Input: nums = [1,2,3]
Output: [1,3,2]
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
```',
    'MEDIUM',
    '1 <= nums.length <= 100
0 <= nums[i] <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1,2,3]', '[1,3,2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[3,2,1]', '[1,2,3]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1,1,5]', '[1,5,1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1]', '[1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1,3,2]', '[2,1,3]', FALSE, 5);

-- First Missing Positive
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'First Missing Positive',
    'first-missing-positive',
    'Given an unsorted integer array `nums`, return the smallest missing positive integer.

You must implement an algorithm that runs in **O(n)** time and uses **O(1)** auxiliary space.

**Example 1:**
```
Input: nums = [1,2,0]
Output: 3
Explanation: The numbers 1 and 2 are present, so the smallest missing positive is 3.
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
Explanation: The smallest positive integer 1 is missing.
```',
    'HARD',
    '1 <= nums.length <= 10^5
-2^31 <= nums[i] <= 2^31 - 1',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[1,2,0]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[3,4,-1,1]', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[7,8,9,11,12]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[1]', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[1,2,3,4,5]', '6', FALSE, 5);

------------------------------------------------------------
-- TWO POINTERS
------------------------------------------------------------

-- Rain Collector (Trapping Rain Water)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Rain Collector',
    'rain-collector',
    'Given `n` non-negative integers representing an elevation map where the width of each bar is 1, compute how much water it can trap after raining.

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
```',
    'HARD',
    'n == height.length
1 <= n <= 2 * 10^4
0 <= height[i] <= 10^5',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[0,1,0,2,1,0,1,3,2,1,2,1]', '6', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[4,2,0,3,2,5]', '9', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[0]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[3,0,3]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[5,4,1,2]', '1', FALSE, 5);

-- Move Zeroes
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Move Zeroes',
    'move-zeroes',
    'Given an integer array `nums`, move all `0`s to the end of it while maintaining the relative order of the non-zero elements.

You must modify the array **in-place** without making a copy.

**Example 1:**
```
Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]
```

**Example 2:**
```
Input: nums = [0]
Output: [0]
```',
    'EASY',
    '1 <= nums.length <= 10^4
-2^31 <= nums[i] <= 2^31 - 1',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[0,1,0,3,12]', '[1,3,12,0,0]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[0]', '[0]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[1,0,0,0,2]', '[1,2,0,0,0]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[4,2,4,0,0,3,0,5,1,0]', '[4,2,4,3,5,1,0,0,0,0]', FALSE, 4);

------------------------------------------------------------
-- SLIDING WINDOW
------------------------------------------------------------

-- Substring Permutation (Permutation in String)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Substring Permutation',
    'substring-permutation',
    'Given two strings `s1` and `s2`, return `true` if `s2` contains a permutation of `s1`, or `false` otherwise.

In other words, return `true` if one of `s1`''s permutations is a substring of `s2`.

**Example 1:**
```
Input: s1 = "ab", s2 = "eidbaooo"
Output: true
Explanation: s2 contains one permutation of s1 ("ba").
```

**Example 2:**
```
Input: s1 = "ab", s2 = "eidboaoo"
Output: false
```',
    'MEDIUM',
    '1 <= s1.length, s2.length <= 10^4
s1 and s2 consist of lowercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), 'ab
eidbaooo', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), 'ab
eidboaoo', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), 'adc
dcda', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), 'a
a', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), 'hello
ooolleoooleh', 'false', FALSE, 5);

-- Window Maximum (Sliding Window Maximum)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Window Maximum',
    'window-maximum',
    'You are given an array of integers `nums` and a sliding window of size `k` which moves from the very left of the array to the very right. You can only see the `k` numbers in the window. Each time the sliding window moves right by one position, return the maximum value in the window.

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
```',
    'HARD',
    '1 <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4
1 <= k <= nums.length',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), '[1,3,-1,-3,5,3,6,7]
3', '[3,3,5,5,6,7]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), '[1]
1', '[1]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), '[1,-1]
1', '[1,-1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), '[7,2,4]
2', '[7,4]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), '[9,10,9,-7,-4,-8,2,-6]
5', '[10,10,9,2]', FALSE, 5);

------------------------------------------------------------
-- STACK
------------------------------------------------------------

-- Polish Notation (Reverse Polish Notation)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Polish Notation',
    'polish-notation',
    'Evaluate the value of an arithmetic expression in **Reverse Polish Notation**.

Valid operators are `+`, `-`, `*`, and `/`. Each operand may be an integer or another expression. Note that division between two integers should truncate toward zero.

It is guaranteed that the given RPN expression is always valid. That means the expression would always evaluate to a result, and there will not be any division by zero operation.

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
```',
    'MEDIUM',
    '1 <= tokens.length <= 10^4
tokens[i] is an operator (+, -, *, /) or an integer in the range [-200, 200].',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["2","1","+","3","*"]', '9', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["4","13","5","/","+"]', '6', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["10","6","9","3","+","-11","*","/","*","17","+","5","+"]', '22', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["3"]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["5","2","-"]', '3', FALSE, 5);

-- Parentheses Generator (Generate Parentheses)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Parentheses Generator',
    'parentheses-generator',
    'Given `n` pairs of parentheses, write a function to generate all combinations of well-formed parentheses.

**Example 1:**
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]
```

**Example 2:**
```
Input: n = 1
Output: ["()"]
```',
    'MEDIUM',
    '1 <= n <= 8',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '3', '["((()))","(()())","(())()","()(())","()()()"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '1', '["()"]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '2', '["(())","()()"]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '4', '["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]', FALSE, 4);

-- Temperature Wait (Daily Temperatures)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Temperature Wait',
    'temperature-wait',
    'Given an array of integers `temperatures` representing the daily temperature, return an array `answer` such that `answer[i]` is the number of days you have to wait after the `i`-th day to get a warmer temperature. If there is no future day for which this is possible, keep `answer[i] == 0` instead.

**Example 1:**
```
Input: temperatures = [73,74,75,71,69,72,76,73]
Output: [1,1,4,2,1,1,0,0]
```

**Example 2:**
```
Input: temperatures = [30,40,50,60]
Output: [1,1,1,0]
```

**Example 3:**
```
Input: temperatures = [30,60,90]
Output: [1,1,0]
```',
    'MEDIUM',
    '1 <= temperatures.length <= 10^5
30 <= temperatures[i] <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[73,74,75,71,69,72,76,73]', '[1,1,4,2,1,1,0,0]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[30,40,50,60]', '[1,1,1,0]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[30,60,90]', '[1,1,0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[90,80,70,60]', '[0,0,0,0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[55,55,55]', '[0,0,0]', FALSE, 5);

------------------------------------------------------------
-- ENGLISH TRANSLATIONS
------------------------------------------------------------

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'color-sort', 'next-arrangement', 'first-missing-positive',
    'rain-collector', 'move-zeroes',
    'substring-permutation', 'window-maximum',
    'polish-notation', 'parentheses-generator', 'temperature-wait'
);
