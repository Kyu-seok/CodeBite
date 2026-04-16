-- Phase 3 Batch 7: 1D DP (#154-161) + 2D DP first half (#162-166)
-- 13 problems: longest-palindrome, cheap-stairs, equal-partition, perfect-sum, nth-ugly, room-builder, break-integer, longest-chain-count, stock-cooldown, sign-assignments, string-weave, subsequence-count, pattern-matcher

------------------------------------------------------------
-- Add Longest Palindrome problem
-- CodeBite original name: Longest Palindrome (inspired by Longest Palindromic Substring, LC #5)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Longest Palindrome',
    'longest-palindrome',
    'Given a string `s`, find the length of the longest substring that reads the same forwards and backwards.

A **palindromic substring** is a contiguous sequence of characters within `s` that forms a palindrome. For example, in `"racecar"`, the entire string is a palindromic substring.

**Example 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab" is a palindromic substring of length 3. "aba" is also valid.
```

**Example 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb" is the longest palindromic substring.
```

**Example 3:**
```
Input: s = "x"
Output: 1
Explanation: Every single character is a palindrome.
```',
    'MEDIUM',
    '1 <= s.length <= 1000
s consists of only lowercase English letters',
    154,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'babad', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'cbbd', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'x', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'aacabdkacaa', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'racecar', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'aaaa', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'abcde', '1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-palindrome'),
    'en',
    'Longest Palindrome',
    'Given a string `s`, find the length of the longest substring that reads the same forwards and backwards.

A **palindromic substring** is a contiguous sequence of characters within `s` that forms a palindrome. For example, in `"racecar"`, the entire string is a palindromic substring.

**Example 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab" is a palindromic substring of length 3. "aba" is also valid.
```

**Example 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb" is the longest palindromic substring.
```

**Example 3:**
```
Input: s = "x"
Output: 1
Explanation: Every single character is a palindrome.
```',
    '1 <= s.length <= 1000
s consists of only lowercase English letters'
);

------------------------------------------------------------
-- Add Cheap Stairs problem
-- CodeBite original name: Cheap Stairs (inspired by Min Cost Climbing Stairs, LC #746)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Cheap Stairs',
    'cheap-stairs',
    'Given an integer array `cost` where `cost[i]` represents the price to step on the `i`-th stair, determine the lowest total cost to reach the top of the staircase. You may begin from either stair `0` or stair `1`. At each stair, you can advance one or two stairs forward.

The top of the staircase is the position just beyond the last element of `cost`.

**Example 1:**
```
Input: cost = [10,15,20]
Output: 15
Explanation: Start at stair 1 (cost 15), then climb two stairs to the top. Total = 15.
```

**Example 2:**
```
Input: cost = [1,100,1,1,1,100,1,1,100,1]
Output: 6
Explanation: Start at stair 0, then step on stairs 2, 3, 5 is skipped by jumping from 4 to 6, then 7 to 9. Total = 1 + 1 + 1 + 1 + 1 + 1 = 6.
```

**Example 3:**
```
Input: cost = [0,0]
Output: 0
Explanation: Start at either stair and jump to the top for free.
```',
    'EASY',
    '2 <= cost.length <= 1000
0 <= cost[i] <= 999',
    155,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[10,15,20]', '15', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[1,100,1,1,1,100,1,1,100,1]', '6', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[0,0]', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[5,5]', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[1,2,3,4,5]', '6', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[999,999,999,999]', '1998', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[0,1,0,1,0]', '0', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cheap-stairs'),
    'en',
    'Cheap Stairs',
    'Given an integer array `cost` where `cost[i]` represents the price to step on the `i`-th stair, determine the lowest total cost to reach the top of the staircase. You may begin from either stair `0` or stair `1`. At each stair, you can advance one or two stairs forward.

The top of the staircase is the position just beyond the last element of `cost`.

**Example 1:**
```
Input: cost = [10,15,20]
Output: 15
Explanation: Start at stair 1 (cost 15), then climb two stairs to the top. Total = 15.
```

**Example 2:**
```
Input: cost = [1,100,1,1,1,100,1,1,100,1]
Output: 6
Explanation: Start at stair 0, then step on stairs 2, 3, 5 is skipped by jumping from 4 to 6, then 7 to 9. Total = 1 + 1 + 1 + 1 + 1 + 1 = 6.
```

