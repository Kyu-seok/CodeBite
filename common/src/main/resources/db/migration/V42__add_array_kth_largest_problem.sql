-- Add Array Kth Largest problem
-- CodeBite original name: Array Kth Largest (inspired by LeetCode #215 Kth Largest Element in an Array)

-- Shift existing problem numbers >= 78 up by 1 to make room for the new problem.
-- V39 assigned 51-99; this shifts 78-99 → 79-100.
-- Use a temporary offset to avoid unique constraint violations during the update.
UPDATE problems SET problem_number = problem_number + 1000
WHERE problem_number >= 78 AND problem_number < 200;

UPDATE problems SET problem_number = problem_number - 999
WHERE problem_number >= 1078;

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Array Kth Largest',
    'array-kth-largest',
    'Given an integer array `nums` and an integer `k`, return the `k`th largest element in the array.

Note that it is the `k`th largest element in sorted order, not the `k`th distinct element.

**Example 1:**
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
```

**Example 2:**
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
```

**Example 3:**
```
Input: nums = [1], k = 1
Output: 1
```',
    'MEDIUM',
    '1 <= k <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4',
    78,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[3,2,1,5,6,4]\n2', '5', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[3,2,3,1,2,4,5,5,6]\n4', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[1]\n1', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[7,7,7,7,7]\n3', '7', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[-1,2,0,-3,5]\n1', '5', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[5,3,1,6,4,2]\n6', '1', FALSE, 6);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'array-kth-largest'),
    'en',
    'Array Kth Largest',
    'Given an integer array `nums` and an integer `k`, return the `k`th largest element in the array.

Note that it is the `k`th largest element in sorted order, not the `k`th distinct element.

**Example 1:**
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
```

**Example 2:**
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
```

**Example 3:**
```
Input: nums = [1], k = 1
Output: 1
```',
    '1 <= k <= nums.length <= 10^5
-10^4 <= nums[i] <= 10^4'
);
