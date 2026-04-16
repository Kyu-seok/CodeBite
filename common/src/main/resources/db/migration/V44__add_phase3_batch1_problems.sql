-- Phase 3 Batch 1: Arrays & Hashing (#102-105) + Two Pointers (#106-108) + Sliding Window (#109-110)
-- 9 problems: remove-sorted-dupes, duplicate-finder, target-subarray, k-distinct-window, quad-sum, boat-loading, sorted-squares, shortest-cover, fruit-picker

-- Fix: V42 shifted all problem_numbers >= 78 including Popular Vote (101 -> 102).
-- Move it back to 101 before inserting new Phase 3 problems.
UPDATE problems SET problem_number = 101 WHERE slug = 'popular-vote';

------------------------------------------------------------
-- Add Remove Sorted Dupes problem
-- CodeBite original name: Remove Sorted Dupes (inspired by LeetCode #26 Remove Duplicates from Sorted Array)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Remove Sorted Dupes',
    'remove-sorted-dupes',
    'Given an integer array `nums` sorted in non-decreasing order, remove the duplicate values so that each unique element appears only once. The relative order of the elements must stay the same.

Since some languages do not allow resizing arrays, you must do this **in-place** by overwriting the front of `nums`. Return `k`, the count of unique elements. The first `k` positions of `nums` must hold the unique values in their original order. Elements beyond index `k - 1` are ignored.

**Example 1:**
```
Input: nums = [1,1,2]
Output: 2, nums = [1,2,_]
Explanation: Return k = 2. The first two elements of nums are 1 and 2.
```

**Example 2:**
```
Input: nums = [0,0,1,1,1,2,2,3,3,4]
Output: 5, nums = [0,1,2,3,4,_,_,_,_,_]
Explanation: Return k = 5. The first five slots hold 0 through 4.
```

**Example 3:**
```
Input: nums = [7]
Output: 1, nums = [7]
Explanation: A single-element array has no duplicates.
```',
    'EASY',
    '1 <= nums.length <= 3 * 10^4
-100 <= nums[i] <= 100
nums is sorted in non-decreasing order.',
    102,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[1,1,2]', E'2\n[1,2]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[0,0,1,1,1,2,2,3,3,4]', E'5\n[0,1,2,3,4]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[7]', E'1\n[7]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[1,2,3,4,5]', E'5\n[1,2,3,4,5]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[-3,-3,-1,-1,0,0,0,2,2]', E'4\n[-3,-1,0,2]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[-100,-100,100,100]', E'2\n[-100,100]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'), '[0,0,0,0,0]', E'1\n[0]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'),
    'en',
    'Remove Sorted Dupes',
    'Given an integer array `nums` sorted in non-decreasing order, remove the duplicate values so that each unique element appears only once. The relative order of the elements must stay the same.

Since some languages do not allow resizing arrays, you must do this **in-place** by overwriting the front of `nums`. Return `k`, the count of unique elements. The first `k` positions of `nums` must hold the unique values in their original order. Elements beyond index `k - 1` are ignored.

**Example 1:**
```
Input: nums = [1,1,2]
Output: 2, nums = [1,2,_]
Explanation: Return k = 2. The first two elements of nums are 1 and 2.
```

**Example 2:**
```
Input: nums = [0,0,1,1,1,2,2,3,3,4]
Output: 5, nums = [0,1,2,3,4,_,_,_,_,_]
Explanation: Return k = 5. The first five slots hold 0 through 4.
```

**Example 3:**
```
Input: nums = [7]
Output: 1, nums = [7]
Explanation: A single-element array has no duplicates.
```',
    '1 <= nums.length <= 3 * 10^4
-100 <= nums[i] <= 100
nums is sorted in non-decreasing order.'
);

------------------------------------------------------------
-- Add Duplicate Finder problem
-- CodeBite original name: Duplicate Finder (inspired by LeetCode #442 Find All Duplicates in an Array)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Duplicate Finder',
    'duplicate-finder',
    'Given an integer array `nums` of length `n` where each value satisfies `1 <= nums[i] <= n`, some elements appear **exactly twice** while all others appear **exactly once**. Return a list of all the elements that appear twice.

Your solution should run in O(n) time and use only O(1) extra space (beyond the output list).

**Example 1:**
```
Input: nums = [4,3,2,7,8,2,3,1]
Output: [2,3]
```

**Example 2:**
```
Input: nums = [1,1,2]
Output: [1]
```

**Example 3:**
```
Input: nums = [1,2,3,4,5]
Output: []
Explanation: No element appears more than once.
```',
    'MEDIUM',
    'n == nums.length
1 <= n <= 10^5
1 <= nums[i] <= n
Each element appears once or twice.',
    103,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[4,3,2,7,8,2,3,1]', '[2,3]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,1,2]', '[1]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,2,3,4,5]', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[2,2]', '[2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[5,4,6,7,9,3,10,9,5,6]', '[5,6,9]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1]', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[3,3,2,1,4,5,6,7,8,8]', '[3,8]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'duplicate-finder'),
    'en',
    'Duplicate Finder',
    'Given an integer array `nums` of length `n` where each value satisfies `1 <= nums[i] <= n`, some elements appear **exactly twice** while all others appear **exactly once**. Return a list of all the elements that appear twice.

