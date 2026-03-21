-- Problem 1: Two Sum
INSERT INTO problems (title, slug, description, difficulty, starter_code, constraints, is_published)
VALUES (
    'Two Sum',
    'two-sum',
    'Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.

**Example 1:**
```
Input: nums = [2,7,11,15], target = 9
Output: [0,1]
Explanation: Because nums[0] + nums[1] == 9, we return [0, 1].
```

**Example 2:**
```
Input: nums = [3,2,4], target = 6
Output: [1,2]
```',
    'EASY',
    '{"java": "class Solution {\n    public int[] twoSum(int[] nums, int target) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def twoSum(self, nums: list[int], target: int) -> list[int]:\n        # Write your solution here\n        pass"}',
    '2 <= nums.length <= 10^4\n-10^9 <= nums[i] <= 10^9\n-10^9 <= target <= 10^9\nOnly one valid answer exists.',
    TRUE
);

-- Problem 2: FizzBuzz
INSERT INTO problems (title, slug, description, difficulty, starter_code, constraints, is_published)
VALUES (
    'FizzBuzz',
    'fizzbuzz',
    'Given an integer `n`, return a string array `answer` (1-indexed) where:

- `answer[i] == "FizzBuzz"` if `i` is divisible by 3 and 5.
- `answer[i] == "Fizz"` if `i` is divisible by 3.
- `answer[i] == "Buzz"` if `i` is divisible by 5.
- `answer[i] == i` (as a string) if none of the above conditions are true.

**Example:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```',
    'EASY',
    '{"java": "class Solution {\n    public List<String> fizzBuzz(int n) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def fizzBuzz(self, n: int) -> list[str]:\n        # Write your solution here\n        pass"}',
    '1 <= n <= 10^4',
    TRUE
);

-- Problem 3: Reverse String
INSERT INTO problems (title, slug, description, difficulty, starter_code, constraints, is_published)
VALUES (
    'Reverse String',
    'reverse-string',
    'Write a function that reverses a string. The input string is given as an array of characters `s`.

You must do this by modifying the input array in-place with O(1) extra memory.

**Example 1:**
```
Input: s = ["h","e","l","l","o"]
Output: ["o","l","l","e","h"]
```

**Example 2:**
```
Input: s = ["H","a","n","n","a","h"]
Output: ["h","a","n","n","a","H"]
```',
    'EASY',
    '{"java": "class Solution {\n    public void reverseString(char[] s) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def reverseString(self, s: list[str]) -> None:\n        # Write your solution here\n        pass"}',
    '1 <= s.length <= 10^5\ns[i] is a printable ASCII character.',
    TRUE
);

-- Problem 4: Valid Parentheses
INSERT INTO problems (title, slug, description, difficulty, starter_code, constraints, is_published)
VALUES (
    'Valid Parentheses',
    'valid-parentheses',
    'Given a string `s` containing just the characters `(`, `)`, `{`, `}`, `[` and `]`, determine if the input string is valid.

An input string is valid if:
1. Open brackets must be closed by the same type of brackets.
2. Open brackets must be closed in the correct order.
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
```',
    'EASY',
    '{"java": "class Solution {\n    public boolean isValid(String s) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def isValid(self, s: str) -> bool:\n        # Write your solution here\n        pass"}',
    '1 <= s.length <= 10^4\ns consists of parentheses only ''()[]{}''.',
    TRUE
);

-- Problem 5: Palindrome Number
INSERT INTO problems (title, slug, description, difficulty, starter_code, constraints, is_published)
VALUES (
    'Palindrome Number',
    'palindrome-number',
    'Given an integer `x`, return `true` if `x` is a palindrome, and `false` otherwise.

An integer is a palindrome when it reads the same forward and backward.

**Example 1:**
```
Input: x = 121
Output: true
Explanation: 121 reads as 121 from left to right and from right to left.
```

**Example 2:**
```
Input: x = -121
Output: false
Explanation: From left to right, it reads -121. From right to left it becomes 121-. Therefore it is not a palindrome.
```',
    'EASY',
    '{"java": "class Solution {\n    public boolean isPalindrome(int x) {\n        // Write your solution here\n    }\n}", "python": "class Solution:\n    def isPalindrome(self, x: int) -> bool:\n        # Write your solution here\n        pass"}',
    '-2^31 <= x <= 2^31 - 1',
    TRUE
);

-- Test cases for Two Sum
INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    (1, '{"nums": [2,7,11,15], "target": 9}', '[0,1]', TRUE, 1),
    (1, '{"nums": [3,2,4], "target": 6}', '[1,2]', TRUE, 2),
    (1, '{"nums": [3,3], "target": 6}', '[0,1]', FALSE, 3),
    (1, '{"nums": [1,5,3,7,2], "target": 9}', '[1,4]', FALSE, 4);

-- Test cases for FizzBuzz
INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    (2, '{"n": 5}', '["1","2","Fizz","4","Buzz"]', TRUE, 1),
    (2, '{"n": 15}', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]', TRUE, 2),
    (2, '{"n": 1}', '["1"]', FALSE, 3);

-- Test cases for Reverse String
INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    (3, '{"s": ["h","e","l","l","o"]}', '["o","l","l","e","h"]', TRUE, 1),
    (3, '{"s": ["H","a","n","n","a","h"]}', '["h","a","n","n","a","H"]', TRUE, 2),
    (3, '{"s": ["a"]}', '["a"]', FALSE, 3);

-- Test cases for Valid Parentheses
INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    (4, '{"s": "()"}', 'true', TRUE, 1),
    (4, '{"s": "()[]{}"}', 'true', TRUE, 2),
    (4, '{"s": "(]"}', 'false', TRUE, 3),
    (4, '{"s": "([{}])"}', 'true', FALSE, 4),
    (4, '{"s": "(("}', 'false', FALSE, 5);

-- Test cases for Palindrome Number
INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    (5, '{"x": 121}', 'true', TRUE, 1),
    (5, '{"x": -121}', 'false', TRUE, 2),
    (5, '{"x": 10}', 'false', TRUE, 3),
    (5, '{"x": 0}', 'true', FALSE, 4),
    (5, '{"x": 12321}', 'true', FALSE, 5);
