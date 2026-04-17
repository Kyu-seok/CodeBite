-- Improve descriptions: batch 17

------------------------------------------------------------
-- longest-chain-count
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums`, return the number of **longest strictly increasing subsequences**.

A **strictly increasing subsequence** is a sequence of elements chosen from the array (not necessarily contiguous) where each element is strictly greater than the one before it. First, find the maximum length among all such subsequences. Then, count how many distinct subsequences achieve that maximum length.

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
```'
WHERE slug = 'longest-chain-count';

UPDATE problem_translations
SET description = 'Given an integer array `nums`, return the number of **longest strictly increasing subsequences**.

A **strictly increasing subsequence** is a sequence of elements chosen from the array (not necessarily contiguous) where each element is strictly greater than the one before it. First, find the maximum length among all such subsequences. Then, count how many distinct subsequences achieve that maximum length.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-chain-count')
  AND locale = 'en';

------------------------------------------------------------
-- stock-cooldown
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `prices` where `prices[i]` is the price of a stock on day `i`.

You may complete as many buy-sell transactions as you like, subject to these rules:
- You may hold at most one share at a time.
- After selling a share, you must wait one full day before buying again (a **cooldown** period).

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
```'
WHERE slug = 'stock-cooldown';

UPDATE problem_translations
SET description = 'You are given an integer array `prices` where `prices[i]` is the price of a stock on day `i`.

You may complete as many buy-sell transactions as you like, subject to these rules:
- You may hold at most one share at a time.
- After selling a share, you must wait one full day before buying again (a **cooldown** period).

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-cooldown')
  AND locale = 'en';

------------------------------------------------------------
-- sign-assignments
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` and an integer `target`, return the number of ways you can assign a `+` or `-` sign to each element so that the sum of the signed elements equals `target`.

Every element must be used exactly once, and each element must receive either a `+` or `-` sign.

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
```'
WHERE slug = 'sign-assignments';

UPDATE problem_translations
SET description = 'Given an integer array `nums` and an integer `target`, return the number of ways you can assign a `+` or `-` sign to each element so that the sum of the signed elements equals `target`.

Every element must be used exactly once, and each element must receive either a `+` or `-` sign.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sign-assignments')
  AND locale = 'en';

------------------------------------------------------------
-- string-weave
------------------------------------------------------------
UPDATE problems
SET description = 'Given three strings `s1`, `s2`, and `s3`, determine whether `s3` is formed by **interleaving** the characters of `s1` and `s2`.

An interleaving of `s1` and `s2` is a string that contains every character from both strings exactly once, with the relative order of characters from each string preserved. For example, `"aaxaby"` is a valid interleaving of `"aab"` and `"axy"`, but `"abaaxy"` is not.

Return `true` if `s3` is a valid interleaving of `s1` and `s2`, or `false` otherwise.

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
```'
WHERE slug = 'string-weave';

UPDATE problem_translations
SET description = 'Given three strings `s1`, `s2`, and `s3`, determine whether `s3` is formed by **interleaving** the characters of `s1` and `s2`.

An interleaving of `s1` and `s2` is a string that contains every character from both strings exactly once, with the relative order of characters from each string preserved. For example, `"aaxaby"` is a valid interleaving of `"aab"` and `"axy"`, but `"abaaxy"` is not.

Return `true` if `s3` is a valid interleaving of `s1` and `s2`, or `false` otherwise.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-weave')
  AND locale = 'en';

------------------------------------------------------------
-- subsequence-count
------------------------------------------------------------
UPDATE problems
SET description = 'Given two strings `s` and `t`, return the number of distinct subsequences of `s` that equal `t`.

A **subsequence** of a string is formed by deleting zero or more characters without changing the relative order of the remaining characters. For example, `"ace"` is a subsequence of `"abcde"`, but `"aec"` is not.

The answer is guaranteed to fit in a 64-bit integer.

**Example 1:**
```
Input: s = "rabbbit", t = "rabbit"
Output: 3
Explanation: There are 3 ways to choose characters from s to form "rabbit" -- each way picks a different one of the three ''b'' characters as the middle ''b'' in "rabbit".
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
```'
WHERE slug = 'subsequence-count';

UPDATE problem_translations
SET description = 'Given two strings `s` and `t`, return the number of distinct subsequences of `s` that equal `t`.

