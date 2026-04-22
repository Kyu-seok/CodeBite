-- V123: Phase 2 pilot — rewrite description, constraints, and sample test
-- cases for shelf-stock-pair so the problem surface reads as a domain task
-- (warehouse restock picking) rather than a canonical puzzle restatement.
-- Hidden test cases are not touched.

UPDATE problems SET description = $$
Your warehouse inventory system tracks the widget count on each shelf as an array `nums`. When a restock request comes in for exactly `target` widgets, the picker must combine **two different shelves** whose counts add up to the request.

Return the indices of the two shelves whose widget counts sum to `target`. Each request is guaranteed to have exactly one valid pair, and the same shelf may not be pulled from twice. The two indices may be returned in any order.

**Example 1:**
```
Input: nums = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: nums[1] + nums[2] = 11 + 19 = 30.
```

**Example 2:**
```
Input: nums = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: nums[0] + nums[2] = 8 + 6 = 14.
```
$$
WHERE slug = 'shelf-stock-pair';

UPDATE problems SET constraints = $$
- `2 <= nums.length <= 10^5`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`
- Exactly one pair of shelves satisfies the request.
$$
WHERE slug = 'shelf-stock-pair';

-- Rewrite the two sample test cases in place (preserving test case IDs so
-- historical submission_results FKs remain valid). Hidden cases are untouched.
UPDATE test_cases SET input = E'[4,11,19,23]\n30', expected_output = '[1,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shelf-stock-pair')
  AND is_sample = TRUE AND order_index = 1;

UPDATE test_cases SET input = E'[8,14,6]\n14', expected_output = '[0,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shelf-stock-pair')
  AND is_sample = TRUE AND order_index = 2;
