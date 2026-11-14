-- V322: top-raid-score -> kth-highest-raid-score, retitled "K-th Highest Raid Score". "Top"
-- read as the maximum, but the task is the k-th highest; the text also named the starter
-- method findBrightestTargets ("brightest targets"), unrelated to scores. The statement now
-- says k counts from 1, and the constraint on scores[i] is written as a range.
-- Starter method findBrightestTargets(scores, k) -> kthHighestScore(scores, k). Drivers and
-- Starter Code directories are renamed in the same commit. Examples match the sample test
-- cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$top-raid-score$$, id FROM problems WHERE slug = $$top-raid-score$$;

UPDATE problems SET
    slug = $$kth-highest-raid-score$$,
    title = $$K-th Highest Raid Score$$,
    description = $$Your guild's damage scores from a raid are in the integer array `scores`. Return the `k`-th highest score: the value at position `k`, counting from 1, when `scores` is sorted from highest to lowest.

Tied scores each take their own position: in `[8,3,5,5]` the 1st highest score is `8`, the 2nd is `5`, and the 3rd is also `5`.

**Example 1:**
```
Input: scores = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted from highest to lowest: [9,9,7,6,4,3,2]. Position 3 holds 7.
```

**Example 2:**
```
Input: scores = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted from highest to lowest: [15,12,11,8,8,5,5,3]. Position 4 holds 8.
```$$,
    constraints = $$- `1 <= k <= scores.length <= 2 * 10^5`
- `-10^8 <= scores[i] <= 10^8`$$
WHERE slug = $$top-raid-score$$;

UPDATE problem_translations SET
    title = $$K번째로 높은 레이드 점수$$,
    description = $$길드원들이 레이드에서 낸 데미지 점수가 정수 배열 `scores`에 들어 있습니다. `k`번째로 높은 점수, 즉 `scores`를 높은 순으로 정렬했을 때 1부터 세어 `k`번째 위치에 있는 값을 반환하세요.

같은 점수도 각각 한 자리를 차지합니다. `[8,3,5,5]`에서 1번째로 높은 점수는 `8`, 2번째는 `5`, 3번째도 `5`입니다.

**예시 1:**
```
입력: scores = [7,2,9,4,9,6,3], k = 3
출력: 7
설명: 높은 순으로 정렬하면 [9,9,7,6,4,3,2]이고, 3번째 위치의 값은 7입니다.
```

**예시 2:**
```
입력: scores = [12,5,8,5,8,15,3,11], k = 4
출력: 8
설명: 높은 순으로 정렬하면 [15,12,11,8,8,5,5,3]이고, 4번째 위치의 값은 8입니다.
```$$,
    constraints = $$- `1 <= k <= scores.length <= 2 * 10^5`
- `-10^8 <= scores[i] <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$kth-highest-raid-score$$);
