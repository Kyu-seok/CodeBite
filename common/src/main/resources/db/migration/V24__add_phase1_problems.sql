-- Phase 1: Add 38 new essential problems with CodeBite original names
-- All problems use original names/descriptions distinct from any third-party source.

------------------------------------------------------------
-- ARRAYS & HASHING
------------------------------------------------------------

-- Find Duplicates (LC#217 Contains Duplicate)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Find Duplicates',
    'find-duplicates',
    'Given an integer array `nums`, return `true` if any value appears at least twice in the array, and return `false` if every element is distinct.

**Example 1:**
```
Input: nums = [1,2,3,1]
Output: true
Explanation: The element 1 appears at index 0 and 3.
```

**Example 2:**
```
Input: nums = [1,2,3,4]
Output: false
Explanation: All elements are distinct.
```

**Example 3:**
```
Input: nums = [1,1,1,3,3,4,3,2,4,2]
Output: true
```',
    'EASY',
    '1 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1,2,3,1]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1,2,3,4]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1,1,1,3,3,4,3,2,4,2]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[0]', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1,2,3,4,5,6,7,8,9,1]', 'true', FALSE, 5);

-- Anagram Check (LC#242 Valid Anagram)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Anagram Check',
    'anagram-check',
    'Given two strings `s` and `t`, return `true` if `t` is an anagram of `s`, and `false` otherwise.

An anagram is a word formed by rearranging the letters of another word, using all the original letters exactly once.

**Example 1:**
```
Input: s = "anagram", t = "nagaram"
Output: true
```

**Example 2:**
```
Input: s = "rat", t = "car"
Output: false
```',
    'EASY',
    '1 <= s.length, t.length <= 5 * 10^4
s and t consist of lowercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), 'anagram
nagaram', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), 'rat
car', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), 'a
a', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), 'ab
ba', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), 'aacc
ccac', 'false', FALSE, 5);

-- K Most Frequent (LC#347 Top K Frequent Elements)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'K Most Frequent',
    'k-most-frequent',
    'Given an integer array `nums` and an integer `k`, return the `k` most frequent elements. You may return the answer in any order.

**Example 1:**
```
Input: nums = [1,1,1,2,2,3], k = 2
Output: [1,2]
```

**Example 2:**
```
Input: nums = [1], k = 1
Output: [1]
```',
    'MEDIUM',
    '1 <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4
k is in the range [1, the number of unique elements in the array].
It is guaranteed that the answer is unique.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), '[1,1,1,2,2,3]
2', '[1,2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), '[1]
1', '[1]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), '[4,1,-1,2,-1,2,3]
2', '[-1,2]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), '[1,2]
2', '[1,2]', FALSE, 4);