**Example 3:**
```
Input: cost = [0,0]
Output: 0
Explanation: Start at either stair and jump to the top for free.
```',
    '2 <= cost.length <= 1000
0 <= cost[i] <= 999'
);

------------------------------------------------------------
-- Add Equal Partition problem
-- CodeBite original name: Equal Partition (inspired by Partition Equal Subset Sum, LC #416)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Equal Partition',
    'equal-partition',
    'Given a non-empty array of positive integers `nums`, determine whether it can be divided into two subsets such that both subsets have the same total sum.

Return `true` if such a partition exists, or `false` otherwise.

**Example 1:**
```
Input: nums = [1,5,11,5]
Output: true
Explanation: The array can be split into [1,5,5] and [11], both summing to 11.
```

**Example 2:**
```
Input: nums = [1,2,3,5]
Output: false
Explanation: There is no way to divide the array into two equal-sum subsets.
```

**Example 3:**
```
Input: nums = [1,1]
Output: true
Explanation: Each subset contains a single 1, and both sums are equal.
```',
    'MEDIUM',
    '1 <= nums.length <= 200
1 <= nums[i] <= 100',
    156,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,5,11,5]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,2,3,5]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,1]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,2,5]', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[3,3,3,4,5]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[100]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]', 'true', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'equal-partition'),
    'en',
    'Equal Partition',
    'Given a non-empty array of positive integers `nums`, determine whether it can be divided into two subsets such that both subsets have the same total sum.

Return `true` if such a partition exists, or `false` otherwise.

**Example 1:**
```
Input: nums = [1,5,11,5]
Output: true
Explanation: The array can be split into [1,5,5] and [11], both summing to 11.
```

**Example 2:**
```
Input: nums = [1,2,3,5]
Output: false
Explanation: There is no way to divide the array into two equal-sum subsets.
```

**Example 3:**
```
Input: nums = [1,1]
Output: true
Explanation: Each subset contains a single 1, and both sums are equal.
```',
    '1 <= nums.length <= 200
1 <= nums[i] <= 100'
);

------------------------------------------------------------
-- Add Perfect Sum problem
-- CodeBite original name: Perfect Sum (inspired by Perfect Squares, LC #279)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Perfect Sum',
    'perfect-sum',
    'Given a positive integer `n`, find the fewest number of perfect square numbers (e.g., 1, 4, 9, 16, ...) that add up to `n`.

A perfect square is an integer that is the square of some other integer. For instance, 1, 4, 9, and 16 are perfect squares, while 3 and 11 are not.

**Example 1:**
```
Input: n = 12
Output: 3
Explanation: 12 = 4 + 4 + 4 (three perfect squares).
```

**Example 2:**
```
Input: n = 13
Output: 2
Explanation: 13 = 4 + 9 (two perfect squares).
```

**Example 3:**
```
Input: n = 1
Output: 1
Explanation: 1 is itself a perfect square.
```',
    'MEDIUM',
    '1 <= n <= 10000',
    157,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '12', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '13', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '1', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '7', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '100', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '99', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '48', '3', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'perfect-sum'),
    'en',
    'Perfect Sum',
    'Given a positive integer `n`, find the fewest number of perfect square numbers (e.g., 1, 4, 9, 16, ...) that add up to `n`.

A perfect square is an integer that is the square of some other integer. For instance, 1, 4, 9, and 16 are perfect squares, while 3 and 11 are not.

**Example 1:**
```
Input: n = 12
Output: 3
Explanation: 12 = 4 + 4 + 4 (three perfect squares).
```

**Example 2:**
```
Input: n = 13
Output: 2
Explanation: 13 = 4 + 9 (two perfect squares).
```

**Example 3:**
```
Input: n = 1
Output: 1
Explanation: 1 is itself a perfect square.
```',
    '1 <= n <= 10000'
);

