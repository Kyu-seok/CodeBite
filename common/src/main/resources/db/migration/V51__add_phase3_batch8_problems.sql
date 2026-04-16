-- Phase 3 Batch 8: 2D DP second half (#167-171) + Greedy (#172-177)
-- 11 problems: balloon-popper, largest-square, change-maker, cheapest-path, longest-climb, hand-grouping, label-splitter, flexible-brackets, triplet-former, height-queue, almost-sorted

------------------------------------------------------------
-- Add Balloon Popper problem
-- CodeBite original name: Balloon Popper (inspired by Burst Balloons, LC #312)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Balloon Popper',
    'balloon-popper',
    'You are given an array of integers `nums` where each element represents a balloon with a value printed on it. You can pop the balloons one at a time, in any order you choose. When you pop balloon `i`, you earn `nums[i - 1] * nums[i] * nums[i + 1]` coins. After popping, balloon `i` is removed and its neighbors become adjacent to each other. If `i - 1` or `i + 1` goes out of bounds, treat the out-of-bounds value as `1`.

Return the **maximum** number of coins you can collect by popping all the balloons.

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
```',
    'HARD',
    '1 <= nums.length <= 300
0 <= nums[i] <= 100',
    167,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[3,1,5,8]', '167', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[1,5]', '10', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[9]', '9', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[1,2,3,4,5]', '110', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[2,3,7,1,4]', '148', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[1,1,1,1]', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[1]', '1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'balloon-popper'),
    'en',
    'Balloon Popper',
    'You are given an array of integers `nums` where each element represents a balloon with a value printed on it. You can pop the balloons one at a time, in any order you choose. When you pop balloon `i`, you earn `nums[i - 1] * nums[i] * nums[i + 1]` coins. After popping, balloon `i` is removed and its neighbors become adjacent to each other. If `i - 1` or `i + 1` goes out of bounds, treat the out-of-bounds value as `1`.

Return the **maximum** number of coins you can collect by popping all the balloons.

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
```',
    '1 <= nums.length <= 300
0 <= nums[i] <= 100'
);

------------------------------------------------------------
-- Add Largest Square problem
-- CodeBite original name: Largest Square (inspired by Maximal Square, LC #221)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Largest Square',
    'largest-square',
    'Given an `m x n` binary matrix `matrix` filled with `"0"` and `"1"` characters, determine the area of the largest square that contains only `"1"`s.

The area of a square with side length `k` is `k * k`.

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
```',
    'MEDIUM',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 300
matrix[i][j] is ''0'' or ''1''',
    168,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["0","1"],["1","0"]]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["0"]]', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1"]]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","1","1","1"],["1","1","1","1"],["1","1","1","1"]]', '9', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["0","0","0"],["0","0","0"]]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","1","0","1"],["1","1","0","1"],["1","1","1","1"]]', '4', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'largest-square'),
    'en',
    'Largest Square',
    'Given an `m x n` binary matrix `matrix` filled with `"0"` and `"1"` characters, determine the area of the largest square that contains only `"1"`s.

The area of a square with side length `k` is `k * k`.

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
```',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 300
matrix[i][j] is ''0'' or ''1'''
);

------------------------------------------------------------
-- Add Change Maker problem
-- CodeBite original name: Change Maker (inspired by Coin Change 2, LC #518)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Change Maker',
    'change-maker',
    'Given an integer `amount` representing a total sum of money and an integer array `coins` representing available coin denominations, return the number of distinct combinations that add up to exactly `amount`.

You may use each coin denomination as many times as needed. Two combinations are considered different if they differ in the count of any coin used.

If there is no way to reach the target amount, return `0`.

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
```',
    'MEDIUM',
    '1 <= coins.length <= 300
1 <= coins[i] <= 5000
All values in coins are unique
0 <= amount <= 5000',
    169,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'5\n[1,2,5]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'3\n[2]', '0', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'0\n[1,2]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'10\n[1,2,5]', '10', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'11\n[1,5,10]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'100\n[1,5,10,25]', '242', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'1\n[1]', '1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'change-maker'),
    'en',
    'Change Maker',
    'Given an integer `amount` representing a total sum of money and an integer array `coins` representing available coin denominations, return the number of distinct combinations that add up to exactly `amount`.

You may use each coin denomination as many times as needed. Two combinations are considered different if they differ in the count of any coin used.

If there is no way to reach the target amount, return `0`.

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
```',
    '1 <= coins.length <= 300
1 <= coins[i] <= 5000
All values in coins are unique
0 <= amount <= 5000'
);

------------------------------------------------------------
-- Add Cheapest Path problem
-- CodeBite original name: Cheapest Path (inspired by Minimum Path Sum, LC #64)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Cheapest Path',
    'cheapest-path',
    'Given an `m x n` grid of non-negative integers, find a path from the top-left corner to the bottom-right corner that minimizes the total sum of values along the path.

At each step, you may only move **right** or **down**.

Return the minimum sum achievable.

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
```',
    'MEDIUM',
    'm == grid.length
n == grid[i].length
1 <= m, n <= 200
0 <= grid[i][j] <= 200',
    170,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,3,1],[1,5,1],[4,2,1]]', '7', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,2,3],[4,5,6]]', '12', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[5]]', '5', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,2],[1,1]]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[0,0,0],[0,0,0],[0,0,0]]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,100,100],[1,1,100],[100,1,1]]', '5', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[3,8,6,0,5,9,9,6,3,4,0,5,7,3,9,3],[0,3,2,5,5,4,8,2,1,3,7,2,0,6,7,0],[2,9,2,2,3,2,3,1,2,5,9,2,4,5,2,1],[0,2,0,4,5,0,0,4,1,6,0,4,2,1,0,3],[8,4,0,2,7,7,0,1,1,0,3,5,5,8,2,3]]', '39', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cheapest-path'),
    'en',
    'Cheapest Path',
    'Given an `m x n` grid of non-negative integers, find a path from the top-left corner to the bottom-right corner that minimizes the total sum of values along the path.

At each step, you may only move **right** or **down**.

Return the minimum sum achievable.

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
```',
    'm == grid.length
n == grid[i].length
1 <= m, n <= 200
0 <= grid[i][j] <= 200'
);

------------------------------------------------------------
-- Add Longest Climb problem
-- CodeBite original name: Longest Climb (inspired by Longest Increasing Path in a Matrix, LC #329)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Longest Climb',
    'longest-climb',
    'Given an `m x n` matrix of integers, find the length of the longest strictly increasing path. From any cell, you may move up, down, left, or right to an adjacent cell, but only if the value in that cell is strictly greater than the current cell''s value. Return the length of the longest such path.

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
```',
    'HARD',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 200
0 <= matrix[i][j] <= 2^31 - 1',
    171,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[9,9,4],[6,6,8],[2,1,1]]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[3,4,5],[3,2,6],[2,2,1]]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1]]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,2,3],[8,9,4],[7,6,5]]', '9', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,2],[4,3]]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[7,8,9],[9,7,6],[7,2,3]]', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,1,1],[1,1,1],[1,1,1]]', '1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-climb'),
    'en',
    'Longest Climb',
    'Given an `m x n` matrix of integers, find the length of the longest strictly increasing path. From any cell, you may move up, down, left, or right to an adjacent cell, but only if the value in that cell is strictly greater than the current cell''s value. Return the length of the longest such path.

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
```',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 200
0 <= matrix[i][j] <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Hand Grouping problem
-- CodeBite original name: Hand Grouping (inspired by Hand of Straights LC #846)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Hand Grouping',
    'hand-grouping',
    'Given an integer array `hand` representing a collection of cards and an integer `groupSize`, determine whether the cards can be rearranged into groups where each group contains exactly `groupSize` **consecutive** integers.

Return `true` if such a rearrangement is possible, or `false` otherwise.

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
```',
    'MEDIUM',
    E'1 <= hand.length <= 10^4\n0 <= hand[i] <= 10^9\n1 <= groupSize <= hand.length',
    172,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,3,6,2,3,4,7,8]\n3', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,3,4,5]\n4', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[5,1]\n1', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1]\n1', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[3,3,3,3]\n1', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,3,4,5,6]\n2', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,1,2,2,3,3]\n3', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,4,5,6,7]\n3', 'false', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'hand-grouping'),
    'en',
    'Hand Grouping',
    'Given an integer array `hand` representing a collection of cards and an integer `groupSize`, determine whether the cards can be rearranged into groups where each group contains exactly `groupSize` **consecutive** integers.

Return `true` if such a rearrangement is possible, or `false` otherwise.

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
```',
    E'1 <= hand.length <= 10^4\n0 <= hand[i] <= 10^9\n1 <= groupSize <= hand.length'
);

------------------------------------------------------------
-- Add Label Splitter problem
-- CodeBite original name: Label Splitter (inspired by Partition Labels LC #763)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Label Splitter',
    'label-splitter',
    'Given a string `s` consisting of lowercase English letters, split it into as many segments as possible such that each character appears in **at most one** segment. The segments, when concatenated in order, must form the original string.

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
```',
    'MEDIUM',
    E'1 <= s.length <= 500\ns consists of lowercase English letters',
    173,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'abacbc', '[6]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'abcadefg', '[4,4]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'xyz', '[1,1,1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'ababcbacadefegdehijhklij', '[9,7,8]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'a', '[1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'aaaaaa', '[6]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'abcdefghij', '[1,1,1,1,1,1,1,1,1,1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'eccbbbbdec', '[10]', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'label-splitter'),
    'en',
    'Label Splitter',
    'Given a string `s` consisting of lowercase English letters, split it into as many segments as possible such that each character appears in **at most one** segment. The segments, when concatenated in order, must form the original string.

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
```',
    E'1 <= s.length <= 500\ns consists of lowercase English letters'
);

------------------------------------------------------------
-- Add Flexible Brackets problem
-- CodeBite original name: Flexible Brackets (inspired by Valid Parenthesis String LC #678)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Flexible Brackets',
    'flexible-brackets',
    'Given a string `s` containing only the characters `''(`'', `'')`'', and `''*`'', determine whether the string can represent a valid sequence of brackets.

The `''*`'' character is flexible -- it can be treated as a `''(`'', a `'')`'', or an empty string (removed entirely).

A valid bracket sequence is one where every opening bracket has a corresponding closing bracket in the correct order.

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
```',
    'MEDIUM',
    E'1 <= s.length <= 100\ns[i] is ''('', '')'', or ''*''',
    174,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(*))', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(**)', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), ')(', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '*', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), ')', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(*()', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(())((())()()(*)(*()(())())())()()((()())((()))(*', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '****', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '((*)', 'true', FALSE, 10);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flexible-brackets'),
    'en',
    'Flexible Brackets',
    'Given a string `s` containing only the characters `''(`'', `'')`'', and `''*`'', determine whether the string can represent a valid sequence of brackets.