-- Array Product (LC#238 Product of Array Except Self)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Array Product',
    'array-product',
    'Given an integer array `nums`, return an array `answer` such that `answer[i]` is equal to the product of all the elements of `nums` except `nums[i]`.

The product of any prefix or suffix of `nums` is guaranteed to fit in a 32-bit integer.

You must write an algorithm that runs in O(n) time and without using the division operation.

**Example 1:**
```
Input: nums = [1,2,3,4]
Output: [24,12,8,6]
```

**Example 2:**
```
Input: nums = [-1,1,0,-3,3]
Output: [0,0,9,0,0]
```',
    'MEDIUM',
    '2 <= nums.length <= 10^5
-30 <= nums[i] <= 30
The product of any prefix or suffix of nums is guaranteed to fit in a 32-bit integer.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[1,2,3,4]', '[24,12,8,6]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[-1,1,0,-3,3]', '[0,0,9,0,0]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[2,3]', '[3,2]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[1,1,1,1]', '[1,1,1,1]', FALSE, 4);

-- Longest Streak (LC#128 Longest Consecutive Sequence)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Longest Streak',
    'longest-streak',
    'Given an unsorted array of integers `nums`, return the length of the longest consecutive elements sequence.

You must write an algorithm that runs in O(n) time.

**Example 1:**
```
Input: nums = [100,4,200,1,3,2]
Output: 4
Explanation: The longest consecutive elements sequence is [1, 2, 3, 4]. Therefore its length is 4.
```

**Example 2:**
```
Input: nums = [0,3,7,2,5,8,4,6,0,1]
Output: 9
```',
    'MEDIUM',
    '0 <= nums.length <= 10^5
-10^9 <= nums[i] <= 10^9',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[100,4,200,1,3,2]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[0,3,7,2,5,8,4,6,0,1]', '9', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[1,2,0,1]', '3', FALSE, 5);

-- String Codec (LC#271 Encode and Decode Strings)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'String Codec',
    'string-codec',
    'Design an algorithm to encode a list of strings to a single string. The encoded string is then decoded back to the original list of strings.

Implement the `encode` and `decode` methods:
- `encode(strs)` — Encodes a list of strings to a single string.
- `decode(s)` — Decodes a single string back to the original list of strings.

The algorithm should be stateless: the encoded string must contain all the information needed for decoding.

**Example 1:**
```
Input: strs = ["hello","world"]
Output: ["hello","world"]
Explanation: encode(["hello","world"]) produces some encoded string, and decode on that string returns the original list.
```

**Example 2:**
```
Input: strs = [""]
Output: [""]
```

**Example 3:**
```
Input: strs = ["","",""]
Output: ["","",""]
```',
    'MEDIUM',
    '0 <= strs.length <= 200
0 <= strs[i].length <= 200
strs[i] contains any possible characters including the delimiter characters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["hello","world"]', '["hello","world"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '[""]', '[""]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["","",""]', '["","",""]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["lint","code","love","you"]', '["lint","code","love","you"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '[]', '[]', FALSE, 5);

-- Sudoku Validator (LC#36 Valid Sudoku)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Sudoku Validator',
    'sudoku-validator',
    'Determine if a 9 x 9 Sudoku board is valid. Only the filled cells need to be validated according to the following rules:

1. Each row must contain the digits 1-9 without repetition.
2. Each column must contain the digits 1-9 without repetition.
3. Each of the nine 3 x 3 sub-boxes of the grid must contain the digits 1-9 without repetition.

Note:
- A Sudoku board (partially filled) could be valid but is not necessarily solvable.
- Only the filled cells need to be validated according to the mentioned rules.

**Example 1:**
```
Input: board =
[["5","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: true
```

**Example 2:**
```
Input: board =
[["8","3",".",".","7",".",".",".","."]
,["6",".",".","1","9","5",".",".","."]
,[".","9","8",".",".",".",".","6","."]
,["8",".",".",".","6",".",".",".","3"]
,["4",".",".","8",".","3",".",".","1"]
,["7",".",".",".","2",".",".",".","6"]
,[".","6",".",".",".",".","2","8","."]
,[".",".",".","4","1","9",".",".","5"]
,[".",".",".",".","8",".",".","7","9"]]
Output: false
Explanation: Same as Example 1, except with the 5 in the top left corner being modified to 8. Since there are two 8''s in the top left 3x3 sub-box, it is invalid.
```',
    'MEDIUM',
    'board.length == 9
board[i].length == 9
board[i][j] is a digit 1-9 or ''.''.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["8","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","9"]]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[[".",".",".",".","5",".",".","1","."],[".","4",".","3",".",".",".",".","."],[".",".",".",".",".","3",".",".","1"],["8",".",".",".",".",".",".","2","."],[".",".","2",".","7",".",".",".","."],[".","1","5",".",".",".",".",".","."],[".",".",".",".",".","2",".",".","."],[".","2",".","9",".",".",".",".","."],[".",".",".",".",".",".",".","3","."]]', 'true', FALSE, 3);

------------------------------------------------------------
-- TWO POINTERS
------------------------------------------------------------

-- Palindrome Checker (LC#125 Valid Palindrome)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Palindrome Checker',
    'palindrome-checker',
    'A phrase is a palindrome if, after converting all uppercase letters into lowercase letters and removing all non-alphanumeric characters, it reads the same forward and backward. Alphanumeric characters include letters and numbers.

Given a string `s`, return `true` if it is a palindrome, or `false` otherwise.

**Example 1:**
```
Input: s = "A man, a plan, a canal: Panama"
Output: true
Explanation: "amanaplanacanalpanama" is a palindrome.
```

**Example 2:**
```
Input: s = "race a car"
Output: false
Explanation: "raceacar" is not a palindrome.
```

**Example 3:**
```
Input: s = " "
Output: true
Explanation: s is an empty string "" after removing non-alphanumeric characters. Since an empty string reads the same forward and backward, it is a palindrome.
```',
    'EASY',
    '1 <= s.length <= 2 * 10^5
s consists only of printable ASCII characters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'A man, a plan, a canal: Panama', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'race a car', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), ' ', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), '0P', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'aa', 'true', FALSE, 5);

-- Sorted Pair Sum (LC#167 Two Sum II)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Sorted Pair Sum',
    'sorted-pair-sum',
    'Given a 1-indexed array of integers `numbers` that is already sorted in non-decreasing order, find two numbers such that they add up to a specific `target` number.

Return the indices of the two numbers (1-indexed) as an integer array `[index1, index2]` where `1 <= index1 < index2 <= numbers.length`.

You may not use the same element twice. Your solution must use only constant extra space.

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
```',
    'MEDIUM',
    '2 <= numbers.length <= 3 * 10^4
-1000 <= numbers[i] <= 1000
numbers is sorted in non-decreasing order.
-1000 <= target <= 1000
The tests are generated such that there is exactly one solution.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), '[2,7,11,15]
9', '[1,2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), '[2,3,4]
6', '[1,3]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), '[-1,0]
-1', '[1,2]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), '[1,2,3,4,4,9,56,90]
8', '[4,5]', FALSE, 4);

-- Water Container (LC#11 Container With Most Water)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Water Container',
    'water-container',
    'You are given an integer array `height` of length `n`. There are `n` vertical lines drawn such that the two endpoints of the `i`th line are `(i, 0)` and `(i, height[i])`.

Find two lines that together with the x-axis form a container, such that the container contains the most water.

Return the maximum amount of water a container can store.

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
```',
    'MEDIUM',
    'n == height.length
2 <= n <= 10^5
0 <= height[i] <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,8,6,2,5,4,8,3,7]', '49', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,1]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[4,3,2,1,4]', '16', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,2,1]', '2', FALSE, 4);

------------------------------------------------------------
-- SLIDING WINDOW
------------------------------------------------------------

-- Stock Profit (LC#121 Best Time to Buy and Sell Stock)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Stock Profit',
    'stock-profit',
    'You are given an array `prices` where `prices[i]` is the price of a given stock on the `i`th day.

You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.

Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return `0`.

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
```',
    'EASY',
    '1 <= prices.length <= 10^5
0 <= prices[i] <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[7,1,5,3,6,4]', '5', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[7,6,4,3,1]', '0', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[2,4,1]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[1]', '0', FALSE, 4);

-- Unique Substring (LC#3 Longest Substring Without Repeating Characters)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Unique Substring',
    'unique-substring',
    'Given a string `s`, find the length of the longest substring without repeating characters.

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
```',
    'MEDIUM',
    '0 <= s.length <= 5 * 10^4
s consists of English letters, digits, symbols and spaces.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'abcabcbb', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'bbbbb', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'pwwkew', '3', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), '', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'au', '2', FALSE, 5);