Your solution should run in O(n) time and use only O(1) extra space (beyond the output list).

**Example 1:**
```
Input: nums = [4,3,2,7,8,2,3,1]
Output: [2,3]
```

**Example 2:**
```
Input: nums = [1,1,2]
Output: [1]
```

**Example 3:**
```
Input: nums = [1,2,3,4,5]
Output: []
Explanation: No element appears more than once.
```',
    'n == nums.length
1 <= n <= 10^5
1 <= nums[i] <= n
Each element appears once or twice.'
);

------------------------------------------------------------
-- Add Target Subarray problem
-- CodeBite original name: Target Subarray (inspired by Subarray Sum Equals K, LC #560)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Target Subarray',
    'target-subarray',
    'Given an integer array `nums` and an integer `k`, count the total number of contiguous subarrays whose elements sum to exactly `k`.

A subarray is a consecutive sequence of elements within the array.

**Example 1:**
```
Input: nums = [1,1,1], k = 2
Output: 2
Explanation: The subarrays [1,1] starting at index 0 and [1,1] starting at index 1 both sum to 2.
```

**Example 2:**
```
Input: nums = [1,2,3], k = 3
Output: 2
Explanation: Both [1,2] and [3] sum to 3.
```

**Example 3:**
```
Input: nums = [1,-1,0], k = 0
Output: 3
Explanation: [1,-1], [-1,0], and [1,-1,0] all sum to 0.
```',
    'MEDIUM',
    '1 <= nums.length <= 20000
-1000 <= nums[i] <= 1000
-10^7 <= k <= 10^7',
    104,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1,1,1]\n2', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1,2,3]\n3', '2', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1,-1,0]\n0', '3', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[3,4,7,2,-3,1,4,2]\n7', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1]\n1', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1]\n0', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[-1,-1,1]\n0', '1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'target-subarray'),
    'en',
    'Target Subarray',
    'Given an integer array `nums` and an integer `k`, count the total number of contiguous subarrays whose elements sum to exactly `k`.

A subarray is a consecutive sequence of elements within the array.

**Example 1:**
```
Input: nums = [1,1,1], k = 2
Output: 2
Explanation: The subarrays [1,1] starting at index 0 and [1,1] starting at index 1 both sum to 2.
```

**Example 2:**
```
Input: nums = [1,2,3], k = 3
Output: 2
Explanation: Both [1,2] and [3] sum to 3.
```

**Example 3:**
```
Input: nums = [1,-1,0], k = 0
Output: 3
Explanation: [1,-1], [-1,0], and [1,-1,0] all sum to 0.
```',
    '1 <= nums.length <= 20000
-1000 <= nums[i] <= 1000
-10^7 <= k <= 10^7'
);