A **subsequence** of a string is formed by deleting zero or more characters without changing the relative order of the remaining characters. For example, `"ace"` is a subsequence of `"abcde"`, but `"aec"` is not.

The answer is guaranteed to fit in a 64-bit integer.

**Example 1:**
```
Input: s = "rabbbit", t = "rabbit"
Output: 3
Explanation: There are 3 ways to choose characters from s to form "rabbit" -- each way picks a different one of the three ''b'' characters as the middle ''b'' in "rabbit".
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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'subsequence-count')
  AND locale = 'en';

------------------------------------------------------------
-- pattern-matcher
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` and a pattern `p`, determine whether the pattern matches the **entire** string.

The pattern supports two special characters:
- `.` matches any single character.
- `*` matches **zero or more** of the character immediately before it.

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
```'
WHERE slug = 'pattern-matcher';

UPDATE problem_translations
SET description = 'Given a string `s` and a pattern `p`, determine whether the pattern matches the **entire** string.

The pattern supports two special characters:
- `.` matches any single character.
- `*` matches **zero or more** of the character immediately before it.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pattern-matcher')
  AND locale = 'en';

------------------------------------------------------------
-- balloon-popper
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an array `nums` where each element represents a balloon with a value printed on it. You may pop the balloons one at a time in any order.

When you pop balloon at index `i`, you earn `nums[i - 1] * nums[i] * nums[i + 1]` coins. After popping, balloon `i` is removed and its neighbors become adjacent. If `i - 1` or `i + 1` is out of bounds, treat that neighbor''s value as `1`.

Return the maximum number of coins you can collect by popping all the balloons.

**Example 1:**
```
Input: nums = [3,1,5,8]
Output: 167
Explanation: One optimal order is to pop balloons with values 1, 5, 3, 8: coins = 3*1*5 + 3*5*8 + 1*3*8 + 1*8*1 = 15 + 120 + 24 + 8 = 167.
```

**Example 2:**
```
Input: nums = [1,5]
Output: 10
Explanation: Pop the balloon with value 1 first: 1*1*5 = 5. Then pop 5: 1*5*1 = 5. Total = 10.
```

**Example 3:**
```
Input: nums = [9]
Output: 9
Explanation: Only one balloon: 1*9*1 = 9.
```'
WHERE slug = 'balloon-popper';

UPDATE problem_translations
SET description = 'You are given an array `nums` where each element represents a balloon with a value printed on it. You may pop the balloons one at a time in any order.

When you pop balloon at index `i`, you earn `nums[i - 1] * nums[i] * nums[i + 1]` coins. After popping, balloon `i` is removed and its neighbors become adjacent. If `i - 1` or `i + 1` is out of bounds, treat that neighbor''s value as `1`.

Return the maximum number of coins you can collect by popping all the balloons.

**Example 1:**
```
Input: nums = [3,1,5,8]
Output: 167
Explanation: One optimal order is to pop balloons with values 1, 5, 3, 8: coins = 3*1*5 + 3*5*8 + 1*3*8 + 1*8*1 = 15 + 120 + 24 + 8 = 167.
```

**Example 2:**
```
Input: nums = [1,5]
Output: 10
Explanation: Pop the balloon with value 1 first: 1*1*5 = 5. Then pop 5: 1*5*1 = 5. Total = 10.
```

**Example 3:**
```
Input: nums = [9]
Output: 9
Explanation: Only one balloon: 1*9*1 = 9.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balloon-popper')
  AND locale = 'en';