-- Character Swap (LC#424 Longest Repeating Character Replacement)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Character Swap',
    'character-swap',
    'You are given a string `s` and an integer `k`. You can choose any character of the string and change it to any other uppercase English letter. You can perform this operation at most `k` times.

Return the length of the longest substring containing the same letter you can get after performing the above operations.

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
```',
    'MEDIUM',
    '1 <= s.length <= 10^5
s consists of only uppercase English letters.
0 <= k <= s.length',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'character-swap'), 'ABAB
2', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), 'AABABBA
1', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), 'AAAA
0', '4', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), 'ABCD
2', '3', FALSE, 4);

-- Smallest Window (LC#76 Minimum Window Substring)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Smallest Window',
    'smallest-window',
    'Given two strings `s` and `t` of lengths `m` and `n` respectively, return the minimum window substring of `s` such that every character in `t` (including duplicates) is included in the window. If there is no such substring, return the empty string `""`.

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
```',
    'HARD',
    'm == s.length
n == t.length
1 <= m, n <= 10^5
s and t consist of uppercase and lowercase English letters.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), 'ADOBECODEBANC
ABC', 'BANC', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), 'a
a', 'a', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), 'a
aa', '', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), 'ab
b', 'b', FALSE, 4);

------------------------------------------------------------
-- STACK
------------------------------------------------------------