------------------------------------------------------------
-- Add Nth Ugly problem
-- CodeBite original name: Nth Ugly (inspired by Ugly Number II, LC #264)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Nth Ugly',
    'nth-ugly',
    'An **ugly number** is a positive integer whose only prime factors are `2`, `3`, and `5`. By convention, `1` is considered the first ugly number.

Given an integer `n`, return the `n`-th ugly number in ascending order.

The sequence of ugly numbers begins: `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, ...`

**Example 1:**
```
Input: n = 10
Output: 12
Explanation: The first 10 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12.
```

**Example 2:**
```
Input: n = 1
Output: 1
Explanation: 1 is the first ugly number by definition.
```

**Example 3:**
```
Input: n = 15
Output: 24
Explanation: The first 15 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24.
```',
    'MEDIUM',
    '1 <= n <= 1690',
    158,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '10', '12', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '1', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '15', '24', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '7', '8', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '11', '15', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '100', '1536', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '1690', '2123366400', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'nth-ugly'),
    'en',
    'Nth Ugly',
    'An **ugly number** is a positive integer whose only prime factors are `2`, `3`, and `5`. By convention, `1` is considered the first ugly number.

Given an integer `n`, return the `n`-th ugly number in ascending order.

The sequence of ugly numbers begins: `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, ...`

**Example 1:**
```
Input: n = 10
Output: 12
Explanation: The first 10 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12.
```

**Example 2:**
```
Input: n = 1
Output: 1
Explanation: 1 is the first ugly number by definition.
```

**Example 3:**
```
Input: n = 15
Output: 24
Explanation: The first 15 ugly numbers are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24.
```',
    '1 <= n <= 1690'
);

------------------------------------------------------------
-- Add Room Builder problem
-- CodeBite original name: Room Builder (inspired by Count Ways to Build Rooms in an Ant Colony, LC #1916)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Room Builder',
    'room-builder',
    'You are constructing a building with `n` rooms numbered from `0` to `n - 1`. The rooms form a tree structure: each room (except room `0`) has exactly one prerequisite room that must be built before it. Room `0` is the starting point and has no prerequisite.

You are given an integer array `prevRoom` of length `n`, where `prevRoom[i]` is the room that must be completed before room `i` can be built. `prevRoom[0] = -1` since room `0` has no prerequisite.

Return the number of distinct valid construction orders in which all `n` rooms can be built. Since the answer may be very large, return it **modulo** `10^9 + 7`.

**Example 1:**
```
Input: prevRoom = [-1,0,0,1,1]
Output: 8
Explanation: Room 0 must be built first. Then rooms 1 and 2 can be built in any relative order, but rooms 3 and 4 require room 1 first. There are 8 valid orderings.
```

**Example 2:**
```
Input: prevRoom = [-1,0,1,2]
Output: 1
Explanation: The rooms form a chain 0 -> 1 -> 2 -> 3, so there is only one valid build order.
```

**Example 3:**
```
Input: prevRoom = [-1,0,0,0]
Output: 6
Explanation: Room 0 must be built first, and then the three remaining rooms can be built in any of 3! = 6 orderings.
```',
    'HARD',
    E'1 <= n <= 10^5\nprevRoom.length == n\nprevRoom[0] == -1\n0 <= prevRoom[i] < n for i >= 1\nThe input guarantees the rooms form a valid tree.',
    159,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,1,1]', '8', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,1,2]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,0]', '6', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,1,1,2,2]', '80', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,0,1,1,2,3,3]', '2240', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'room-builder'), '[-1,0,0,2,2,1,1,1,1,8,1,9,6,0,0,1,6,7,16,0]', '678300570', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'room-builder'),
    'en',
    'Room Builder',
    'You are constructing a building with `n` rooms numbered from `0` to `n - 1`. The rooms form a tree structure: each room (except room `0`) has exactly one prerequisite room that must be built before it. Room `0` is the starting point and has no prerequisite.

You are given an integer array `prevRoom` of length `n`, where `prevRoom[i]` is the room that must be completed before room `i` can be built. `prevRoom[0] = -1` since room `0` has no prerequisite.

Return the number of distinct valid construction orders in which all `n` rooms can be built. Since the answer may be very large, return it **modulo** `10^9 + 7`.

**Example 1:**
```
Input: prevRoom = [-1,0,0,1,1]
Output: 8
Explanation: Room 0 must be built first. Then rooms 1 and 2 can be built in any relative order, but rooms 3 and 4 require room 1 first. There are 8 valid orderings.
```

**Example 2:**
```
Input: prevRoom = [-1,0,1,2]
Output: 1
Explanation: The rooms form a chain 0 -> 1 -> 2 -> 3, so there is only one valid build order.
```

