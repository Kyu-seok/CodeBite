-- Phase 3 Batch 9: Intervals (#178-180) + Math & Geometry (#181-188)
-- 11 problems: room-checker, query-intervals, arrow-shooter, zero-matrix, power-function, string-multiply, joyful-number, increment-digits, fizz-buzz-game, mirror-number, numeral-converter

------------------------------------------------------------
-- Add Room Checker problem
-- CodeBite original name: Room Checker (inspired by Meeting Rooms, LC #252)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Room Checker',
    'room-checker',
    'Given an array of time intervals `intervals` where each interval is a pair `[start, end]` representing a scheduled booking, determine whether all bookings can be honored without any overlap.

Two bookings conflict if one starts before the other ends. Return `true` if no bookings overlap, or `false` otherwise.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: false
Explanation: The booking [0,30] overlaps with both [5,10] and [15,20].
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: true
```

**Example 3:**
```
Input: intervals = [[1,5],[5,10],[10,15]]
Output: true
Explanation: Bookings that start exactly when another ends do not conflict.
```',
    'EASY',
    '0 <= intervals.length <= 10^4
intervals[i].length == 2
0 <= start < end <= 10^6',
    178,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[0,30],[5,10],[15,20]]', 'false', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[7,10],[2,4]]', 'true', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[1,5],[5,10],[10,15]]', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[1,10]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[1,5],[2,3],[4,6]]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[0,1],[1,2],[2,3],[3,4],[4,5]]', 'true', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'room-checker'),
    'en',
    'Room Checker',
    'Given an array of time intervals `intervals` where each interval is a pair `[start, end]` representing a scheduled booking, determine whether all bookings can be honored without any overlap.

Two bookings conflict if one starts before the other ends. Return `true` if no bookings overlap, or `false` otherwise.

**Example 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: false
Explanation: The booking [0,30] overlaps with both [5,10] and [15,20].
```

**Example 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: true
```

**Example 3:**
```
Input: intervals = [[1,5],[5,10],[10,15]]
Output: true
Explanation: Bookings that start exactly when another ends do not conflict.
```',
    '0 <= intervals.length <= 10^4
intervals[i].length == 2
0 <= start < end <= 10^6'
);

------------------------------------------------------------
-- Add Query Intervals problem
-- CodeBite original name: Query Intervals (inspired by Minimum Interval to Include Each Query, LC #1851)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Query Intervals',
    'query-intervals',
    'You are given a 2D integer array `intervals` where each element `[start, end]` represents an inclusive interval, and an integer array `queries` where each value is a point on the number line.

For each query, determine the **size** of the smallest interval from `intervals` that contains that query point. The size of an interval `[start, end]` is defined as `end - start + 1`. If no interval contains the query point, the answer for that query is `-1`.

Return an array of integers where the `i`-th element is the answer for `queries[i]`.

**Example 1:**
```
Input: intervals = [[1,4],[2,4],[3,6],[2,8]], queries = [2,3,4,5]
Output: [3,3,3,4]
Explanation: For query 2, intervals [1,4] (size 4), [2,4] (size 3), and [2,8] (size 7) all contain it. The smallest is [2,4] with size 3. For query 5, only [3,6] (size 4) and [2,8] (size 7) contain it. The smallest is size 4.
```

**Example 2:**
```
Input: intervals = [[2,3],[2,5],[1,8],[20,25]], queries = [2,19,5,22]
Output: [2,-1,4,6]
Explanation: For query 19, no interval contains it, so the answer is -1. For query 22, only [20,25] (size 6) contains it.
```

**Example 3:**
```
Input: intervals = [[1,1]], queries = [1,2]
Output: [1,-1]
Explanation: The only interval [1,1] has size 1 and contains query 1, but not query 2.
```',
    'HARD',
    '1 <= intervals.length <= 10^5
1 <= queries.length <= 10^5
1 <= start <= end <= 10^7',
    179,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,4],[2,4],[3,6],[2,8]]\n[2,3,4,5]', '[3,3,3,4]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[2,3],[2,5],[1,8],[20,25]]\n[2,19,5,22]', '[2,-1,4,6]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,1]]\n[1,2]', '[1,-1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,10],[2,3],[4,5],[6,7]]\n[1,2,5,7,10,11]', '[10,2,2,2,10,-1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[5,5],[5,5],[5,5]]\n[5,6]', '[1,-1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,1000000],[500000,500001]]\n[500000,1,1000000,999999]', '[2,1000000,1000000,1000000]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[3,5],[1,2],[7,9]]\n[6,4,8,1]', '[-1,3,3,2]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'query-intervals'),
    'en',
    'Query Intervals',
    'You are given a 2D integer array `intervals` where each element `[start, end]` represents an inclusive interval, and an integer array `queries` where each value is a point on the number line.

For each query, determine the **size** of the smallest interval from `intervals` that contains that query point. The size of an interval `[start, end]` is defined as `end - start + 1`. If no interval contains the query point, the answer for that query is `-1`.

Return an array of integers where the `i`-th element is the answer for `queries[i]`.

**Example 1:**
```
Input: intervals = [[1,4],[2,4],[3,6],[2,8]], queries = [2,3,4,5]
Output: [3,3,3,4]
Explanation: For query 2, intervals [1,4] (size 4), [2,4] (size 3), and [2,8] (size 7) all contain it. The smallest is [2,4] with size 3. For query 5, only [3,6] (size 4) and [2,8] (size 7) contain it. The smallest is size 4.
```

**Example 2:**
```
Input: intervals = [[2,3],[2,5],[1,8],[20,25]], queries = [2,19,5,22]
Output: [2,-1,4,6]
Explanation: For query 19, no interval contains it, so the answer is -1. For query 22, only [20,25] (size 6) contains it.
```

**Example 3:**
```
Input: intervals = [[1,1]], queries = [1,2]
Output: [1,-1]
Explanation: The only interval [1,1] has size 1 and contains query 1, but not query 2.
```',
    '1 <= intervals.length <= 10^5
1 <= queries.length <= 10^5
1 <= start <= end <= 10^7'
);

------------------------------------------------------------
-- Add Arrow Shooter problem
-- CodeBite original name: Arrow Shooter (inspired by Minimum Number of Arrows to Burst Balloons, LC #452)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Arrow Shooter',
    'arrow-shooter',
    'You are given a list of targets floating in a 2D space. Each target is represented as a horizontal segment defined by `[start, end]`, meaning the target spans from x-coordinate `start` to x-coordinate `end` (inclusive on both sides).

You can shoot vertical arrows straight up from the x-axis. An arrow shot at position `x` will hit every target whose segment contains `x` (i.e., `start <= x <= end`). Once hit, a target is destroyed.

Return the **minimum** number of arrows you need to shoot to destroy all targets.

**Example 1:**
```
Input: targets = [[10,16],[2,8],[1,6],[7,12]]
Output: 2
Explanation: One way is to shoot at x = 6 (hits [2,8] and [1,6]) and at x = 11 (hits [10,16] and [7,12]).
```

**Example 2:**
```
Input: targets = [[1,2],[3,4],[5,6],[7,8]]
Output: 4
Explanation: No two targets overlap, so each requires its own arrow.
```

**Example 3:**
```
Input: targets = [[1,2],[2,3],[3,4],[4,5]]
Output: 2
Explanation: Shoot at x = 2 (hits [1,2] and [2,3]) and at x = 4 (hits [3,4] and [4,5]).
```',
    'MEDIUM',
    '1 <= targets.length <= 10^5
targets[i].length == 2
-2^31 <= start <= end <= 2^31 - 1',
    180,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[10,16],[2,8],[1,6],[7,12]]', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,2],[3,4],[5,6],[7,8]]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,2],[2,3],[3,4],[4,5]]', '2', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,10]]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,5],[1,5],[1,5]]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,2],[2,3],[3,4]]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[-2147483648,2147483647]]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[3,9],[7,12],[3,8],[6,8],[9,10],[2,9],[0,9],[3,9],[0,6],[2,8]]', '2', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'arrow-shooter'),
    'en',
    'Arrow Shooter',
    'You are given a list of targets floating in a 2D space. Each target is represented as a horizontal segment defined by `[start, end]`, meaning the target spans from x-coordinate `start` to x-coordinate `end` (inclusive on both sides).

You can shoot vertical arrows straight up from the x-axis. An arrow shot at position `x` will hit every target whose segment contains `x` (i.e., `start <= x <= end`). Once hit, a target is destroyed.

Return the **minimum** number of arrows you need to shoot to destroy all targets.

**Example 1:**
```
Input: targets = [[10,16],[2,8],[1,6],[7,12]]
Output: 2
Explanation: One way is to shoot at x = 6 (hits [2,8] and [1,6]) and at x = 11 (hits [10,16] and [7,12]).
```

**Example 2:**
```
Input: targets = [[1,2],[3,4],[5,6],[7,8]]
Output: 4
Explanation: No two targets overlap, so each requires its own arrow.
```

**Example 3:**
```
Input: targets = [[1,2],[2,3],[3,4],[4,5]]
Output: 2
Explanation: Shoot at x = 2 (hits [1,2] and [2,3]) and at x = 4 (hits [3,4] and [4,5]).
```',
    '1 <= targets.length <= 10^5
targets[i].length == 2
-2^31 <= start <= end <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Zero Matrix problem
-- CodeBite original name: Zero Matrix (inspired by Set Matrix Zeroes, LC #73)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Zero Matrix',
    'zero-matrix',
    'Given an `m x n` integer matrix, modify it **in-place** so that whenever an element is `0`, its entire row and entire column are all set to `0`.

**Example 1:**
```
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
Explanation: The element at row 1, column 1 is 0, so all of row 1 and all of column 1 become 0.
```

**Example 2:**
```
Input: matrix = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
Output: [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
Explanation: Row 0 has zeroes at columns 0 and 3, so column 0 and column 3 are fully zeroed, and row 0 is fully zeroed.
```

**Example 3:**
```
Input: matrix = [[1,2],[3,4]]
Output: [[1,2],[3,4]]
Explanation: No zeroes exist, so the matrix remains unchanged.
```',
    'MEDIUM',
    'm == matrix.length
n == matrix[0].length
1 <= m, n <= 200
-2^31 <= matrix[i][j] <= 2^31 - 1',
    181,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,1,1],[1,0,1],[1,1,1]]', '[[1,0,1],[0,0,0],[1,0,1]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[0,1,2,0],[3,4,5,2],[1,3,1,5]]', '[[0,0,0,0],[0,4,5,0],[0,3,1,0]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,2],[3,4]]', '[[1,2],[3,4]]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[0]]', '[[0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1]]', '[[1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,0],[0,1]]', '[[0,0],[0,0]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,2,3,4],[5,0,7,8],[9,10,11,12],[13,14,15,0]]', '[[1,0,3,0],[0,0,0,0],[9,0,11,0],[0,0,0,0]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[0,0,0],[0,0,0]]', '[[0,0,0],[0,0,0]]', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'zero-matrix'),
    'en',
    'Zero Matrix',
    'Given an `m x n` integer matrix, modify it **in-place** so that whenever an element is `0`, its entire row and entire column are all set to `0`.

**Example 1:**
```
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
Explanation: The element at row 1, column 1 is 0, so all of row 1 and all of column 1 become 0.
```

**Example 2:**
```
Input: matrix = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
Output: [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
Explanation: Row 0 has zeroes at columns 0 and 3, so column 0 and column 3 are fully zeroed, and row 0 is fully zeroed.
```

**Example 3:**
```
Input: matrix = [[1,2],[3,4]]
Output: [[1,2],[3,4]]
Explanation: No zeroes exist, so the matrix remains unchanged.
```',
    'm == matrix.length
n == matrix[0].length
1 <= m, n <= 200
-2^31 <= matrix[i][j] <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Power Function problem
-- CodeBite original name: Power Function (inspired by Pow(x, n), LC #50)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Power Function',
    'power-function',
    'Given a floating-point number `x` and an integer `n`, compute `x` raised to the power `n` (i.e., `x^n`).

Your implementation should handle negative exponents correctly. For example, `x^-2` is equivalent to `1 / (x^2)`.

Return the result rounded to 5 decimal places.

**Example 1:**
```
Input: x = 2.00000, n = 10
Output: 1024.00000
```

**Example 2:**
```
Input: x = 2.10000, n = 3
Output: 9.26100
```

**Example 3:**
```
Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^-2 = 1 / (2^2) = 1/4 = 0.25
```',
    'MEDIUM',
    '-100.0 < x < 100.0
-2^31 <= n <= 2^31 - 1
n is an integer
Either x is not zero or n > 0
-10^4 <= x^n <= 10^4',
    182,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'2.00000\n10', '1024.00000', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'2.10000\n3', '9.26100', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'2.00000\n-2', '0.25000', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'1.00000\n2147483647', '1.00000', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'0.00001\n2147483647', '0.00000', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'2.00000\n0', '1.00000', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'-1.00000\n-2147483648', '1.00000', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'0.44528\n0', '1.00000', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'8.88023\n3', '700.28148', FALSE, 9);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'power-function'),
    'en',
    'Power Function',
    'Given a floating-point number `x` and an integer `n`, compute `x` raised to the power `n` (i.e., `x^n`).

Your implementation should handle negative exponents correctly. For example, `x^-2` is equivalent to `1 / (x^2)`.

Return the result rounded to 5 decimal places.

**Example 1:**
```
Input: x = 2.00000, n = 10
Output: 1024.00000
```

**Example 2:**
```
Input: x = 2.10000, n = 3
Output: 9.26100
```

**Example 3:**
```
Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^-2 = 1 / (2^2) = 1/4 = 0.25
```',
    '-100.0 < x < 100.0
-2^31 <= n <= 2^31 - 1
n is an integer
Either x is not zero or n > 0
-10^4 <= x^n <= 10^4'
);

------------------------------------------------------------
-- Add String Multiply problem
-- CodeBite original name: String Multiply (inspired by Multiply Strings, LC #43)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'String Multiply',
    'string-multiply',
    'You are given two non-negative integers represented as strings `num1` and `num2`. Return the product of the two numbers, also represented as a string.

You must not use any built-in big integer library or convert the inputs directly to integers.

**Example 1:**
```
Input: num1 = "2", num2 = "3"
Output: "6"
```

**Example 2:**
```
Input: num1 = "123", num2 = "456"
Output: "56088"
```

**Example 3:**
```
Input: num1 = "99", num2 = "0"
Output: "0"
```',
    'MEDIUM',
    '1 <= num1.length, num2.length <= 200
num1 and num2 consist of digits only
Neither num1 nor num2 has leading zeros, except the number 0 itself',
    183,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'2\n3', '6', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'123\n456', '56088', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'99\n0', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'0\n0', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'999\n999', '998001', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'1\n1', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'498828660196\n840477629533', '419254329864656431168468', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'100\n100', '10000', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'string-multiply'),
    'en',
    'String Multiply',
    'You are given two non-negative integers represented as strings `num1` and `num2`. Return the product of the two numbers, also represented as a string.

You must not use any built-in big integer library or convert the inputs directly to integers.

**Example 1:**
```
Input: num1 = "2", num2 = "3"
Output: "6"
```

**Example 2:**
```
Input: num1 = "123", num2 = "456"
Output: "56088"
```

**Example 3:**
```
Input: num1 = "99", num2 = "0"
Output: "0"
```',
    '1 <= num1.length, num2.length <= 200
num1 and num2 consist of digits only
Neither num1 nor num2 has leading zeros, except the number 0 itself'
);

------------------------------------------------------------
-- Add Joyful Number problem
-- CodeBite original name: Joyful Number (inspired by Happy Number, LC #202)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Joyful Number',
    'joyful-number',
    'Given a positive integer `n`, determine whether it is a **joyful number**.

A joyful number is defined by the following process: starting with any positive integer, replace the number with the sum of the squares of its digits. Repeat this process until the number either reaches `1` (making it joyful) or enters an endless cycle that never includes `1` (making it not joyful).

Return `true` if `n` is a joyful number, and `false` otherwise.

**Example 1:**
```
Input: n = 19
Output: true
Explanation: 1^2 + 9^2 = 82, 8^2 + 2^2 = 68, 6^2 + 8^2 = 100, 1^2 + 0^2 + 0^2 = 1
```

**Example 2:**
```
Input: n = 2
Output: false
Explanation: The digit-square sums cycle without ever reaching 1.
```

**Example 3:**
```
Input: n = 1
Output: true
```',
    'EASY',
    '1 <= n <= 2^31 - 1',
    184,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '19', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '2', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '1', 'true', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '7', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '4', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '100', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '116', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '1000000', 'true', FALSE, 8);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'joyful-number'),
    'en',
    'Joyful Number',
    'Given a positive integer `n`, determine whether it is a **joyful number**.

A joyful number is defined by the following process: starting with any positive integer, replace the number with the sum of the squares of its digits. Repeat this process until the number either reaches `1` (making it joyful) or enters an endless cycle that never includes `1` (making it not joyful).

Return `true` if `n` is a joyful number, and `false` otherwise.

**Example 1:**
```
Input: n = 19
Output: true
Explanation: 1^2 + 9^2 = 82, 8^2 + 2^2 = 68, 6^2 + 8^2 = 100, 1^2 + 0^2 + 0^2 = 1
```

**Example 2:**
```
Input: n = 2
Output: false
Explanation: The digit-square sums cycle without ever reaching 1.
```

**Example 3:**
```
Input: n = 1
Output: true
```',
    '1 <= n <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Increment Digits problem
-- CodeBite original name: Increment Digits (inspired by Plus One, LC #66)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Increment Digits',
    'increment-digits',
    'You are given a non-negative integer represented as an array of its individual digits, where `digits[0]` is the most significant digit. Add one to the number and return the result as an array of digits.

The array does not contain any leading zeros, except for the number zero itself which is represented as `[0]`.

**Example 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: The number 123 becomes 124.
```

**Example 2:**
```
Input: digits = [9,9]
Output: [1,0,0]
Explanation: 99 + 1 = 100, which requires an extra digit.
```

**Example 3:**
```
Input: digits = [0]
Output: [1]
```',
    'EASY',
    '1 <= digits.length <= 100
0 <= digits[i] <= 9
The input array does not have leading zeros except for the number 0 itself.',
    185,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[1,2,3]', '[1,2,4]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[9,9]', '[1,0,0]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[0]', '[1]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[4,3,2,1]', '[4,3,2,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[9,9,9,9]', '[1,0,0,0,0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[1,0,9]', '[1,1,0]', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'increment-digits'),
    'en',
    'Increment Digits',
    'You are given a non-negative integer represented as an array of its individual digits, where `digits[0]` is the most significant digit. Add one to the number and return the result as an array of digits.

The array does not contain any leading zeros, except for the number zero itself which is represented as `[0]`.

**Example 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: The number 123 becomes 124.
```

**Example 2:**
```
Input: digits = [9,9]
Output: [1,0,0]
Explanation: 99 + 1 = 100, which requires an extra digit.
```

**Example 3:**
```
Input: digits = [0]
Output: [1]
```',
    '1 <= digits.length <= 100
0 <= digits[i] <= 9
The input array does not have leading zeros except for the number 0 itself.'
);

------------------------------------------------------------
-- Add Fizz Buzz Game problem
-- CodeBite original name: Fizz Buzz Game (inspired by FizzBuzz, LC #412)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Fizz Buzz Game',
    'fizz-buzz-game',
    'Given a positive integer `n`, build a list of strings from `1` to `n` based on the following rules:

- If the number is divisible by both 3 and 5, use `"FizzBuzz"`.
- If the number is divisible by 3 (but not 5), use `"Fizz"`.
- If the number is divisible by 5 (but not 3), use `"Buzz"`.
- Otherwise, use the number itself as a string.

Return the resulting list.

**Example 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**Example 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**Example 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```',
    'EASY',
    '1 <= n <= 10^4',
    186,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '3', '["1","2","Fizz"]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '5', '["1","2","Fizz","4","Buzz"]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '15', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '1', '["1"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '30', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz","16","17","Fizz","19","Buzz","Fizz","22","23","Fizz","Buzz","26","Fizz","28","29","FizzBuzz"]', FALSE, 5);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fizz-buzz-game'),
    'en',
    'Fizz Buzz Game',
    'Given a positive integer `n`, build a list of strings from `1` to `n` based on the following rules:

- If the number is divisible by both 3 and 5, use `"FizzBuzz"`.
- If the number is divisible by 3 (but not 5), use `"Fizz"`.
- If the number is divisible by 5 (but not 3), use `"Buzz"`.
- Otherwise, use the number itself as a string.

Return the resulting list.

**Example 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**Example 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**Example 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```',
    '1 <= n <= 10^4'
);

------------------------------------------------------------
-- Add Mirror Number problem
-- CodeBite original name: Mirror Number (inspired by Palindrome Number, LC #9)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Mirror Number',
    'mirror-number',
    'Given an integer `x`, return `true` if `x` reads the same forwards and backwards, and `false` otherwise.

A negative number is never a mirror number because of the minus sign.

**Example 1:**
```
Input: x = 121
Output: true
Explanation: 121 reversed is still 121.
```

**Example 2:**
```
Input: x = -45
Output: false
Explanation: Negative numbers cannot be mirror numbers due to the leading minus sign.
```

**Example 3:**
```
Input: x = 10
Output: false
Explanation: 10 reversed is 01, which is not equal to 10.
```',
    'EASY',
    '-2^31 <= x <= 2^31 - 1',
    187,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '121', 'true', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '-45', 'false', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '10', 'false', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '0', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '1234321', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '12321', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '1000021', 'false', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'mirror-number'),
    'en',
    'Mirror Number',
    'Given an integer `x`, return `true` if `x` reads the same forwards and backwards, and `false` otherwise.

A negative number is never a mirror number because of the minus sign.

**Example 1:**
```
Input: x = 121
Output: true
Explanation: 121 reversed is still 121.
```

**Example 2:**
```
Input: x = -45
Output: false
Explanation: Negative numbers cannot be mirror numbers due to the leading minus sign.
```

**Example 3:**
```
Input: x = 10
Output: false
Explanation: 10 reversed is 01, which is not equal to 10.
```',
    '-2^31 <= x <= 2^31 - 1'
);

------------------------------------------------------------
-- Add Numeral Converter problem
-- CodeBite original name: Numeral Converter (inspired by Roman to Integer, LC #13)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Numeral Converter',
    'numeral-converter',
    'Given a string `s` representing a Roman numeral, convert it to its corresponding integer value.

Roman numerals use seven symbols: `I` (1), `V` (5), `X` (10), `L` (50), `C` (100), `D` (500), and `M` (1000).

Normally, symbols are written from largest to smallest, left to right. However, a smaller symbol placed directly before a larger one indicates subtraction. For example, `IV` equals 4 (not 6), and `IX` equals 9.

The six subtractive combinations are:
- `IV` = 4, `IX` = 9
- `XL` = 40, `XC` = 90
- `CD` = 400, `CM` = 900

Return the integer value of the given Roman numeral.

**Example 1:**
```
Input: s = "III"
Output: 3
Explanation: I + I + I = 3.
```

**Example 2:**
```
Input: s = "LVIII"
Output: 58
Explanation: L + V + I + I + I = 50 + 5 + 1 + 1 + 1 = 58.
```

**Example 3:**
```
Input: s = "MCMXCIV"
Output: 1994
Explanation: M + CM + XC + IV = 1000 + 900 + 90 + 4 = 1994.
```',
    'EASY',
    '1 <= s.length <= 15
s contains only the characters I, V, X, L, C, D, M.
The input is guaranteed to be a valid Roman numeral in the range [1, 3999].',
    188,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'III', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'LVIII', '58', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'MCMXCIV', '1994', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'IV', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'IX', '9', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'MMMCMXCIX', '3999', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'DCXXI', '621', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'numeral-converter'),
    'en',
    'Numeral Converter',
    'Given a string `s` representing a Roman numeral, convert it to its corresponding integer value.

Roman numerals use seven symbols: `I` (1), `V` (5), `X` (10), `L` (50), `C` (100), `D` (500), and `M` (1000).

Normally, symbols are written from largest to smallest, left to right. However, a smaller symbol placed directly before a larger one indicates subtraction. For example, `IV` equals 4 (not 6), and `IX` equals 9.

The six subtractive combinations are:
- `IV` = 4, `IX` = 9
- `XL` = 40, `XC` = 90
- `CD` = 400, `CM` = 900

Return the integer value of the given Roman numeral.

**Example 1:**
```
Input: s = "III"
Output: 3
Explanation: I + I + I = 3.
```

**Example 2:**
```
Input: s = "LVIII"
Output: 58
Explanation: L + V + I + I + I = 50 + 5 + 1 + 1 + 1 = 58.
```

**Example 3:**
```
Input: s = "MCMXCIV"
Output: 1994
Explanation: M + CM + XC + IV = 1000 + 900 + 90 + 4 = 1994.
```',
    '1 <= s.length <= 15
s contains only the characters I, V, X, L, C, D, M.
The input is guaranteed to be a valid Roman numeral in the range [1, 3999].'
);

