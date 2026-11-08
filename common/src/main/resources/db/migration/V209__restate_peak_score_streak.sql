-- V209: restate peak-score-streak (#170, part of #168). The text in both languages
-- named the array `scores` while the Starter Code (peakReadingSum(nums)) names it `nums`.
-- Every `scores` becomes `nums` in the description and constraints, English and Korean;
-- the examples still match the sample test cases, which are unchanged. Slug, title,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Each entry in `nums` is the points gained or lost on a single note in a rhythm game. Find the contiguous, non-empty window of notes with the largest sum and return that sum.

**Example 1:**
```
Input: nums = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, the max.
```

**Example 2:**
```
Input: nums = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. The whole array also sums to 10.
```$$,
    constraints = $$- `1 <= nums.length <= 2 * 10^5`
- `|nums[i]| <= 10^8`$$
WHERE slug = $$peak-score-streak$$;

UPDATE problem_translations SET
    description = $$리듬 게임에서 노트 하나를 쳤을 때 얻거나 잃는 점수가 정수 배열 `nums`의 각 원소에 들어 있습니다. 합이 가장 큰 **연속된 비어 있지 않은 노트 구간**을 찾아 그 합을 반환하세요.

**예시 1:**
```
입력: nums = [3,-2,5,-1,2,-8,4,3]
출력: 7
설명: 구간 `[3,-2,5,-1,2]`의 합 7이 가장 큽니다.
```

**예시 2:**
```
입력: nums = [2,1,-3,6,4]
출력: 10
설명: 구간 `[6,4]`의 합이 10입니다. 배열 전체의 합도 10이라 둘 다 최댓값이 됩니다.
```$$,
    constraints = $$- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-score-streak$$);