**Example 3:**
```
Input: prevRoom = [-1,0,0,0]
Output: 6
Explanation: Room 0 must be built first, and then the three remaining rooms can be built in any of 3! = 6 orderings.
```',
    E'1 <= n <= 10^5\nprevRoom.length == n\nprevRoom[0] == -1\n0 <= prevRoom[i] < n for i >= 1\nThe input guarantees the rooms form a valid tree.'
);

------------------------------------------------------------
-- Add Break Integer problem
-- CodeBite original name: Break Integer (inspired by Integer Break, LC #343)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Break Integer',
    'break-integer',
    'Given a positive integer `n`, split it into at least two positive integers such that their sum equals `n`, and return the maximum product you can achieve from those parts.

**Example 1:**
```
Input: n = 2
Output: 1
Explanation: 2 = 1 + 1, and 1 x 1 = 1.
```

**Example 2:**
```
Input: n = 7
Output: 12
Explanation: 7 = 3 + 4, and 3 x 4 = 12.
```

**Example 3:**
```
Input: n = 10
Output: 36
Explanation: 10 = 3 + 3 + 4, and 3 x 3 x 4 = 36.
```',
    'MEDIUM',
    E'2 <= n <= 58',
    160,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '2', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '7', '12', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '10', '36', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '3', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '4', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '8', '18', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '20', '1458', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '58', '1549681956', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'break-integer'),
    'en',
    'Break Integer',
    'Given a positive integer `n`, split it into at least two positive integers such that their sum equals `n`, and return the maximum product you can achieve from those parts.

**Example 1:**
```
Input: n = 2
Output: 1
Explanation: 2 = 1 + 1, and 1 x 1 = 1.
```

**Example 2:**
```
Input: n = 7
Output: 12
Explanation: 7 = 3 + 4, and 3 x 4 = 12.
```

**Example 3:**
```
Input: n = 10
Output: 36
Explanation: 10 = 3 + 3 + 4, and 3 x 3 x 4 = 36.
```',
    E'2 <= n <= 58'
);

------------------------------------------------------------
-- Add Longest Chain Count problem
-- CodeBite original name: Longest Chain Count (inspired by Number of Longest Increasing Subsequence, LC #673)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Longest Chain Count',
    'longest-chain-count',
    'Given an integer array `nums`, determine how many **longest strictly increasing subsequences** exist within it.

A strictly increasing subsequence is a sequence of elements picked from the array (not necessarily contiguous) where each element is strictly greater than the previous one. You need to find the length of the longest such subsequence and then count how many distinct subsequences achieve that maximum length.

**Example 1:**
```
Input: nums = [1,3,5,4,7]
Output: 2
Explanation: The longest increasing subsequences have length 4. There are two of them: [1,3,5,7] and [1,3,4,7].
```

**Example 2:**
```
Input: nums = [2,2,2,2,2]
Output: 5
Explanation: Every single element forms an increasing subsequence of length 1. There are 5 such subsequences.
```

**Example 3:**
```
Input: nums = [1,2,3]
Output: 1
Explanation: The only longest increasing subsequence is [1,2,3], which has length 3.
```',
    'MEDIUM',
    '1 <= nums.length <= 2000
-10^6 <= nums[i] <= 10^6',
    161,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,3,5,4,7]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[2,2,2,2,2]', '5', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,2,3]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,2,4,3,5,4,7,2]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[3,1,2]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,1,1,2,2,2,3,3,3]', '27', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-chain-count'),
    'en',
    'Longest Chain Count',
    'Given an integer array `nums`, determine how many **longest strictly increasing subsequences** exist within it.

A strictly increasing subsequence is a sequence of elements picked from the array (not necessarily contiguous) where each element is strictly greater than the previous one. You need to find the length of the longest such subsequence and then count how many distinct subsequences achieve that maximum length.

**Example 1:**
```
Input: nums = [1,3,5,4,7]
Output: 2
Explanation: The longest increasing subsequences have length 4. There are two of them: [1,3,5,7] and [1,3,4,7].
```

**Example 2:**
```
Input: nums = [2,2,2,2,2]
Output: 5
Explanation: Every single element forms an increasing subsequence of length 1. There are 5 such subsequences.
```

