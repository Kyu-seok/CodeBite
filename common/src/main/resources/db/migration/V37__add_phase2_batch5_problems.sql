-- Phase 2 Batch 5: 6 new problems — Dynamic Programming (4) + 2D Dynamic Programming (3)
-- account-merger already exists and will be renumbered in the wiring migration.

------------------------------------------------------------
-- DYNAMIC PROGRAMMING
------------------------------------------------------------

-- House Thief II (House Robber II)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'House Thief II',
    'house-thief-ii',
    'You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed. All houses at this place are **arranged in a circle**. That means the first house is the neighbor of the last one. Meanwhile, adjacent houses have a security system connected and **it will automatically contact the police if two adjacent houses were broken into on the same night**.

Given an integer array `nums` representing the amount of money of each house, return the maximum amount of money you can rob tonight **without alerting the police**.

**Example 1:**
```
Input: nums = [2,3,2]
Output: 3
Explanation: You cannot rob house 1 (money = 2) and then rob house 3 (money = 2), because they are adjacent houses.
```

**Example 2:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3). Total = 1 + 3 = 4.
```

**Example 3:**
```
Input: nums = [1,2,3]
Output: 3
```',
    'MEDIUM',
    '1 <= nums.length <= 100
0 <= nums[i] <= 1000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[2,3,2]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[1,2,3,1]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[1,2,3]', '3', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[200,3,140,20,10]', '340', FALSE, 5);

-- Decode Ways
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Decode Ways',
    'decode-ways',
    'A message containing letters from `A-Z` can be encoded into numbers using the following mapping:

```
''A'' -> "1"
''B'' -> "2"
...
''Z'' -> "26"
```

To **decode** an encoded message, all the digits must be grouped then mapped back into letters using the reverse of the mapping above (there may be multiple ways).

Given a string `s` containing only digits, return the **number of ways** to decode it.

**Example 1:**
```
Input: s = "12"
Output: 2
Explanation: "12" could be decoded as "AB" (1 2) or "L" (12).
```

**Example 2:**
```
Input: s = "226"
Output: 3
Explanation: "226" could be decoded as "BZ" (2 26), "VF" (22 6), or "BBF" (2 2 6).
```

**Example 3:**
```
Input: s = "06"
Output: 0
Explanation: "06" cannot be mapped to "F" because of the leading zero.
```',
    'MEDIUM',
    '1 <= s.length <= 100
s contains only digits and may contain leading zeros.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '12', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '226', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '06', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '11106', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '10', '1', FALSE, 5);

-- Max Product Subarray (Maximum Product Subarray)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Max Product Subarray',
    'max-product-subarray',
    'Given an integer array `nums`, find a subarray that has the largest product, and return the product.

**Example 1:**
```
Input: nums = [2,3,-2,4]
Output: 6
Explanation: [2,3] has the largest product 6.
```

**Example 2:**
```
Input: nums = [-2,0,-1]
Output: 0
Explanation: The result cannot be 2, because [-2,-1] is not a subarray.
```',
    'MEDIUM',
    '1 <= nums.length <= 2 * 10^4
-10 <= nums[i] <= 10
The product of any subarray of nums is guaranteed to fit in a 32-bit integer.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[2,3,-2,4]', '6', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-2,0,-1]', '0', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-2,3,-4]', '24', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[0,2]', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-2]', '-2', FALSE, 5);

-- Palindrome Count (Palindromic Substrings)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Palindrome Count',
    'palindrome-count',
    'Given a string `s`, return the number of **palindromic substrings** in it.

A string is a palindrome when it reads the same backward as forward. A substring is a contiguous sequence of characters within the string.

**Example 1:**
```
Input: s = "abc"
Output: 3
Explanation: Three palindromic strings: "a", "b", "c".
```

**Example 2:**
```
Input: s = "aaa"
Output: 6
Explanation: Six palindromic strings: "a", "a", "a", "aa", "aa", "aaa".
```',
    'MEDIUM',
    '1 <= s.length <= 1000
s consists of lowercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abc', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'aaa', '6', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'racecar', '10', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'a', '1', FALSE, 4);

------------------------------------------------------------
-- 2D DYNAMIC PROGRAMMING
------------------------------------------------------------

-- Unique Paths
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Unique Paths',
    'unique-paths',
    'There is a robot on an `m x n` grid. The robot is initially located at the top-left corner (i.e., `grid[0][0]`). The robot tries to move to the bottom-right corner (i.e., `grid[m - 1][n - 1]`). The robot can only move either down or right at any point in time.

Given the two integers `m` and `n`, return the number of possible unique paths that the robot can take to reach the bottom-right corner.

**Example 1:**
```
Input: m = 3, n = 7
Output: 28
```

**Example 2:**
```
Input: m = 3, n = 2
Output: 3
Explanation: From the top-left corner, there are a total of 3 ways to reach the bottom-right corner:
1. Right -> Down -> Down
2. Down -> Down -> Right
3. Down -> Right -> Down
```',
    'MEDIUM',
    '1 <= m, n <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), '3
7', '28', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), '3
2', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), '1
1', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), '7
3', '28', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), '10
10', '48620', FALSE, 5);

-- Longest Common Subsequence
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Longest Common Subsequence',
    'longest-common-subseq',
    'Given two strings `text1` and `text2`, return the length of their longest common subsequence. If there is no common subsequence, return `0`.

A **subsequence** of a string is a new string generated from the original string with some characters (can be none) deleted without changing the relative order of the remaining characters.

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
Explanation: There is no such common subsequence, so the result is 0.
```',
    'MEDIUM',
    '1 <= text1.length, text2.length <= 1000
text1 and text2 consist of only lowercase English characters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), 'abcde
ace', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), 'abc
abc', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), 'abc
def', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), 'oxcpqrsvwf
shmtulqrypy', '2', FALSE, 4);

-- Edit Distance
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Edit Distance',
    'edit-distance',
    'Given two strings `word1` and `word2`, return the minimum number of operations required to convert `word1` to `word2`.

You have the following three operations permitted on a word:
- Insert a character
- Delete a character
- Replace a character

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
```',
    'HARD',
    '0 <= word1.length, word2.length <= 500
word1 and word2 consist of lowercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), 'horse
ros', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), 'intention
execution', '5', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), '
a', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), 'abc
abc', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), 'dinitrophenylhydrazine
acetylaminophenol', '11', FALSE, 5);

------------------------------------------------------------
-- ENGLISH TRANSLATIONS
------------------------------------------------------------

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
SELECT id, 'en', title, description, constraints FROM problems
WHERE slug IN (
    'house-thief-ii', 'decode-ways', 'max-product-subarray', 'palindrome-count',
    'unique-paths', 'longest-common-subseq', 'edit-distance'
);
