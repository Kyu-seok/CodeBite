-- V463: slowest-snack-rate restated, title unchanged. Two constraints were false: hidden case 5
-- has a pile of 1000000000 and hidden case 8 has hours = 312884469, both over the stated 10^8;
-- both bounds are now 10^9 (the audit flagged only the pile). The task now comes first and
-- Example 3 is explained. Starter method slowestConveyorSpeed (Python min_eating_speed) ->
-- minEatingRate in all 4 Starter Codes and Drivers. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$Return the smallest integer eating rate `k` that lets you finish every pile of candy within `hours` hours. `piles[i]` is the number of pieces in pile `i`.

Each hour you pick one pile and eat up to `k` pieces from it. If the pile has fewer than `k` pieces left, you finish it and do nothing for the rest of that hour. So pile `i` takes `ceil(piles[i] / k)` hours.

**Example 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At rate 6 the hours per pile are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9. Rate 5 needs 1 + 2 + 3 + 4 = 10 hours.
```

**Example 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 piles and only 5 hours, every pile must be finished in a single hour, so the rate must be at least the largest pile.
```

**Example 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
Explanation: At rate 25 the hours per pile are 2, 1, 1, 2, 1, totaling 7. Rate 24 needs 2 + 2 + 1 + 2 + 1 = 8 hours.
```$$,
    constraints = $$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^9`
- `1 <= piles[i] <= 10^9`$$
WHERE slug = $$slowest-snack-rate$$;

UPDATE problem_translations SET
    description = $$사탕 더미를 모두 `hours`시간 안에 먹어 치울 수 있는 가장 작은 정수 먹는 속도 `k`를 반환하세요. `piles[i]`는 `i`번 더미의 사탕 개수입니다.

한 시간마다 더미 하나를 골라 거기서 최대 `k`개까지 먹습니다. 남은 사탕이 `k`개보다 적으면 그 더미를 다 먹고 그 시간의 나머지는 쉽니다. 따라서 `i`번 더미에는 `ceil(piles[i] / k)`시간이 걸립니다.

**예시 1:**
```
입력: piles = [5,8,12,20], hours = 9
출력: 6
설명: 속도 6일 때 더미별 소요 시간은 ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4로 합이 9시간입니다. 속도 5라면 1 + 2 + 3 + 4 = 10시간이 걸립니다.
```

**예시 2:**
```
입력: piles = [40,25,18,33,12], hours = 5
출력: 40
설명: 더미가 5개인데 시간도 5시간뿐이라 모든 더미를 한 시간 안에 먹어야 하므로, 속도는 가장 큰 더미 이상이어야 합니다.
```

**예시 3:**
```
입력: piles = [40,25,18,33,12], hours = 7
출력: 25
설명: 속도 25일 때 더미별 소요 시간은 2, 1, 1, 2, 1로 합이 7시간입니다. 속도 24라면 2 + 2 + 1 + 2 + 1 = 8시간이 걸립니다.
```$$,
    constraints = $$- `1 <= piles.length <= 2 * 10^5`
- `piles.length <= hours <= 10^9`
- `1 <= piles[i] <= 10^9`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$slowest-snack-rate$$);