-- Minimum Stack (LC#155 Min Stack)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Minimum Stack',
    'minimum-stack',
    'Design a stack that supports push, pop, top, and retrieving the minimum element in constant time.

Implement the `MinStack` class:
- `MinStack()` initializes the stack object.
- `void push(int val)` pushes the element `val` onto the stack.
- `void pop()` removes the element on the top of the stack.
- `int top()` gets the top element of the stack.
- `int getMin()` retrieves the minimum element in the stack.

You must implement a solution with O(1) time complexity for each function.

**Example 1:**
```
Input:
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]
Output: [null,null,null,null,-3,null,0,-2]
```',
    'MEDIUM',
    '-2^31 <= val <= 2^31 - 1
Methods pop, top and getMin operations will always be called on non-empty stacks.
At most 3 * 10^4 calls will be made to push, pop, top, and getMin.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), '["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]', '[null,null,null,null,-3,null,0,-2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), '["MinStack","push","push","getMin","top","pop","getMin"]
[[],[1],[2],[],[],[],[]]', '[null,null,null,1,2,null,1]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), '["MinStack","push","push","push","top","getMin","pop","getMin"]
[[],[3],[1],[2],[],[],[],[]]', '[null,null,null,null,2,1,null,1]', FALSE, 3);

------------------------------------------------------------
-- BINARY SEARCH
------------------------------------------------------------

-- Basic Binary Search (LC#704 Binary Search)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Basic Binary Search',
    'basic-binary-search',
    'Given an array of integers `nums` which is sorted in ascending order, and an integer `target`, write a function to search `target` in `nums`. If `target` exists, then return its index. Otherwise, return `-1`.

You must write an algorithm with O(log n) runtime complexity.

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
```',
    'EASY',
    '1 <= nums.length <= 10^4
-10^4 < nums[i], target < 10^4
All the integers in nums are unique.
nums is sorted in ascending order.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), '[-1,0,3,5,9,12]
9', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), '[-1,0,3,5,9,12]
2', '-1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), '[5]
5', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), '[1,2,3,4,5]
1', '0', FALSE, 4);

-- Matrix Search (LC#74 Search a 2D Matrix)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Matrix Search',
    'matrix-search',
    'You are given an `m x n` integer matrix with the following two properties:
- Each row is sorted in non-decreasing order.
- The first integer of each row is greater than the last integer of the previous row.

Given an integer `target`, return `true` if `target` is in the matrix or `false` otherwise.

You must write a solution in O(log(m * n)) time complexity.

**Example 1:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 3
Output: true
```

**Example 2:**
```
Input: matrix = [[1,3,5,7],[10,11,16,20],[23,30,34,60]], target = 13
Output: false
```',
    'MEDIUM',
    'm == matrix.length
n == matrix[i].length
1 <= m, n <= 100
-10^4 <= matrix[i][j], target <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), '[[1,3,5,7],[10,11,16,20],[23,30,34,60]]
3', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), '[[1,3,5,7],[10,11,16,20],[23,30,34,60]]
13', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), '[[1]]
1', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), '[[1,3]]
3', 'true', FALSE, 4);

-- Rotated Array Min (LC#153 Find Minimum in Rotated Sorted Array)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Rotated Array Min',
    'rotated-array-min',
    'Suppose an array of length `n` sorted in ascending order is rotated between `1` and `n` times. For example, the array `nums = [0,1,2,4,5,6,7]` might become `[4,5,6,7,0,1,2]` after rotating 4 times.

Given the sorted rotated array `nums` of unique elements, return the minimum element of this array.

You must write an algorithm that runs in O(log n) time.

**Example 1:**
```
Input: nums = [3,4,5,1,2]
Output: 1
Explanation: The original array was [1,2,3,4,5] rotated 3 times.
```

**Example 2:**
```
Input: nums = [4,5,6,7,0,1,2]
Output: 0
```

**Example 3:**
```
Input: nums = [11,13,15,17]
Output: 11
Explanation: The original array was not rotated.
```',
    'MEDIUM',
    'n == nums.length
1 <= n <= 5000
-5000 <= nums[i] <= 5000
All the integers of nums are unique.
nums is sorted and rotated between 1 and n times.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[3,4,5,1,2]', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[4,5,6,7,0,1,2]', '0', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[11,13,15,17]', '11', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[2,1]', '1', FALSE, 4);

