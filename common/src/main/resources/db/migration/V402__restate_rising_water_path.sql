-- V402: rising-water-path, text restated. Example 2 called the answer "the lowest peak
-- along the best route" where it is the highest tile on it. The constraints
-- elevation < n * n and "every height is distinct" were false (hidden cases repeat 10
-- and 100): loosened to the heights the cases use. That the start tile must be walkable
-- too was only implied (Example 1 starts on height 1). Starter method
-- crossFloodedCorridors -> earliestCrossingTime; the Drivers' grid -> elevation. Examples
-- match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$An `n x n` grid `elevation` gives the height of each tile: `elevation[r][c]` is the height of the tile at row `r`, column `c`. Water rises over time, and at time `t` a tile is walkable when its height is at most `t`. Return the earliest time `t` at which you can walk from the top-left tile `(0, 0)` to the bottom-right tile `(n - 1, n - 1)`.

- You move up, down, left or right, one tile at a time, and only onto walkable tiles. The start and end tiles must be walkable too.
- Moving takes no time, so the answer is the smallest possible height of the highest tile on a route from `(0, 0)` to `(n - 1, n - 1)`.

**Example 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The end tile itself has height 3, so no route exists before t = 3. At t = 3 every tile is walkable.
```

**Example 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) climbs no higher than 14, the end tile's own height, so it is walkable at t = 14 and no route is walkable sooner.
```

```diagram-grid
cells: [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
highlight: [[0,0],[1,0],[2,0],[3,0],[3,1],[3,2],[3,3]]
```$$,
    constraints = $$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] <= 3600`
- Heights may repeat.$$
WHERE slug = $$rising-water-path$$;

UPDATE problem_translations SET
    description = $$`n x n` 격자 `elevation`은 각 타일의 높이를 나타냅니다. `elevation[r][c]`는 행 `r`, 열 `c`에 있는 타일의 높이입니다. 시간이 지나며 수위가 올라가고, 시각 `t`에는 높이가 `t` 이하인 타일을 밟을 수 있습니다. 왼쪽 위 타일 `(0, 0)`에서 오른쪽 아래 타일 `(n - 1, n - 1)`까지 걸어갈 수 있는 가장 이른 시각 `t`를 반환하세요.

- 한 번에 한 칸씩 위, 아래, 왼쪽, 오른쪽으로 이동하며, 밟을 수 있는 타일로만 이동합니다. 출발 타일과 도착 타일도 밟을 수 있어야 합니다.
- 이동에는 시간이 걸리지 않으므로, 답은 `(0, 0)`에서 `(n - 1, n - 1)`까지 가는 경로에서 가장 높은 타일의 높이를 가능한 한 낮춘 값입니다.

**예시 1:**
```
입력: elevation = [[1,0],[2,3]]
출력: 3
설명: 도착 타일 자체의 높이가 3이므로 t = 3 전에는 어떤 경로도 없습니다. t = 3에는 모든 타일을 밟을 수 있습니다.
```

**예시 2:**
```
입력: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
출력: 14
설명: 경로 (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3)에서 가장 높은 타일은 도착 타일 자체의 높이 14입니다. 따라서 t = 14에 이 경로를 걸을 수 있고, 그보다 일찍 걸을 수 있는 경로는 없습니다.
```

```diagram-grid
cells: [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
highlight: [[0,0],[1,0],[2,0],[3,0],[3,1],[3,2],[3,3]]
```$$,
    constraints = $$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] <= 3600`
- 높이는 서로 같을 수 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rising-water-path$$);
