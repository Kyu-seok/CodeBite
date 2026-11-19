-- V404: min-stamina-checkpoints, text restated. The text switched from checkpoints to
-- undefined "tiles", and said a checkpoint costs stamina "when you land" though the
-- starting checkpoint is paid too (Example 1 pays 2 at the start). The constraint
-- effort[i] <= 800 was false (a hidden case has 1000). Starter method pickLeastEffort ->
-- minStaminaToFinish, parameter effort -> cost (the Drivers already said cost). Examples
-- match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A platformer level has `n` checkpoints in a row, numbered `0` to `n - 1`. Standing on checkpoint `i` costs `cost[i]` stamina. Return the minimum total stamina needed to get past the last checkpoint.

- You start on checkpoint `0` or checkpoint `1`, your choice.
- From checkpoint `i` you jump forward to checkpoint `i + 1` or `i + 2`.
- You pay `cost[i]` for every checkpoint you stand on, the starting one included.
- You finish when a jump takes you past checkpoint `n - 1`.

**Example 1:**
```
Input: cost = [4,2,8,3,5,6]
Output: 10
Explanation: Start on checkpoint 1 (pay 2), jump to checkpoint 3 (pay 3), jump to checkpoint 5 (pay 5), then jump past the end. Total 2 + 3 + 5 = 10.
```

**Example 2:**
```
Input: cost = [7,1,7,1,7]
Output: 2
Explanation: Start on checkpoint 1 (pay 1), jump to checkpoint 3 (pay 1), then jump two past the end. Total 1 + 1 = 2.
```$$,
    constraints = $$- `2 <= cost.length <= 2 * 10^3`
- `0 <= cost[i] <= 1000`$$
WHERE slug = $$min-stamina-checkpoints$$;

UPDATE problem_translations SET
    description = $$플랫포머 게임의 한 레벨에 `0`번부터 `n - 1`번까지 번호가 매겨진 `n`개의 체크포인트가 한 줄로 있습니다. 체크포인트 `i`에 서면 스태미나 `cost[i]`를 소모합니다. 마지막 체크포인트를 지나가는 데 필요한 최소 총 스태미나를 반환하세요.

- `0`번 또는 `1`번 체크포인트 중 원하는 곳에서 시작합니다.
- 체크포인트 `i`에서는 체크포인트 `i + 1`이나 `i + 2`로 점프합니다.
- 시작한 체크포인트를 포함해, 서는 모든 체크포인트마다 그 비용 `cost[i]`를 지불합니다.
- 점프로 체크포인트 `n - 1`을 지나가면 끝납니다.

**예시 1:**
```
입력: cost = [4,2,8,3,5,6]
출력: 10
설명: 체크포인트 1에서 시작(2 지불), 체크포인트 3으로 점프(3 지불), 체크포인트 5로 점프(5 지불)한 뒤 끝을 지나 점프합니다. 합계 2 + 3 + 5 = 10입니다.
```

**예시 2:**
```
입력: cost = [7,1,7,1,7]
출력: 2
설명: 체크포인트 1에서 시작(1 지불), 체크포인트 3으로 점프(1 지불)한 뒤 두 칸 점프해 끝을 지나갑니다. 합계 1 + 1 = 2입니다.
```$$,
    constraints = $$- `2 <= cost.length <= 2 * 10^3`
- `0 <= cost[i] <= 1000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$min-stamina-checkpoints$$);