------------------------------------------------------------
-- LINKED LIST
------------------------------------------------------------

-- Merge Sorted Lists (LC#21 Merge Two Sorted Lists)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Merge Sorted Lists',
    'merge-sorted-lists',
    'You are given the heads of two sorted linked lists `list1` and `list2`.

Merge the two lists into one sorted list. The list should be made by splicing together the nodes of the first two lists.

Return the head of the merged linked list.

**Example 1:**
```
Input: list1 = [1,2,4], list2 = [1,3,4]
Output: [1,1,2,3,4,4]
```

**Example 2:**
```
Input: list1 = [], list2 = []
Output: []
```

**Example 3:**
```
Input: list1 = [], list2 = [0]
Output: [0]
```',
    'EASY',
    'The number of nodes in both lists is in the range [0, 50].
-100 <= Node.val <= 100
Both list1 and list2 are sorted in non-decreasing order.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), '[1,2,4]
[1,3,4]', '[1,1,2,3,4,4]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), '[]
[]', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), '[]
[0]', '[0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), '[1]
[2]', '[1,2]', FALSE, 4);

-- Cycle Detection (LC#141 Linked List Cycle)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Cycle Detection',
    'cycle-detection',
    'Given `head`, the head of a linked list, determine if the linked list has a cycle in it.

There is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the `next` pointer. Internally, `pos` is used to denote the index of the node that tail''s `next` pointer is connected to. Note that `pos` is not passed as a parameter.

Return `true` if there is a cycle in the linked list. Otherwise, return `false`.

**Example 1:**
```
Input: head = [3,2,0,-4], pos = 1
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 1st node (0-indexed).
```

**Example 2:**
```
Input: head = [1,2], pos = 0
Output: true
Explanation: There is a cycle in the linked list, where the tail connects to the 0th node.
```

**Example 3:**
```
Input: head = [1], pos = -1
Output: false
Explanation: There is no cycle in the linked list.
```',
    'EASY',
    'The number of the nodes in the list is in the range [0, 10^4].
-10^5 <= Node.val <= 10^5
pos is -1 or a valid index in the linked-list.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), '[3,2,0,-4]
1', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), '[1,2]
0', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), '[1]
-1', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), '[]
-1', 'false', FALSE, 4);

-- Remove From End (LC#19 Remove Nth Node From End of List)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Remove From End',
    'remove-from-end',
    'Given the `head` of a linked list, remove the `n`th node from the end of the list and return its head.

**Example 1:**
```
Input: head = [1,2,3,4,5], n = 2
Output: [1,2,3,5]
```

**Example 2:**
```
Input: head = [1], n = 1
Output: []
```

**Example 3:**
```
Input: head = [1,2], n = 1
Output: [1]
```',
    'MEDIUM',
    'The number of nodes in the list is sz.
1 <= sz <= 30
0 <= Node.val <= 100
1 <= n <= sz',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), '[1,2,3,4,5]
2', '[1,2,3,5]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), '[1]
1', '[]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), '[1,2]
1', '[1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'remove-from-end'), '[1,2]
2', '[2]', FALSE, 4);

------------------------------------------------------------
-- TREES
------------------------------------------------------------

-- Tree Depth (LC#104 Maximum Depth of Binary Tree)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Tree Depth',
    'tree-depth',
    'Given the `root` of a binary tree, return its maximum depth.

A binary tree''s maximum depth is the number of nodes along the longest path from the root node down to the farthest leaf node.

**Example 1:**
```
Input: root = [3,9,20,null,null,15,7]
Output: 3
```

**Example 2:**
```
Input: root = [1,null,2]
Output: 2
```',
    'EASY',
    'The number of nodes in the tree is in the range [0, 10^4].
-100 <= Node.val <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[3,9,20,null,null,15,7]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,null,2]', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[0]', '1', FALSE, 4);

-- Identical Trees (LC#100 Same Tree)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Identical Trees',
    'identical-trees',
    'Given the roots of two binary trees `p` and `q`, write a function to check if they are the same or not.

Two binary trees are considered the same if they are structurally identical, and the nodes have the same value.

**Example 1:**
```
Input: p = [1,2,3], q = [1,2,3]
Output: true
```

**Example 2:**
```
Input: p = [1,2], q = [1,null,2]
Output: false
```

**Example 3:**
```
Input: p = [1,2,1], q = [1,1,2]
Output: false
```',
    'EASY',
    'The number of nodes in both trees is in the range [0, 100].
-10^4 <= Node.val <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), '[1,2,3]
[1,2,3]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), '[1,2]
[1,null,2]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), '[1,2,1]
[1,1,2]', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), '[]
[]', 'true', FALSE, 4);

