-- V351: finish-the-level restated, title unchanged. "A 0 means tile i is a pit" said landing
-- on it fails, yet [1,0] and [2,0,0] are true: a 0 only means you can't jump on from that
-- tile. The statement now says what jumps[i] lets you reach, and that a one-tile level is
-- already finished; the Korean title 레벨 클리어 가능? is now 레벨 끝까지 가기.
-- Starter method canFinishLine -> canFinishLevel, parameter slack -> jumps, in all 4
-- Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A platformer level has `n` tiles, numbered `0` to `n - 1`, and you start on tile `0`. `jumps[i]` is the farthest you can jump forward from tile `i`: from tile `i` you can land on any tile from `i + 1` to `i + jumps[i]`. A `0` means you can't move on from that tile.

Return `true` if you can reach the last tile, `n - 1`, and `false` otherwise. A level of one tile is already finished.

**Example 1:**
```
Input: jumps = [2,1,3,1,1,2]
Output: true
Explanation: Jump 2 from tile 0 to tile 2, then 3 from tile 2 to tile 5, the last tile.
```

**Example 2:**
```
Input: jumps = [2,0,0,1,3]
Output: false
Explanation: From tile 0 you can reach only tiles 1 and 2, and both have jumps 0, so you are stuck. Tiles 3 and 4 can't be reached.
```$$,
    constraints = $$- `1 <= jumps.length <= 2 * 10^5`
- `0 <= jumps[i] <= 8 * 10^4`$$
WHERE slug = $$finish-the-level$$;

UPDATE problem_translations SET
    title = $$레벨 끝까지 가기$$,
    description = $$플랫포머 레벨에 `0`부터 `n - 1`까지 번호가 붙은 타일 `n`개가 있고, 타일 `0`에서 출발합니다. `jumps[i]`는 타일 `i`에서 앞으로 점프할 수 있는 최대 거리로, 타일 `i`에서는 `i + 1`부터 `i + jumps[i]`까지의 어느 타일에든 착지할 수 있습니다. `0`이면 그 타일에서 더 나아갈 수 없습니다.

마지막 타일 `n - 1`에 도달할 수 있으면 `true`, 없으면 `false`를 반환하세요. 타일이 하나뿐인 레벨은 이미 끝에 도착한 것입니다.

**예시 1:**
```
입력: jumps = [2,1,3,1,1,2]
출력: true
설명: 타일 0에서 2칸 점프해 타일 2로, 타일 2에서 3칸 점프해 마지막 타일 5로 갑니다.
```

**예시 2:**
```
입력: jumps = [2,0,0,1,3]
출력: false
설명: 타일 0에서는 타일 1과 2에만 갈 수 있는데, 둘 다 jumps가 0이라 더 나아갈 수 없습니다. 타일 3과 4에는 도달할 수 없습니다.
```$$,
    constraints = $$- `1 <= jumps.length <= 2 * 10^5`
- `0 <= jumps[i] <= 8 * 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$finish-the-level$$);