------------------------------------------------------------
-- Add K Distinct Window problem
-- CodeBite original name: K Distinct Window (inspired by Longest Substring with At Most K Distinct Characters, LC #340)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'K Distinct Window',
    'k-distinct-window',
    'Given a string `s` and an integer `k`, find the length of the longest substring that contains at most `k` distinct characters.

A substring is a contiguous sequence of characters within the string.

**Example 1:**
```
Input: s = "aabacbebebe", k = 3
Output: 7
Explanation: The longest substring with at most 3 distinct characters is "cbebebe".
```

**Example 2:**
```
Input: s = "aaaa", k = 2
Output: 4
Explanation: The entire string has only 1 distinct character, which is within the limit.
```

**Example 3:**
```
Input: s = "abcdef", k = 1
Output: 1
Explanation: Every character is unique, so the longest single-character substring has length 1.
```',
    'MEDIUM',
    '1 <= s.length <= 50000
0 <= k <= 50
s consists of lowercase English letters',
    105,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'aabacbebebe\n3', '7', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'aaaa\n2', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abcdef\n1', '1', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'a\n0', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abaccc\n2', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'aabbcc\n3', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abcbbbbcccbdddadacb\n2', '10', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'k-distinct-window'),
    'en',
    'K Distinct Window',
    'Given a string `s` and an integer `k`, find the length of the longest substring that contains at most `k` distinct characters.

A substring is a contiguous sequence of characters within the string.

**Example 1:**
```
Input: s = "aabacbebebe", k = 3
Output: 7
Explanation: The longest substring with at most 3 distinct characters is "cbebebe".
```

**Example 2:**
```
Input: s = "aaaa", k = 2
Output: 4
Explanation: The entire string has only 1 distinct character, which is within the limit.
```

**Example 3:**
```
Input: s = "abcdef", k = 1
Output: 1
Explanation: Every character is unique, so the longest single-character substring has length 1.
```',
    '1 <= s.length <= 50000
0 <= k <= 50
s consists of lowercase English letters'
);