-- Tree Within Tree (LC#572 Subtree of Another Tree)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Tree Within Tree',
    'tree-within-tree',
    'Given the roots of two binary trees `root` and `subRoot`, return `true` if there is a subtree of `root` with the same structure and node values of `subRoot` and `false` otherwise.

A subtree of a binary tree `tree` is a tree that consists of a node in `tree` and all of this node''s descendants. The tree `tree` could also be considered as a subtree of itself.

**Example 1:**
```
Input: root = [3,4,5,1,2], subRoot = [4,1,2]
Output: true
```

**Example 2:**
```
Input: root = [3,4,5,1,2,null,null,null,null,0], subRoot = [4,1,2]
Output: false
```',
    'EASY',
    'The number of nodes in the root tree is in the range [1, 2000].
The number of nodes in the subRoot tree is in the range [1, 1000].
-10^4 <= root.val <= 10^4
-10^4 <= subRoot.val <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), '[3,4,5,1,2]
[4,1,2]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), '[3,4,5,1,2,null,null,null,null,0]
[4,1,2]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), '[1,1]
[1]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), '[1]
[1]', 'true', FALSE, 4);

-- BST Validator (LC#98 Validate Binary Search Tree)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'BST Validator',
    'bst-validator',
    'Given the `root` of a binary tree, determine if it is a valid binary search tree (BST).

A valid BST is defined as follows:
- The left subtree of a node contains only nodes with keys less than the node''s key.
- The right subtree of a node contains only nodes with keys greater than the node''s key.
- Both the left and right subtrees must also be binary search trees.

**Example 1:**
```
Input: root = [2,1,3]
Output: true
```

**Example 2:**
```
Input: root = [5,1,4,null,null,3,6]
Output: false
Explanation: The root node''s value is 5 but its right child''s value is 4.
```',
    'MEDIUM',
    'The number of nodes in the tree is in the range [1, 10^4].
-2^31 <= Node.val <= 2^31 - 1',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[2,1,3]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[5,1,4,null,null,3,6]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[1]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[5,4,6,null,null,3,7]', 'false', FALSE, 4);