The `''*`'' character is flexible -- it can be treated as a `''(`'', a `'')`'', or an empty string (removed entirely).

A valid bracket sequence is one where every opening bracket has a corresponding closing bracket in the correct order.

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
```',
    E'1 <= s.length <= 100\ns[i] is ''('', '')'', or ''*'''
);

------------------------------------------------------------
-- Add Triplet Former problem
-- CodeBite original name: Triplet Former (inspired by Merge Triplets to Form Target Triplet, LC #1899)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Triplet Former',
    'triplet-former',
    'You are given a list of triplets, where each triplet is an array of three integers `[a, b, c]`. You are also given a `target` triplet `[x, y, z]`.

To **form** the target, you may pick any number of triplets and repeatedly apply the following operation: choose a triplet and update your running result by taking the **maximum** value at each position.

In other words, if you select triplets `t1, t2, ..., tk`, the result would be `[max(t1[0], t2[0], ..., tk[0]), max(t1[1], t2[1], ..., tk[1]), max(t1[2], t2[2], ..., tk[2])]`.

Return `true` if it is possible to form the target triplet from the given list, or `false` otherwise.

**Note:** A triplet can only contribute to the result if none of its values exceed the corresponding value in the target. For example, `[2, 5, 3]` cannot be used when the target is `[2, 4, 5]` because `5 > 4` at position 1.

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
```',
    'MEDIUM',
    '1 <= triplets.length <= 10^5