**Example 3:**
```
Input: nums = [1,2,3]
Output: 1
Explanation: The only longest increasing subsequence is [1,2,3], which has length 3.
```',
    '1 <= nums.length <= 2000
-10^6 <= nums[i] <= 10^6'
);

------------------------------------------------------------
-- Add Stock Cooldown problem
-- CodeBite original name: Stock Cooldown (inspired by Best Time to Buy and Sell Stock with Cooldown, LC #309)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Stock Cooldown',
    'stock-cooldown',
    'You are given an integer array `prices` where `prices[i]` represents a stock''s price on day `i`.

You may perform as many buy-sell transactions as you like, but after each sale you must wait one day before buying again (a "cooldown" period). You can only hold one share of the stock at a time.

Return the maximum total profit you can achieve.

**Example 1:**
```
Input: prices = [1,2,3,0,2]
Output: 3
Explanation: Buy on day 0, sell on day 1 (profit 1). After a cooldown on day 2, buy on day 3 and sell on day 4 (profit 2). Total profit is 3.
```

**Example 2:**
```
Input: prices = [1]
Output: 0
Explanation: With only one day there is no opportunity to complete a transaction.
```

**Example 3:**
```
Input: prices = [1,4,2,7]
Output: 6
Explanation: Buy on day 0 and sell on day 3 for a profit of 6. Selling earlier and re-buying would not beat this.
```',
    'MEDIUM',
    E'1 <= prices.length <= 5000\n0 <= prices[i] <= 1000',
    162,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,2,3,0,2]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1]', '0', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,4,2,7]', '6', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[2,1]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,2,4]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[6,1,3,2,4,7]', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[2,6,8,7,8,7,9,4,1,2,4,5,8]', '15', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'stock-cooldown'),
    'en',
    'Stock Cooldown',
    'You are given an integer array `prices` where `prices[i]` represents a stock''s price on day `i`.

You may perform as many buy-sell transactions as you like, but after each sale you must wait one day before buying again (a "cooldown" period). You can only hold one share of the stock at a time.

Return the maximum total profit you can achieve.

**Example 1:**
```
Input: prices = [1,2,3,0,2]
Output: 3
Explanation: Buy on day 0, sell on day 1 (profit 1). After a cooldown on day 2, buy on day 3 and sell on day 4 (profit 2). Total profit is 3.
```

**Example 2:**
```
Input: prices = [1]
Output: 0
Explanation: With only one day there is no opportunity to complete a transaction.
```

**Example 3:**
```
Input: prices = [1,4,2,7]
Output: 6
Explanation: Buy on day 0 and sell on day 3 for a profit of 6. Selling earlier and re-buying would not beat this.
```',
    E'1 <= prices.length <= 5000\n0 <= prices[i] <= 1000'
);

------------------------------------------------------------
-- Add Sign Assignments problem
-- CodeBite original name: Sign Assignments (inspired by Target Sum, LC #494)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Sign Assignments',
    'sign-assignments',
    'Given an integer array `nums` and an integer `target`, determine how many ways you can assign a `+` or `-` sign in front of each element so that the resulting expression evaluates to `target`.

Every element must be used exactly once, and each element must receive either a `+` or a `-` sign.

Return the total number of distinct sign assignments that produce the target sum.

**Example 1:**
```
Input: nums = [1,1,1,1,1], target = 3
Output: 5
Explanation: There are 5 ways to assign signs so the sum equals 3: +1+1+1+1-1, +1+1+1-1+1, +1+1-1+1+1, +1-1+1+1+1, -1+1+1+1+1.
```

**Example 2:**
```
Input: nums = [1], target = 1
Output: 1
```

**Example 3:**
```
Input: nums = [2,3,5], target = 0
Output: 2
Explanation: +2+3-5 = 0 and -2-3+5 = 0.
```',
    'MEDIUM',
    E'1 <= nums.length <= 20\n0 <= nums[i] <= 1000\n-1000 <= target <= 1000',
    163,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,1,1,1,1]\n3', '5', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1]\n1', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[2,3,5]\n0', '2', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,0]\n1', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,3]\n6', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,3]\n7', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[0,0,0,0]\n0', '16', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,1,2,1]\n3', '5', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sign-assignments'),
    'en',
    'Sign Assignments',
    'Given an integer array `nums` and an integer `target`, determine how many ways you can assign a `+` or `-` sign in front of each element so that the resulting expression evaluates to `target`.