-- BST Ancestor (LC#235 Lowest Common Ancestor of a BST)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'BST Ancestor',
    'bst-ancestor',
    'Given a binary search tree (BST), find the lowest common ancestor (LCA) node of two given nodes in the BST.

The lowest common ancestor is defined between two nodes `p` and `q` as the lowest node in the tree that has both `p` and `q` as descendants (where we allow a node to be a descendant of itself).

**Example 1:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 8
Output: 6
Explanation: The LCA of nodes 2 and 8 is 6.
```

**Example 2:**
```
Input: root = [6,2,8,0,4,7,9,null,null,3,5], p = 2, q = 4
Output: 2
Explanation: The LCA of nodes 2 and 4 is 2, since a node can be a descendant of itself.
```

**Example 3:**
```
Input: root = [2,1], p = 2, q = 1
Output: 2
```',
    'MEDIUM',
    'The number of nodes in the tree is in the range [2, 10^5].
-10^9 <= Node.val <= 10^9
All Node.val are unique.
p != q
p and q will exist in the BST.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), '[6,2,8,0,4,7,9,null,null,3,5]
2
8', '6', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), '[6,2,8,0,4,7,9,null,null,3,5]
2
4', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), '[2,1]
2
1', '2', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), '[6,2,8,0,4,7,9,null,null,3,5]
3
5', '4', FALSE, 4);

------------------------------------------------------------
-- GRAPHS
------------------------------------------------------------

-- Island Counter (LC#200 Number of Islands)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Island Counter',
    'island-counter',
    'Given an `m x n` 2D binary grid `grid` which represents a map of ''1''s (land) and ''0''s (water), return the number of islands.

An island is surrounded by water and is formed by connecting adjacent lands horizontally or vertically. You may assume all four edges of the grid are all surrounded by water.

**Example 1:**
```
Input: grid = [
  ["1","1","1","1","0"],
  ["1","1","0","1","0"],
  ["1","1","0","0","0"],
  ["0","0","0","0","0"]
]
Output: 1
```

**Example 2:**
```
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
```',
    'MEDIUM',
    'm == grid.length
n == grid[i].length
1 <= m, n <= 300
grid[i][j] is ''0'' or ''1''.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","1","1","1","0"],["1","1","0","1","0"],["1","1","0","0","0"],["0","0","0","0","0"]]', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","1","0","0","0"],["1","1","0","0","0"],["0","0","1","0","0"],["0","0","0","1","1"]]', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1"]]', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["0","0"],["0","0"]]', '0', FALSE, 4);

-- Course Planner (LC#207 Course Schedule)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Course Planner',
    'course-planner',
    'There are a total of `numCourses` courses you have to take, labeled from `0` to `numCourses - 1`. You are given an array `prerequisites` where `prerequisites[i] = [a_i, b_i]` indicates that you must take course `b_i` first if you want to take course `a_i`.

Return `true` if you can finish all courses. Otherwise, return `false`.

**Example 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: true
Explanation: There are 2 courses to take. To take course 1 you should have finished course 0. So it is possible.
```

**Example 2:**
```
Input: numCourses = 2, prerequisites = [[1,0],[0,1]]
Output: false
Explanation: There are 2 courses to take. To take course 1 you should have finished course 0, and to take course 0 you should also have finished course 1. So it is impossible.
```',
    'MEDIUM',
    '1 <= numCourses <= 2000
0 <= prerequisites.length <= 5000
prerequisites[i].length == 2
0 <= a_i, b_i < numCourses
All the pairs prerequisites[i] are unique.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'course-planner'), '2
[[1,0]]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), '2
[[1,0],[0,1]]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), '1
[]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), '5
[[1,4],[2,4],[3,1],[3,2]]', 'true', FALSE, 4);

------------------------------------------------------------
-- 1D DYNAMIC PROGRAMMING
------------------------------------------------------------

-- Staircase (LC#70 Climbing Stairs)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Staircase',
    'staircase',
    'You are climbing a staircase. It takes `n` steps to reach the top.

Each time you can either climb 1 or 2 steps. In how many distinct ways can you climb to the top?

**Example 1:**
```
Input: n = 2
Output: 2
Explanation: There are two ways to climb to the top.
1. 1 step + 1 step
2. 2 steps
```

**Example 2:**
```
Input: n = 3
Output: 3
Explanation: There are three ways to climb to the top.
1. 1 step + 1 step + 1 step
2. 1 step + 2 steps
3. 2 steps + 1 step
```',
    'EASY',
    '1 <= n <= 45',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'staircase'), '2', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '3', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '1', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '5', '8', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '10', '89', FALSE, 5);

-- House Thief (LC#198 House Robber)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'House Thief',
    'house-thief',
    'You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security systems connected and it will automatically contact the police if two adjacent houses were broken into on the same night.

Given an integer array `nums` representing the amount of money of each house, return the maximum amount of money you can rob tonight without alerting the police.

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
```',
    'MEDIUM',
    '1 <= nums.length <= 100
0 <= nums[i] <= 400',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[1,2,3,1]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[2,7,9,3,1]', '12', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[0]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[2,1,1,2]', '4', FALSE, 4);

-- Coin Picker (LC#322 Coin Change)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Coin Picker',
    'coin-picker',
    'You are given an integer array `coins` representing coins of different denominations and an integer `amount` representing a total amount of money.

Return the fewest number of coins that you need to make up that amount. If that amount of money cannot be made up by any combination of the coins, return `-1`.

You may assume that you have an infinite number of each kind of coin.

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
```

**Example 3:**
```
Input: coins = [1], amount = 0
Output: 0
```',
    'MEDIUM',
    '1 <= coins.length <= 12
1 <= coins[i] <= 2^31 - 1
0 <= amount <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), '[1,5,10]
12', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), '[2]
3', '-1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), '[1]
0', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), '[1,2,5]
11', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), '[186,419,83,408]
6249', '20', FALSE, 5);