------------------------------------------------------------
-- Add Quad Sum problem
-- CodeBite original name: Quad Sum (inspired by 4Sum, LC #18)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Quad Sum',
    'quad-sum',
    'Given an integer array `nums` and an integer `target`, find all unique groups of four elements from `nums` that add up to `target`.

Each group must contain exactly four elements, and the solution set must not contain duplicate groups. The elements within each group can be returned in any order.

**Example 1:**
```
Input: nums = [1,0,-1,0,-2,2], target = 0
Output: [[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]
Explanation: Three distinct quadruplets sum to 0.
```

**Example 2:**
```
Input: nums = [2,2,2,2,2], target = 8
Output: [[2,2,2,2]]
Explanation: Only one unique quadruplet sums to 8.
```

**Example 3:**
```
Input: nums = [1,2,3,4], target = 100
Output: []
Explanation: No four elements sum to 100.
```',
    'MEDIUM',
    '1 <= nums.length <= 200
-10^9 <= nums[i] <= 10^9
-10^9 <= target <= 10^9',
    106,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[1,0,-1,0,-2,2]\n0', '[[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[2,2,2,2,2]\n8', '[[2,2,2,2]]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[1,2,3,4]\n100', '[]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[-3,-1,0,2,4,5]\n2', '[[-3,-1,2,4]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[0,0,0,0]\n0', '[[0,0,0,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[-5,-4,-3,-2,1,3,3,5]\n-1', '[[-5,-4,3,5],[-5,-2,1,5],[-5,-2,3,3],[-4,-3,1,5],[-4,-3,3,3],[-3,-2,1,3]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[1000000000,1000000000,1000000000,1000000000]\n-294967296', '[]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'quad-sum'),
    'en',
    'Quad Sum',
    'Given an integer array `nums` and an integer `target`, find all unique groups of four elements from `nums` that add up to `target`.

Each group must contain exactly four elements, and the solution set must not contain duplicate groups. The elements within each group can be returned in any order.

**Example 1:**
```
Input: nums = [1,0,-1,0,-2,2], target = 0
Output: [[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]
Explanation: Three distinct quadruplets sum to 0.
```

**Example 2:**
```
Input: nums = [2,2,2,2,2], target = 8
Output: [[2,2,2,2]]
Explanation: Only one unique quadruplet sums to 8.
```

**Example 3:**
```
Input: nums = [1,2,3,4], target = 100
Output: []
Explanation: No four elements sum to 100.
```',
    '1 <= nums.length <= 200
-10^9 <= nums[i] <= 10^9
-10^9 <= target <= 10^9'
);

------------------------------------------------------------
-- Add Boat Loading problem
-- CodeBite original name: Boat Loading (inspired by Boats to Save People, LC #881)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Boat Loading',
    'boat-loading',
    'Given an array `weights` where `weights[i]` represents the weight of the `i`-th person, and an integer `capacity` representing the maximum weight a single boat can hold, return the minimum number of boats required to carry every person.

Each boat can carry **at most 2 people** at the same time, provided the sum of their weights does not exceed `capacity`. Every person must be assigned to exactly one boat.

**Example 1:**
```
Input: weights = [1,2], capacity = 3
Output: 1
Explanation: One boat can carry both people (1 + 2 = 3).
```

**Example 2:**
```
Input: weights = [3,2,2,1], capacity = 3
Output: 3
Explanation: Pair the person weighing 1 with the person weighing 2 on one boat. The remaining two people (weights 3 and 2) each need their own boat.
```

**Example 3:**
```
Input: weights = [3,5,3,4], capacity = 5
Output: 4
Explanation: No two people can share a boat since every pair exceeds the capacity.
```',
    'MEDIUM',
    '1 <= weights.length <= 50000
1 <= weights[i] <= capacity <= 30000',
    107,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[1,2]\n3', '1', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[3,2,2,1]\n3', '3', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[3,5,3,4]\n5', '4', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[5]\n5', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[1,1,1,1,1]\n2', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[2,4,3,1,5,2]\n5', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[3,3,3,3]\n6', '2', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'boat-loading'),
    'en',
    'Boat Loading',
    'Given an array `weights` where `weights[i]` represents the weight of the `i`-th person, and an integer `capacity` representing the maximum weight a single boat can hold, return the minimum number of boats required to carry every person.

Each boat can carry **at most 2 people** at the same time, provided the sum of their weights does not exceed `capacity`. Every person must be assigned to exactly one boat.

**Example 1:**
```
Input: weights = [1,2], capacity = 3
Output: 1
Explanation: One boat can carry both people (1 + 2 = 3).
```

**Example 2:**
```
Input: weights = [3,2,2,1], capacity = 3
Output: 3
Explanation: Pair the person weighing 1 with the person weighing 2 on one boat. The remaining two people (weights 3 and 2) each need their own boat.
```

**Example 3:**
```
Input: weights = [3,5,3,4], capacity = 5
Output: 4
Explanation: No two people can share a boat since every pair exceeds the capacity.
```',
    '1 <= weights.length <= 50000
1 <= weights[i] <= capacity <= 30000'
);

------------------------------------------------------------
-- Add Sorted Squares problem
-- CodeBite original name: Sorted Squares (inspired by Squares of a Sorted Array, LC #977)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Sorted Squares',
    'sorted-squares',
    'Given an integer array `nums` sorted in non-decreasing order, return an array of the squares of each element, also sorted in non-decreasing order.

Try to solve this in O(n) time without using a built-in sort function.

**Example 1:**
```
Input: nums = [-4,-1,0,3,10]
Output: [0,1,9,16,100]
```

**Example 2:**
```
Input: nums = [-7,-3,2,3,11]
Output: [4,9,9,49,121]
```

**Example 3:**
```
Input: nums = [1,2,3,4]
Output: [1,4,9,16]
Explanation: When all elements are non-negative, the squares are already sorted.
```',
    'EASY',
    '1 <= nums.length <= 10000
-10000 <= nums[i] <= 10000
nums is sorted in non-decreasing order',
    108,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-4,-1,0,3,10]', '[0,1,9,16,100]', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-7,-3,2,3,11]', '[4,9,9,49,121]', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[1,2,3,4]', '[1,4,9,16]', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-5,-4,-3,-2,-1]', '[1,4,9,16,25]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[0]', '[0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-1,0,1]', '[0,1,1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-10000,10000]', '[100000000,100000000]', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sorted-squares'),
    'en',
    'Sorted Squares',
    'Given an integer array `nums` sorted in non-decreasing order, return an array of the squares of each element, also sorted in non-decreasing order.

Try to solve this in O(n) time without using a built-in sort function.

**Example 1:**
```
Input: nums = [-4,-1,0,3,10]
Output: [0,1,9,16,100]
```

**Example 2:**
```
Input: nums = [-7,-3,2,3,11]
Output: [4,9,9,49,121]
```

**Example 3:**
```
Input: nums = [1,2,3,4]
Output: [1,4,9,16]
Explanation: When all elements are non-negative, the squares are already sorted.
```',
    '1 <= nums.length <= 10000
-10000 <= nums[i] <= 10000
nums is sorted in non-decreasing order'
);

------------------------------------------------------------
-- Add Shortest Cover problem
-- CodeBite original name: Shortest Cover (inspired by Minimum Size Subarray Sum, LC #209)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Shortest Cover',
    'shortest-cover',
    'Given an array of positive integers `nums` and a positive integer `target`, find the length of the shortest contiguous subarray whose sum is greater than or equal to `target`. If no such subarray exists, return `0`.

**Example 1:**
```
Input: nums = [2,3,1,2,4,3], target = 7
Output: 2
Explanation: The subarray [4,3] has the smallest length with sum >= 7.
```

**Example 2:**
```
Input: nums = [1,4,4], target = 4
Output: 1
Explanation: The single element [4] already meets the target.
```

**Example 3:**
```
Input: nums = [1,1,1,1,1,1], target = 20
Output: 0
Explanation: The total sum of all elements is only 6, which is less than 20.
```',
    'MEDIUM',
    '1 <= nums.length <= 100000
1 <= nums[i] <= 10000
1 <= target <= 10^9',
    109,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[2,3,1,2,4,3]\n7', '2', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,4,4]\n4', '1', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,1,1,1,1,1]\n20', '0', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,2,3,4,5]\n15', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[5,1,3,5,10,7,4,9,2,8]\n15', '2', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,1,1,1,7]\n7', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[10]\n5', '1', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shortest-cover'),
    'en',
    'Shortest Cover',
    'Given an array of positive integers `nums` and a positive integer `target`, find the length of the shortest contiguous subarray whose sum is greater than or equal to `target`. If no such subarray exists, return `0`.

**Example 1:**
```
Input: nums = [2,3,1,2,4,3], target = 7
Output: 2
Explanation: The subarray [4,3] has the smallest length with sum >= 7.
```

**Example 2:**
```
Input: nums = [1,4,4], target = 4
Output: 1
Explanation: The single element [4] already meets the target.
```

**Example 3:**
```
Input: nums = [1,1,1,1,1,1], target = 20
Output: 0
Explanation: The total sum of all elements is only 6, which is less than 20.
```',
    '1 <= nums.length <= 100000
1 <= nums[i] <= 10000
1 <= target <= 10^9'
);

------------------------------------------------------------
-- Add Fruit Picker problem
-- CodeBite original name: Fruit Picker (inspired by Fruit Into Baskets, LC #904)

INSERT INTO problems (title, slug, description, difficulty, constraints, problem_number, is_published)
VALUES (
    'Fruit Picker',
    'fruit-picker',
    'You are given an integer array `items` where each element represents a category. You want to find the **longest contiguous segment** of `items` that contains **at most 2 distinct categories**.

Return the length of the longest such segment.

**Example 1:**
```
Input: items = [1,2,1,2,3]
Output: 4
Explanation: The segment [1,2,1,2] has length 4 and contains only categories 1 and 2.
```

**Example 2:**
```
Input: items = [5,5,5,5]
Output: 4
Explanation: The entire array has only one category, so the answer is 4.
```

**Example 3:**
```
Input: items = [1,2,3,4,5]
Output: 2
Explanation: Any two adjacent elements form a valid segment of length 2.
```',
    'MEDIUM',
    '1 <= items.length <= 10^5
0 <= items[i] < items.length',
    110,
    TRUE
);

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,2,1,2,3]', '4', TRUE, 1),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[5,5,5,5]', '4', TRUE, 2),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,2,3,4,5]', '2', TRUE, 3),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[3,3,3,1,2,1,1,2,3,3,4]', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[0]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,2,1,3,1,2,1]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[4,4,4,4,4,4,4,4]', '8', FALSE, 7);

-- English translation
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fruit-picker'),
    'en',
    'Fruit Picker',
    'You are given an integer array `items` where each element represents a category. You want to find the **longest contiguous segment** of `items` that contains **at most 2 distinct categories**.

Return the length of the longest such segment.

**Example 1:**
```
Input: items = [1,2,1,2,3]
Output: 4
Explanation: The segment [1,2,1,2] has length 4 and contains only categories 1 and 2.
```

**Example 2:**
```
Input: items = [5,5,5,5]
Output: 4
Explanation: The entire array has only one category, so the answer is 4.
```

**Example 3:**
```
Input: items = [1,2,3,4,5]
Output: 2
Explanation: Any two adjacent elements form a valid segment of length 2.
```',
    '1 <= items.length <= 10^5
0 <= items[i] < items.length'
);

