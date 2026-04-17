-- Improve descriptions: batch 11

------------------------------------------------------------
-- popular-vote (Popular Vote / Majority Element)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `nums` of size `n`, return the **majority element**. The majority element is the element that appears more than `n / 2` times.

You may assume that a majority element always exists in the array.

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
```'
WHERE slug = 'popular-vote';

UPDATE problem_translations
SET description = 'Given an array `nums` of size `n`, return the **majority element**. The majority element is the element that appears more than `n / 2` times.

You may assume that a majority element always exists in the array.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'popular-vote')
  AND locale = 'en';

------------------------------------------------------------
-- remove-sorted-dupes (Remove Sorted Dupes / Remove Duplicates from Sorted Array)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` sorted in non-decreasing order, remove the duplicates **in-place** so that each unique element appears only once. The relative order of the elements must remain the same.

Overwrite the beginning of `nums` with the unique values and return `k`, the number of unique elements. The first `k` positions of `nums` must hold these unique values in their original order. Elements beyond index `k - 1` do not matter.

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
```'
WHERE slug = 'remove-sorted-dupes';

UPDATE problem_translations
SET description = 'Given an integer array `nums` sorted in non-decreasing order, remove the duplicates **in-place** so that each unique element appears only once. The relative order of the elements must remain the same.

Overwrite the beginning of `nums` with the unique values and return `k`, the number of unique elements. The first `k` positions of `nums` must hold these unique values in their original order. Elements beyond index `k - 1` do not matter.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'remove-sorted-dupes')
  AND locale = 'en';

------------------------------------------------------------
-- duplicate-finder (Duplicate Finder / Find All Duplicates in an Array)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` of length `n` where every value satisfies `1 <= nums[i] <= n`, find all elements that appear **exactly twice**. All other elements appear exactly once.

Return a list of all the duplicate values. The result can be in any order.

Your solution should run in O(n) time and use only O(1) extra space beyond the output list.

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
```'
WHERE slug = 'duplicate-finder';

UPDATE problem_translations
SET description = 'Given an integer array `nums` of length `n` where every value satisfies `1 <= nums[i] <= n`, find all elements that appear **exactly twice**. All other elements appear exactly once.

Return a list of all the duplicate values. The result can be in any order.

Your solution should run in O(n) time and use only O(1) extra space beyond the output list.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-finder')
  AND locale = 'en';

------------------------------------------------------------
-- target-subarray (Target Subarray / Subarray Sum Equals K)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` and an integer `k`, return the total number of contiguous subarrays whose elements sum to exactly `k`.

A **subarray** is a consecutive sequence of elements within the array. Note that the array may contain negative numbers, so the sliding window approach does not apply directly.

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
```'
WHERE slug = 'target-subarray';

UPDATE problem_translations
SET description = 'Given an integer array `nums` and an integer `k`, return the total number of contiguous subarrays whose elements sum to exactly `k`.

A **subarray** is a consecutive sequence of elements within the array. Note that the array may contain negative numbers, so the sliding window approach does not apply directly.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-subarray')
  AND locale = 'en';

------------------------------------------------------------
-- k-distinct-window (K Distinct Window / Longest Substring with At Most K Distinct Characters)
------------------------------------------------------------
UPDATE problems
SET description = 'Given a string `s` and an integer `k`, return the length of the **longest substring** that contains at most `k` distinct characters.

A **substring** is a contiguous sequence of characters within the string.

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
```'
WHERE slug = 'k-distinct-window';

UPDATE problem_translations
SET description = 'Given a string `s` and an integer `k`, return the length of the **longest substring** that contains at most `k` distinct characters.

A **substring** is a contiguous sequence of characters within the string.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-distinct-window')
  AND locale = 'en';

------------------------------------------------------------
-- quad-sum (Quad Sum / 4Sum)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` and an integer `target`, return all **unique quadruplets** `[nums[a], nums[b], nums[c], nums[d]]` such that:

- `a`, `b`, `c`, and `d` are distinct indices
- `nums[a] + nums[b] + nums[c] + nums[d] == target`

The solution set must not contain duplicate quadruplets. You may return the result in any order.

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
```'
WHERE slug = 'quad-sum';

UPDATE problem_translations
SET description = 'Given an integer array `nums` and an integer `target`, return all **unique quadruplets** `[nums[a], nums[b], nums[c], nums[d]]` such that:

- `a`, `b`, `c`, and `d` are distinct indices
- `nums[a] + nums[b] + nums[c] + nums[d] == target`

The solution set must not contain duplicate quadruplets. You may return the result in any order.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-sum')
  AND locale = 'en';

------------------------------------------------------------
-- boat-loading (Boat Loading / Boats to Save People)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array `weights` where `weights[i]` is the weight of the `i`-th person, and an integer `capacity` representing the maximum weight a single boat can carry, return the **minimum number of boats** needed to carry everyone.

Each boat can hold **at most 2 people**, as long as the sum of their weights does not exceed `capacity`. Every person must be assigned to exactly one boat.

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
```'
WHERE slug = 'boat-loading';

UPDATE problem_translations
SET description = 'Given an array `weights` where `weights[i]` is the weight of the `i`-th person, and an integer `capacity` representing the maximum weight a single boat can carry, return the **minimum number of boats** needed to carry everyone.

Each boat can hold **at most 2 people**, as long as the sum of their weights does not exceed `capacity`. Every person must be assigned to exactly one boat.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'boat-loading')
  AND locale = 'en';

------------------------------------------------------------
-- sorted-squares (Sorted Squares / Squares of a Sorted Array)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an integer array `nums` sorted in non-decreasing order, return an array of **the squares of each element**, also sorted in non-decreasing order.

The challenge is that negative numbers become positive when squared, which can change the sort order. Try to solve this in O(n) time without using a built-in sort function.

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
```'
WHERE slug = 'sorted-squares';

UPDATE problem_translations
SET description = 'Given an integer array `nums` sorted in non-decreasing order, return an array of **the squares of each element**, also sorted in non-decreasing order.

The challenge is that negative numbers become positive when squared, which can change the sort order. Try to solve this in O(n) time without using a built-in sort function.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-squares')
  AND locale = 'en';

------------------------------------------------------------
-- shortest-cover (Shortest Cover / Minimum Size Subarray Sum)
------------------------------------------------------------
UPDATE problems
SET description = 'Given an array of positive integers `nums` and a positive integer `target`, return the length of the **shortest contiguous subarray** whose sum is greater than or equal to `target`. If no such subarray exists, return `0`.

A **subarray** is a consecutive sequence of elements within the array.

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
```'
WHERE slug = 'shortest-cover';

UPDATE problem_translations
SET description = 'Given an array of positive integers `nums` and a positive integer `target`, return the length of the **shortest contiguous subarray** whose sum is greater than or equal to `target`. If no such subarray exists, return `0`.

A **subarray** is a consecutive sequence of elements within the array.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-cover')
  AND locale = 'en';

------------------------------------------------------------
-- fruit-picker (Fruit Picker / Fruit Into Baskets)
------------------------------------------------------------
UPDATE problems
SET description = 'You are given an integer array `items` where each element represents a category. Your goal is to find the **longest contiguous segment** of `items` that contains **at most 2 distinct categories**.

Return the length of that longest segment.

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
```'
WHERE slug = 'fruit-picker';

UPDATE problem_translations
SET description = 'You are given an integer array `items` where each element represents a category. Your goal is to find the **longest contiguous segment** of `items` that contains **at most 2 distinct categories**.

Return the length of that longest segment.

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
```'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fruit-picker')
  AND locale = 'en';