-- Longest Ascending (LC#300 Longest Increasing Subsequence)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Longest Ascending',
    'longest-ascending',
    'Given an integer array `nums`, return the length of the longest strictly increasing subsequence.

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
```',
    'MEDIUM',
    '1 <= nums.length <= 2500
-10^4 <= nums[i] <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[10,9,2,5,3,7,101,18]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[0,1,0,3,2,3]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[7,7,7,7,7,7,7]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[1]', '1', FALSE, 4);

-- Word Segmentation (LC#139 Word Break)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Word Segmentation',
    'word-segmentation',
    'Given a string `s` and a dictionary of strings `wordDict`, return `true` if `s` can be segmented into a space-separated sequence of one or more dictionary words.

Note that the same word in the dictionary may be reused multiple times in the segmentation.

**Example 1:**
```
Input: s = "codebite", wordDict = ["code","bite"]
Output: true
Explanation: Return true because "codebite" can be segmented as "code bite".
```

**Example 2:**
```
Input: s = "applepenapple", wordDict = ["apple","pen"]
Output: true
Explanation: Return true because "applepenapple" can be segmented as "apple pen apple". Note that you are allowed to reuse a dictionary word.
```

**Example 3:**
```
Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
Output: false
```',
    'MEDIUM',
    '1 <= s.length <= 300
1 <= wordDict.length <= 1000
1 <= wordDict[i].length <= 20
s and wordDict[i] consist of only lowercase English letters.
All the strings of wordDict are unique.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), 'codebite
["code","bite"]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), 'applepenapple
["apple","pen"]', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), 'catsandog
["cats","dog","sand","and","cat"]', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), 'a
["a"]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), 'bb
["a","b","bbb","bbbb"]', 'true', FALSE, 5);

------------------------------------------------------------
-- GREEDY
------------------------------------------------------------

-- Largest Subarray (LC#53 Maximum Subarray)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Largest Subarray',
    'largest-subarray',
    'Given an integer array `nums`, find the subarray with the largest sum, and return its sum.

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
```',
    'MEDIUM',
    '1 <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-2,1,-3,4,-1,2,1,-5,4]', '6', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[1]', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[5,4,-1,7,8]', '23', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-1]', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-2,-1]', '-1', FALSE, 5);

-- Reach the End (LC#55 Jump Game)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Reach the End',
    'reach-the-end',
    'You are given an integer array `nums`. You are initially positioned at the array''s first index, and each element in the array represents your maximum jump length at that position.

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
```',
    'MEDIUM',
    '1 <= nums.length <= 10^4
0 <= nums[i] <= 10^5',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[2,3,1,1,4]', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[3,2,1,0,4]', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[0]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[2,0,0]', 'true', FALSE, 4);

------------------------------------------------------------
-- MATH & GEOMETRY
------------------------------------------------------------

-- Rotate Grid (LC#48 Rotate Image)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Rotate Grid',
    'rotate-grid',
    'You are given an `n x n` 2D `matrix` representing an image, rotate the image by 90 degrees (clockwise).

You have to rotate the image in-place, which means you have to modify the input 2D matrix directly. DO NOT allocate another 2D matrix and do the rotation.

**Example 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**Example 2:**
```
Input: matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
Output: [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```',
    'MEDIUM',
    'n == matrix.length == matrix[i].length
1 <= n <= 20
-1000 <= matrix[i][j] <= 1000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1,2,3],[4,5,6],[7,8,9]]', '[[7,4,1],[8,5,2],[9,6,3]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]', '[[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1]]', '[[1]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1,2],[3,4]]', '[[3,1],[4,2]]', FALSE, 4);

------------------------------------------------------------
-- BIT MANIPULATION
------------------------------------------------------------

-- Lone Element (LC#136 Single Number)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Lone Element',
    'lone-element',
    'Given a non-empty array of integers `nums`, every element appears twice except for one. Find that single one.

You must implement a solution with a linear runtime complexity and use only constant extra space.

**Example 1:**
```
Input: nums = [2,2,1]
Output: 1
```

**Example 2:**
```
Input: nums = [4,1,2,1,2]
Output: 4
```

**Example 3:**
```
Input: nums = [1]
Output: 1
```',
    'EASY',
    '1 <= nums.length <= 3 * 10^4
-3 * 10^4 <= nums[i] <= 3 * 10^4
Each element in the array appears twice except for one element which appears only once.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[2,2,1]', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[4,1,2,1,2]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[1]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[-1,1,1]', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[0,1,0]', '1', FALSE, 5);