Every element must be used exactly once, and each element must receive either a `+` or a `-` sign.

Return the total number of distinct sign assignments that produce the target sum.

**Example 1:**
```
Input: nums = [1,1,1,1,1], target = 3
Output: 5
Explanation: There are 5 ways to assign signs so the sum equals 3: +1+1+1+1-1, +1+1+1-1+1, +1+1-1+1+1, +1-1+1+1+1, -1+1+1+1+1.
```

**Example 2:**
```
Input: nums = [1], target = 1
Output: 1
```

**Example 3:**
```
Input: nums = [2,3,5], target = 0
Output: 2
Explanation: +2+3-5 = 0 and -2-3+5 = 0.
```',
    E'1 <= nums.length <= 20\n0 <= nums[i] <= 1000\n-1000 <= target <= 1000'
);

------------------------------------------------------------
-- Add String Weave problem
-- CodeBite original name: String Weave (inspired by Interleaving String, LC #97)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'String Weave',
    'string-weave',
    'Given three strings `s1`, `s2`, and `s3`, determine whether `s3` can be formed by weaving together the characters of `s1` and `s2`. A valid weave uses every character from both `s1` and `s2` exactly once, and the characters from each string must appear in their original relative order within `s3`.

Return `true` if `s3` is a valid weave of `s1` and `s2`, and `false` otherwise.

**Example 1:**
```
Input: s1 = "aab", s2 = "axy", s3 = "aaxaby"
Output: true
Explanation: One valid weave: take "a" from s1, then "a","x" from s2, then "a","b" from s1, then "y" from s2.
```

**Example 2:**
```
Input: s1 = "aab", s2 = "axy", s3 = "abaaxy"
Output: false
Explanation: No way to weave s1 and s2 while preserving order to produce s3.
```

**Example 3:**
```
Input: s1 = "", s2 = "", s3 = ""
Output: true
Explanation: Two empty strings trivially weave into an empty result.
```',
    'MEDIUM',
    E'0 <= s1.length, s2.length <= 100\n0 <= s3.length <= 200\ns1, s2, and s3 consist of lowercase English letters',
    164,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'aab\naxy\naaxaby', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'aab\naxy\nabaaxy', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'\n\n', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'abc\ndef\nadbecf', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'abc\ndef\nadbfce', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'\nabc\nabc', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'a\nb\nab', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'aaaa\naaaa\naaaaaaaa', 'true', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'string-weave'),
    'en',
    'String Weave',
    'Given three strings `s1`, `s2`, and `s3`, determine whether `s3` can be formed by weaving together the characters of `s1` and `s2`. A valid weave uses every character from both `s1` and `s2` exactly once, and the characters from each string must appear in their original relative order within `s3`.

Return `true` if `s3` is a valid weave of `s1` and `s2`, and `false` otherwise.

**Example 1:**
```
Input: s1 = "aab", s2 = "axy", s3 = "aaxaby"
Output: true
Explanation: One valid weave: take "a" from s1, then "a","x" from s2, then "a","b" from s1, then "y" from s2.
```

**Example 2:**
```
Input: s1 = "aab", s2 = "axy", s3 = "abaaxy"
Output: false
Explanation: No way to weave s1 and s2 while preserving order to produce s3.
```

**Example 3:**
```
Input: s1 = "", s2 = "", s3 = ""
Output: true
Explanation: Two empty strings trivially weave into an empty result.
```',
    E'0 <= s1.length, s2.length <= 100\n0 <= s3.length <= 200\ns1, s2, and s3 consist of lowercase English letters'
);