------------------------------------------------------------
-- largest-square
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` binary matrix filled with `"0"` and `"1"` characters, find the area of the largest square containing only `"1"`s.

The area of a square with side length `k` is `k * k`. Return `0` if no `"1"` exists in the matrix.

**Example 1:**
```
Input: matrix = [["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]
Output: 4
Explanation: The largest square of all 1s has side length 2, so the area is 2 * 2 = 4.
```

**Example 2:**
```
Input: matrix = [["0","1"],["1","0"]]
Output: 1
Explanation: The largest square of all 1s has side length 1.
```

**Example 3:**
```
Input: matrix = [["0"]]
Output: 0
Explanation: There are no 1s in the matrix, so the area is 0.
```'
WHERE slug = 'largest-square';

UPDATE problem_translations
SET description = 'Given an `m x n` binary matrix filled with `"0"` and `"1"` characters, find the area of the largest square containing only `"1"`s.

The area of a square with side length `k` is `k * k`. Return `0` if no `"1"` exists in the matrix.

**Example 1:**
```
Input: matrix = [["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]
Output: 4
Explanation: The largest square of all 1s has side length 2, so the area is 2 * 2 = 4.
```

**Example 2:**
```
Input: matrix = [["0","1"],["1","0"]]
Output: 1
Explanation: The largest square of all 1s has side length 1.
```

**Example 3:**
```
Input: matrix = [["0"]]
Output: 0
Explanation: There are no 1s in the matrix, so the area is 0.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-square')
  AND locale = 'en';

------------------------------------------------------------
-- change-maker
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer `amount` and an integer array `coins` representing available coin denominations, return the number of distinct combinations that sum to exactly `amount`.

Each coin denomination may be used any number of times. Two combinations are considered different only if they use a different count of at least one denomination.

If no combination reaches the target amount, return `0`.

**Example 1:**
```
Input: amount = 5, coins = [1,2,5]
Output: 4
Explanation: The four combinations are: 5, 2+2+1, 2+1+1+1, 1+1+1+1+1.
```

**Example 2:**
```
Input: amount = 3, coins = [2]
Output: 0
Explanation: No combination of 2-cent coins can total 3.
```

**Example 3:**
```
Input: amount = 0, coins = [1,2]
Output: 1
Explanation: There is exactly one way to make amount 0: use no coins at all.
```'
WHERE slug = 'change-maker';

UPDATE problem_translations
SET description = 'Given an integer `amount` and an integer array `coins` representing available coin denominations, return the number of distinct combinations that sum to exactly `amount`.

Each coin denomination may be used any number of times. Two combinations are considered different only if they use a different count of at least one denomination.

If no combination reaches the target amount, return `0`.

**Example 1:**
```
Input: amount = 5, coins = [1,2,5]
Output: 4
Explanation: The four combinations are: 5, 2+2+1, 2+1+1+1, 1+1+1+1+1.
```

**Example 2:**
```
Input: amount = 3, coins = [2]
Output: 0
Explanation: No combination of 2-cent coins can total 3.
```

**Example 3:**
```
Input: amount = 0, coins = [1,2]
Output: 1
Explanation: There is exactly one way to make amount 0: use no coins at all.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'change-maker')
  AND locale = 'en';

------------------------------------------------------------
-- cheapest-path
------------------------------------------------------------
UPDATE problems
SET description = 'Given an `m x n` grid of non-negative integers, find a path from the top-left corner to the bottom-right corner that minimizes the sum of all values along the path.

You can only move **right** or **down** at each step.

Return the minimum path sum.

**Example 1:**
```
Input: grid = [[1,3,1],[1,5,1],[4,2,1]]
Output: 7
Explanation: The path 1 -> 3 -> 1 -> 1 -> 1 gives the smallest sum of 7.
```

**Example 2:**
```
Input: grid = [[1,2,3],[4,5,6]]
Output: 12
Explanation: The path 1 -> 2 -> 3 -> 6 gives a sum of 12.
```

**Example 3:**
```
Input: grid = [[5]]
Output: 5
Explanation: The grid has only one cell, so the answer is its value.
```'
WHERE slug = 'cheapest-path';

UPDATE problem_translations
SET description = 'Given an `m x n` grid of non-negative integers, find a path from the top-left corner to the bottom-right corner that minimizes the sum of all values along the path.

You can only move **right** or **down** at each step.

Return the minimum path sum.

**Example 1:**
```
Input: grid = [[1,3,1],[1,5,1],[4,2,1]]
Output: 7
Explanation: The path 1 -> 3 -> 1 -> 1 -> 1 gives the smallest sum of 7.
```

**Example 2:**
```
Input: grid = [[1,2,3],[4,5,6]]
Output: 12
Explanation: The path 1 -> 2 -> 3 -> 6 gives a sum of 12.
```

**Example 3:**
```
Input: grid = [[5]]
Output: 5
Explanation: The grid has only one cell, so the answer is its value.
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheapest-path')
  AND locale = 'en';
