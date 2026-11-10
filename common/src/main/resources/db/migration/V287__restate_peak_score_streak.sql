-- V287: restate peak-score-streak (#219, part of #193). Example 2 showed [2,1,-3,6,4] where
-- the second sample Test Case is [-4]; Example 2 now shows that sample, in English and
-- Korean, with its Explanation rewritten. Slug, title, constraints, Test Cases, Starter
-- Code and Drivers are unchanged.

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
Input: nums = [-4]
Output: -4
Explanation: The window can't be empty, so the only window is [-4], and the answer is negative.
```$$
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
입력: nums = [-4]
출력: -4
설명: 구간은 비어 있을 수 없으므로 가능한 구간은 `[-4]` 하나뿐이고, 답은 음수가 됩니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$peak-score-streak$$);
