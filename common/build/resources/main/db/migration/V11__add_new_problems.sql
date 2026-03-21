-- Problem: Sqrt(x) — integer output
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Sqrt(x)',
    'sqrtx',
    'Given a non-negative integer `x`, return the square root of `x` rounded down to the nearest integer. The returned integer should be non-negative as well.

You must not use any built-in exponent function or operator.

**Example 1:**
```
Input: x = 4
Output: 2
Explanation: The square root of 4 is 2, so we return 2.
```

**Example 2:**
```
Input: x = 8
Output: 2
Explanation: The square root of 8 is 2.82842..., and since we round it down to the nearest integer, 2 is returned.
```',
    'EASY',
    '0 <= x <= 2^31 - 1',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sqrtx'), '4', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'sqrtx'), '8', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'sqrtx'), '0', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'sqrtx'), '1', '1', FALSE, 4);

-- Problem: Reverse Words in a String — string output
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Reverse Words in a String',
    'reverse-words-in-a-string',
    'Given an input string `s`, reverse the order of the words.

A word is defined as a sequence of non-space characters. The words in `s` will be separated by at least one space.

Return a string of the words in reverse order concatenated by a single space.

Note that `s` may contain leading or trailing spaces or multiple spaces between two words. The returned string should only have a single space separating the words. Do not include any extra spaces.

**Example 1:**
```
Input: s = "the sky is blue"
Output: "blue is sky the"
```

**Example 2:**
```
Input: s = "  hello world  "
Output: "world hello"
Explanation: Your reversed string should not contain leading or trailing spaces.
```

**Example 3:**
```
Input: s = "a good   example"
Output: "example good a"
Explanation: You need to reduce multiple spaces between two words to a single space in the reversed string.
```',
    'MEDIUM',
    '1 <= s.length <= 10^4
s contains English letters (upper-case and lower-case), digits, and spaces '' ''.
There is at least one word in s.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reverse-words-in-a-string'), 'the sky is blue', 'blue is sky the', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'reverse-words-in-a-string'), '  hello world  ', 'world hello', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'reverse-words-in-a-string'), 'a good   example', 'example good a', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'reverse-words-in-a-string'), 'Alice does not even like bob', 'bob like even not does Alice', FALSE, 4);

-- Problem: Plus One — integer array output
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Plus One',
    'plus-one',
    'You are given a large integer represented as an integer array `digits`, where each `digits[i]` is the ith digit of the integer. The digits are ordered from most significant to least significant in left-to-right order. The large integer does not contain any leading 0''s.

Increment the large integer by one and return the resulting array of digits.

**Example 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: The array represents the integer 123. Incrementing by one gives 123 + 1 = 124. Thus, the result should be [1,2,4].
```

**Example 2:**
```
Input: digits = [4,3,2,1]
Output: [4,3,2,2]
Explanation: The array represents the integer 4321. Incrementing by one gives 4321 + 1 = 4322. Thus, the result should be [4,3,2,2].
```

**Example 3:**
```
Input: digits = [9]
Output: [1,0]
Explanation: The array represents the integer 9. Incrementing by one gives 9 + 1 = 10. Thus, the result should be [1,0].
```',
    'EASY',
    '1 <= digits.length <= 100
0 <= digits[i] <= 9
digits does not contain any leading 0''s.',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'plus-one'), '[1,2,3]', '[1,2,4]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'plus-one'), '[4,3,2,1]', '[4,3,2,2]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'plus-one'), '[9]', '[1,0]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'plus-one'), '[9,9,9]', '[1,0,0,0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'plus-one'), '[0]', '[1]', FALSE, 5);

-- Problem: Pascal's Triangle — 2D integer array output
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Pascal''s Triangle',
    'pascals-triangle',
    'Given an integer `numRows`, return the first `numRows` of Pascal''s triangle.

In Pascal''s triangle, each number is the sum of the two numbers directly above it.

**Example 1:**
```
Input: numRows = 5
Output: [[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]
```

**Example 2:**
```
Input: numRows = 1
Output: [[1]]
```',
    'EASY',
    '1 <= numRows <= 30',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'pascals-triangle'), '5', '[[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'pascals-triangle'), '1', '[[1]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'pascals-triangle'), '3', '[[1],[1,1],[1,2,1]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'pascals-triangle'), '6', '[[1],[1,1],[1,2,1],[1,3,3,1],[1,4,6,4,1],[1,5,10,10,5,1]]', FALSE, 4);

-- Problem: Reverse Linked List — linked list output (serialized as array)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Reverse Linked List',
    'reverse-linked-list',
    'Given the `head` of a singly linked list, reverse the list, and return the reversed list.

**Example 1:**
```
Input: head = [1,2,3,4,5]
Output: [5,4,3,2,1]
```

**Example 2:**
```
Input: head = [1,2]
Output: [2,1]
```

**Example 3:**
```
Input: head = []
Output: []
```',
    'EASY',
    'The number of nodes in the list is the range [0, 5000].
-5000 <= Node.val <= 5000',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reverse-linked-list'), '[1,2,3,4,5]', '[5,4,3,2,1]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'reverse-linked-list'), '[1,2]', '[2,1]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'reverse-linked-list'), '[]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'reverse-linked-list'), '[1]', '[1]', FALSE, 4);

-- Problem: Invert Binary Tree — binary tree output (serialized as level-order array)
INSERT INTO problems (title, slug, description, difficulty, constraints, is_published)
VALUES (
    'Invert Binary Tree',
    'invert-binary-tree',
    'Given the `root` of a binary tree, invert the tree, and return its root.

**Example 1:**
```
Input: root = [4,2,7,1,3,6,9]
Output: [4,7,2,9,6,3,1]
```

**Example 2:**
```
Input: root = [2,1,3]
Output: [2,3,1]
```

**Example 3:**
```
Input: root = []
Output: []
```',
    'EASY',
    'The number of nodes in the tree is in the range [0, 100].
-100 <= Node.val <= 100',
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'invert-binary-tree'), '[4,2,7,1,3,6,9]', '[4,7,2,9,6,3,1]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'invert-binary-tree'), '[2,1,3]', '[2,3,1]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'invert-binary-tree'), '[]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'invert-binary-tree'), '[1]', '[1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'invert-binary-tree'), '[1,2]', '[1,null,2]', FALSE, 5);
