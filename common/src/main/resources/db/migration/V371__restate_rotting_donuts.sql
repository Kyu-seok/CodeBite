-- V371: rotting-donuts, text restated. Example 3 said "rotten" where the statement defines
-- "stale", and returning 0 when no fresh donut is left at the start was only implied (the
-- hidden cases [[0]] and [[2,2],[2,2]] expect it). Starter method spreadContaminationWave
-- (oranges_rotting in Python) -> minutesUntilStale, parameter ward -> tray, the statement's
-- words. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$An `m x n` grid `tray` holds donuts. Each cell is one of three states:

- `0` — an **empty slot** (no donut)
- `1` — a **fresh donut**
- `2` — a **stale donut**

Every minute, each fresh donut that shares an edge (up, down, left or right) with a stale donut becomes stale. Return the number of minutes until no fresh donut is left. Return `0` if the tray holds no fresh donut at the start, and `-1` if some fresh donut can never become stale.

**Example 1:**
```
Input: tray = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: Staleness spreads one cell per minute from the stale donut at row 0, column 0. The farthest fresh donut, at row 2, column 2, goes stale in minute 4.
```

```diagram-grid
cells: [[2,1,1],[1,0,1],[1,1,1]]
```

**Example 2:**
```
Input: tray = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: The stale donut at row 0, column 0 is walled off by empty slots, so no fresh donut ever goes stale.
```

**Example 3:**
```
Input: tray = [[2,0],[0,1]]
Output: -1
Explanation: The stale donut and the fresh one share no edge, and the cells between them are empty slots, so the fresh donut never goes stale.
```$$,
    constraints = $$- `m == tray.length`
- `n == tray[i].length`
- `1 <= m, n <= 10`
- `tray[i][j]` is `0`, `1`, or `2`.$$
WHERE slug = $$rotting-donuts$$;

UPDATE problem_translations SET
    description = $$`m x n` 격자 `tray`에 도넛이 놓여 있습니다. 각 칸은 다음 세 가지 상태 중 하나입니다.

- `0` — **빈 자리** (도넛 없음)
- `1` — **신선한 도넛**
- `2` — **상한 도넛**

매 분마다, 상한 도넛과 변을 맞댄(위, 아래, 왼쪽, 오른쪽) 신선한 도넛은 모두 상합니다. 신선한 도넛이 하나도 남지 않을 때까지 걸리는 분 수를 반환하세요. 처음부터 신선한 도넛이 없으면 `0`을, 끝내 상하지 않는 신선한 도넛이 있으면 `-1`을 반환합니다.

**예시 1:**
```
입력: tray = [[2,1,1],[1,0,1],[1,1,1]]
출력: 4
설명: 0행 0열의 상한 도넛에서 1분에 한 칸씩 퍼져 나갑니다. 가장 먼 2행 2열의 신선한 도넛은 4분째에 상합니다.
```

```diagram-grid
cells: [[2,1,1],[1,0,1],[1,1,1]]
```

**예시 2:**
```
입력: tray = [[2,0,1],[0,0,1],[1,1,1]]
출력: -1
설명: 0행 0열의 상한 도넛이 빈 자리에 둘러싸여 있어, 어떤 신선한 도넛도 상하지 않습니다.
```

**예시 3:**
```
입력: tray = [[2,0],[0,1]]
출력: -1
설명: 상한 도넛과 신선한 도넛이 변을 맞대지 않고 그 사이가 빈 자리뿐이라, 신선한 도넛은 끝내 상하지 않습니다.
```$$,
    constraints = $$- `m == tray.length`
- `n == tray[i].length`
- `1 <= m, n <= 10`
- `tray[i][j]`는 `0`, `1`, 또는 `2`입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rotting-donuts$$);
