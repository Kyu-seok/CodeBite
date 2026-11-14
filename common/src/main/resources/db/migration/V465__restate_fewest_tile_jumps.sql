-- V465: fewest-tile-jumps restated, title unchanged. The parameter fuel and the method
-- minVanHops (a van) clashed with the platformer story: fuel -> maxJump and minVanHops ->
-- minJumps in all 4 Starter Codes and Drivers. The task now comes first, and Example 2 no
-- longer mentions a tile 7 that its 6-tile level doesn't have. Examples match the sample test
-- cases, which are unchanged.

UPDATE problems SET
    description = $$Return the fewest jumps needed to get from tile `0` to the last tile, `n - 1`, of a platformer level with `n` tiles in a row. `maxJump[i]` is the longest forward jump from tile `i`: from tile `i` you can land on any tile from `i + 1` to `i + maxJump[i]`.

The last tile is always reachable. When the level is a single tile, you are already there and the answer is `0`.

**Example 1:**
```
Input: maxJump = [1,4,2,1,3,1,2]
Output: 3
Explanation: From tile 0 the only jump is to tile 1. From tile 1 you can reach tiles 2 to 5; jump to tile 4, which can reach tile 6, the last tile. No two jumps get there.
```

**Example 2:**
```
Input: maxJump = [3,1,1,4,2,1]
Output: 2
Explanation: Jump from tile 0 to tile 3 (3 tiles ahead), then from tile 3 to tile 5, the last tile, which is within its reach of 4.
```$$,
    constraints = $$- `1 <= maxJump.length <= 2 * 10^3`
- `0 <= maxJump[i] <= 1000`
- The last tile is reachable from tile `0`.$$
WHERE slug = $$fewest-tile-jumps$$;

UPDATE problem_translations SET
    description = $$타일 `n`개가 한 줄로 놓인 플랫포머 레벨에서, 타일 `0`에서 마지막 타일 `n - 1`까지 가는 데 필요한 최소 점프 횟수를 반환하세요. `maxJump[i]`는 타일 `i`에서 앞으로 뛸 수 있는 최대 거리입니다. 타일 `i`에서는 `i + 1`부터 `i + maxJump[i]`까지의 어느 타일에든 내려설 수 있습니다.

마지막 타일에는 항상 도달할 수 있습니다. 레벨이 타일 하나뿐이면 이미 도착한 것이므로 답은 `0`입니다.

**예시 1:**
```
입력: maxJump = [1,4,2,1,3,1,2]
출력: 3
설명: 타일 0에서는 타일 1로만 뛸 수 있습니다. 타일 1에서는 타일 2부터 5까지 닿으니 타일 4로 뛰고, 타일 4에서 마지막 타일인 타일 6에 닿습니다. 두 번의 점프로는 도착할 수 없습니다.
```

**예시 2:**
```
입력: maxJump = [3,1,1,4,2,1]
출력: 2
설명: 타일 0에서 3칸 앞의 타일 3으로 뛰고, 타일 3에서 최대 4칸 안에 있는 마지막 타일 5로 뜁니다.
```$$,
    constraints = $$- `1 <= maxJump.length <= 2 * 10^3`
- `0 <= maxJump[i] <= 1000`
- 마지막 타일은 타일 `0`에서 반드시 도달할 수 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fewest-tile-jumps$$);