------------------------------------------------------------
-- Add Subsequence Count problem
-- CodeBite original name: Subsequence Count (inspired by Distinct Subsequences, LC #115)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Subsequence Count',
    'subsequence-count',
    'Given two strings `s` and `t`, determine how many distinct subsequences of `s` are equal to `t`.

A **subsequence** of a string is a new string formed by deleting zero or more characters from the original string without changing the relative order of the remaining characters.

Since the answer may be very large, return it as a regular integer (all test cases guarantee the answer fits in a 64-bit integer).

**Example 1:**
```
Input: s = "rabbbit", t = "rabbit"
Output: 3
Explanation: There are 3 ways to choose characters from s to form "rabbit" — each way picks a different one of the three ''b'' characters as the middle ''b'' in "rabbit".
```

**Example 2:**
```
Input: s = "babgbag", t = "bag"
Output: 5
Explanation: There are 5 distinct ways to select characters from s that form the subsequence "bag".
```

**Example 3:**
```
Input: s = "aaa", t = "a"
Output: 3
```',
    'HARD',
    '1 <= s.length, t.length <= 1000
s and t consist of lowercase English letters',
    165,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'rabbbit\nrabbit', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'babgbag\nbag', '5', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'aaa\na', '3', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'abc\ndef', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'a\na', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'aaaaaaaaaa\naaa', '120', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'abcabc\nabc', '4', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'subsequence-count'),
    'en',
    'Subsequence Count',
    'Given two strings `s` and `t`, determine how many distinct subsequences of `s` are equal to `t`.

A **subsequence** of a string is a new string formed by deleting zero or more characters from the original string without changing the relative order of the remaining characters.

Since the answer may be very large, return it as a regular integer (all test cases guarantee the answer fits in a 64-bit integer).

**Example 1:**
```
Input: s = "rabbbit", t = "rabbit"
Output: 3
Explanation: There are 3 ways to choose characters from s to form "rabbit" — each way picks a different one of the three ''b'' characters as the middle ''b'' in "rabbit".
```

**Example 2:**
```
Input: s = "babgbag", t = "bag"
Output: 5
Explanation: There are 5 distinct ways to select characters from s that form the subsequence "bag".
```

**Example 3:**
```
Input: s = "aaa", t = "a"
Output: 3
```',
    '1 <= s.length, t.length <= 1000
s and t consist of lowercase English letters'
);

------------------------------------------------------------
-- Add Pattern Matcher problem
-- CodeBite original name: Pattern Matcher (inspired by Regular Expression Matching, LC #10)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Pattern Matcher',
    'pattern-matcher',
    'Given a string `s` and a pattern `p`, determine whether the pattern matches the **entire** string.

The pattern may contain two special characters:
- `''.''` matches any single character.
- `''*''` matches **zero or more** of the character immediately before it.

The match must cover `s` completely from start to end, not just a substring.

**Example 1:**
```
Input: s = "aa", p = "a"
Output: false
Explanation: The pattern "a" only covers a single character, not the full string "aa".
```

**Example 2:**
```
Input: s = "aa", p = "a*"
Output: true
Explanation: The ''*'' means zero or more of the preceding ''a'', so "a*" can represent "aa".
```

**Example 3:**
```
Input: s = "ab", p = ".*"
Output: true
Explanation: ".*" means zero or more of any character, which can match any string.
```',
    'HARD',
    '1 <= s.length <= 20
1 <= p.length <= 20
s contains only lowercase English letters
p contains only lowercase English letters, ''.'', and ''*''
Each ''*'' has a valid preceding character (it is guaranteed that ''*'' does not appear as the first character or immediately after another ''*'')',
    166,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aa\na', 'false', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aa\na*', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'ab\n.*', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aab\nc*a*b', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'mississippi\nmis*is*ip*.', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'ab\n.*c', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'a\na*a', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aaa\na*a', 'true', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pattern-matcher'),
    'en',
    'Pattern Matcher',
    'Given a string `s` and a pattern `p`, determine whether the pattern matches the **entire** string.

The pattern may contain two special characters:
- `''.''` matches any single character.
- `''*''` matches **zero or more** of the character immediately before it.

The match must cover `s` completely from start to end, not just a substring.

**Example 1:**
```
Input: s = "aa", p = "a"
Output: false
Explanation: The pattern "a" only covers a single character, not the full string "aa".
```

**Example 2:**
```
Input: s = "aa", p = "a*"
Output: true
Explanation: The ''*'' means zero or more of the preceding ''a'', so "a*" can represent "aa".
```

**Example 3:**
```
Input: s = "ab", p = ".*"
Output: true
Explanation: ".*" means zero or more of any character, which can match any string.
```',
    '1 <= s.length <= 20
1 <= p.length <= 20
s contains only lowercase English letters
p contains only lowercase English letters, ''.'', and ''*''
Each ''*'' has a valid preceding character (it is guaranteed that ''*'' does not appear as the first character or immediately after another ''*'')'
);

