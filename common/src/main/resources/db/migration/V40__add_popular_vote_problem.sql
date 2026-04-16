-- Add Popular Vote problem
-- CodeBite original name: Popular Vote (inspired by Majority Element, LC #169)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Popular Vote',
    'popular-vote',
    'Given an array `nums` of size `n`, return the element that appears more than `n / 2` times. You may assume that such an element always exists in the array.

**Example 1:**
```
Input: nums = [3,2,3]
Output: 3
```

**Example 2:**
```
Input: nums = [2,2,1,1,1,2,2]
Output: 2
Explanation: 2 appears 4 times out of 7 elements.
```

**Example 3:**
```
Input: nums = [1]
Output: 1
```',
    'EASY',
    '1 <= nums.length <= 50000
-10^9 <= nums[i] <= 10^9',
    101,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[3,2,3]', '3', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[2,2,1,1,1,2,2]', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[1]', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[6,5,5]', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[1,1,1,2,2,2,2]', '2', FALSE, 5);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'popular-vote'),
    'en',
    'Popular Vote',
    'Given an array `nums` of size `n`, return the element that appears more than `n / 2` times. You may assume that such an element always exists in the array.

**Example 1:**
```
Input: nums = [3,2,3]
Output: 3
```

**Example 2:**
```
Input: nums = [2,2,1,1,1,2,2]
Output: 2
Explanation: 2 appears 4 times out of 7 elements.
```

**Example 3:**
```
Input: nums = [1]
Output: 1
```',
    '1 <= nums.length <= 50000
-10^9 <= nums[i] <= 10^9'
);