triplets[i].length == 3
1 <= triplets[i][j], target[j] <= 1000',
    175,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[2,5,3],[1,8,4],[1,7,5]]\n[2,7,5]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[3,4,5],[4,5,6]]\n[3,2,5]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[2,5,3],[2,3,4],[1,2,5],[5,2,3]]\n[5,5,5]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,1,1]]\n[1,1,1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,2,3],[4,5,6],[7,8,9]]\n[7,8,9]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[3,5,1],[10,5,7]]\n[3,5,7]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,3,5],[2,1,5],[3,2,1]]\n[3,3,5]', 'true', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'triplet-former'),
    'en',
    'Triplet Former',
    'You are given a list of triplets, where each triplet is an array of three integers `[a, b, c]`. You are also given a `target` triplet `[x, y, z]`.

To **form** the target, you may pick any number of triplets and repeatedly apply the following operation: choose a triplet and update your running result by taking the **maximum** value at each position.

In other words, if you select triplets `t1, t2, ..., tk`, the result would be `[max(t1[0], t2[0], ..., tk[0]), max(t1[1], t2[1], ..., tk[1]), max(t1[2], t2[2], ..., tk[2])]`.

Return `true` if it is possible to form the target triplet from the given list, or `false` otherwise.

**Note:** A triplet can only contribute to the result if none of its values exceed the corresponding value in the target. For example, `[2, 5, 3]` cannot be used when the target is `[2, 4, 5]` because `5 > 4` at position 1.

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
```',
    '1 <= triplets.length <= 10^5
triplets[i].length == 3
1 <= triplets[i][j], target[j] <= 1000'
);

------------------------------------------------------------
-- Add Height Queue problem
-- CodeBite original name: Height Queue (inspired by Queue Reconstruction by Height, LC #406)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Height Queue',
    'height-queue',
    E'Given a list of people where each person is described by a pair `[h, k]`:\n- `h` is the person''s height\n- `k` is the number of people standing **in front** of this person who have a height **greater than or equal to** `h`\n\nThe people are given in no particular order. Reconstruct and return the queue so that every person''s `k` value is satisfied.\n\nIt is guaranteed that a valid arrangement always exists.\n\n**Example 1:**\n```\nInput: people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]\nOutput: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]\n```\n\n**Example 2:**\n```\nInput: people = [[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]\nOutput: [[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]\n```\n\n**Example 3:**\n```\nInput: people = [[3,0],[3,1]]\nOutput: [[3,0],[3,1]]\n```',
    'MEDIUM',
    E'1 <= people.length <= 2000\n0 <= h <= 10^6\n0 <= k < people.length\nA valid queue arrangement is guaranteed to exist.',
    176,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]', '[[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]', '[[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[3,0],[3,1]]', '[[3,0],[3,1]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[5,0]]', '[[5,0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[9,0],[7,0],[1,2],[3,1],[2,3],[5,1]]', '[[7,0],[3,1],[1,2],[5,1],[2,3],[9,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[2,0],[1,0],[3,0],[4,0]]', '[[1,0],[2,0],[3,0],[4,0]]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'height-queue'),
    'en',
    'Height Queue',
    E'Given a list of people where each person is described by a pair `[h, k]`:\n- `h` is the person''s height\n- `k` is the number of people standing **in front** of this person who have a height **greater than or equal to** `h`\n\nThe people are given in no particular order. Reconstruct and return the queue so that every person''s `k` value is satisfied.\n\nIt is guaranteed that a valid arrangement always exists.\n\n**Example 1:**\n```\nInput: people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]\nOutput: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]\n```\n\n**Example 2:**\n```\nInput: people = [[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]\nOutput: [[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]\n```\n\n**Example 3:**\n```\nInput: people = [[3,0],[3,1]]\nOutput: [[3,0],[3,1]]\n```',
    E'1 <= people.length <= 2000\n0 <= h <= 10^6\n0 <= k < people.length\nA valid queue arrangement is guaranteed to exist.'
);

------------------------------------------------------------
-- Add Almost Sorted problem
-- CodeBite original name: Almost Sorted (inspired by Non-decreasing Array, LC #665)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Almost Sorted',
    'almost-sorted',
    'Given an integer array `nums`, determine whether it is possible to make the array **non-decreasing** by changing **at most one** element.

An array is non-decreasing if `nums[i] <= nums[i + 1]` holds for every `0 <= i < nums.length - 1`.

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
```',
    'MEDIUM',
    '1 <= nums.length <= 10^4
-10^5 <= nums[i] <= 10^5',
    177,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[4,2,3]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[4,2,1]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[3,4,2,3]', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1,2,3,4,5]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[5,1,2,3,4]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[3,4,1,2]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1,1,1]', 'true', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'almost-sorted'),
    'en',
    'Almost Sorted',
    'Given an integer array `nums`, determine whether it is possible to make the array **non-decreasing** by changing **at most one** element.

An array is non-decreasing if `nums[i] <= nums[i + 1]` holds for every `0 <= i < nums.length - 1`.

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
```',
    '1 <= nums.length <= 10^4
-10^5 <= nums[i] <= 10^5'
);

