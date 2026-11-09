-- V299: restate walls-and-gates (#231, part of #193). The Examples showed a 4x4 grid
-- and a lone wall that are no sample Test Case; they now show samples 1 and 2
-- (order_index 1 and 2), with the Diagram redrawn to Example 1's data and a second
-- Diagram under Example 2, in English and Korean. Text only: Slug, title,
-- constraints, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$You're given an `m × n` grid `rooms`, where each cell is one of:
- `-1` — a **wall** that blocks movement.
- `0` — a **gate**.
- `2147483647` (i.e. INT_MAX) — an **empty room**.

Mutate `rooms` **in place** so each empty room contains the distance, in steps (up/down/left/right), to its nearest gate. Empty rooms with no reachable gate stay at `2147483647`.

**Example 1:**
```
Input: rooms = [[2147483647,0],[2147483647,2147483647]]
Output: [[1,0],[2,1]]
```

```diagram-grid
cells: [["INF",0],["INF","INF"]]
after: [[1,0],[2,1]]
```

The only gate is at `(0, 1)`. The rooms beside it are 1 step away, and the room at `(1, 0)` is 2 steps away.

**Example 2:**
```
Input: rooms = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
```

```diagram-grid
cells: [[0,"INF","INF"],[-1,"INF",-1],["INF","INF",0]]
after: [[0,1,2],[-1,2,-1],[2,1,0]]
```

There are two gates, at `(0, 0)` and `(2, 2)`. Each room takes the distance to whichever gate is nearer; the centre room is 2 steps from both. Walls stay `-1`.$$
WHERE slug = $$walls-and-gates$$;

UPDATE problem_translations SET
    description = $$`m × n` 격자 `rooms`가 주어집니다. 각 칸은 다음 셋 중 하나입니다:
- `-1` — **벽**(이동 불가).
- `0` — **문**.
- `2147483647`(즉, INT_MAX) — **빈 방**.

각 빈 방에 가장 가까운 문까지의 거리(상하좌우로 이동한 칸 수)를 채워 `rooms`를 **제자리에서** 갱신하세요. 어떤 문에도 도달할 수 없는 빈 방은 그대로 `2147483647`로 둡니다.

**예시 1:**
```
입력: rooms = [[2147483647,0],[2147483647,2147483647]]
출력: [[1,0],[2,1]]
```

```diagram-grid
cells: [["INF",0],["INF","INF"]]
after: [[1,0],[2,1]]
```

문은 `(0, 1)` 하나뿐입니다. 문 옆의 두 방은 1칸, `(1, 0)`의 방은 2칸 떨어져 있습니다.

**예시 2:**
```
입력: rooms = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
출력: [[0,1,2],[-1,2,-1],[2,1,0]]
```

```diagram-grid
cells: [[0,"INF","INF"],[-1,"INF",-1],["INF","INF",0]]
after: [[0,1,2],[-1,2,-1],[2,1,0]]
```

문이 `(0, 0)`과 `(2, 2)` 두 곳에 있습니다. 각 방은 더 가까운 문까지의 거리를 가지며, 가운데 방은 두 문 모두에서 2칸입니다. 벽은 `-1` 그대로입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$walls-and-gates$$);
