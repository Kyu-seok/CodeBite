-- V570: connect-water-bowls restated, English title unchanged. The first sentence now states
-- the task, Example 3 (sample 3) shows that one bowl needs no hose, and the coordinate bound
-- drops from 10^8 to 10^5 so the answer always fits the int return type (every case is within
-- 100). Korean title 반려동물 급수대 연결 -> 물그릇 연결, to match the English. Starter
-- method layPipeNetwork (Python min_cost) -> minHoseLength in all 4 Starter Codes and Drivers.
-- Examples and their Diagram match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given the grid locations of water bowls for neighborhood cats, return the minimum total hose length that connects every bowl to every other bowl, directly or through other bowls. `bowls[i] = [xi, yi]` is bowl `i`'s location, and a hose between bowls `i` and `j` runs along the grid, so it is `|xi - xj| + |yi - yj|` meters long.

**Example 1:**
```
Input: bowls = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying hoses [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every bowl for a total of 13 meters.
```

```diagram-graph
edges: [[0,1],[0,2],[0,3],[1,2],[1,3],[2,3]]
directed: false
```

**Example 2:**
```
Input: bowls = [[0,0],[2,0]]
Output: 2
Explanation: Only one hose of length 2 is needed to join the two bowls.
```

**Example 3:**
```
Input: bowls = [[0,0]]
Output: 0
Explanation: A single bowl needs no hose.
```$$,
    constraints = $$- `1 <= bowls.length <= 1200`
- `-10^5 <= xi, yi <= 10^5`
- All bowl coordinates are distinct$$
WHERE slug = $$connect-water-bowls$$;

UPDATE problem_translations SET
    title = $$물그릇 연결$$,
    description = $$동네 고양이들의 물그릇 격자 좌표가 주어질 때, 모든 물그릇이 직접 또는 다른 물그릇을 거쳐 서로 이어지도록 하는 최소 총 호스 길이를 반환하세요. `bowls[i] = [xi, yi]`는 물그릇 `i`의 위치이며, 물그릇 `i`와 `j`를 잇는 호스는 격자를 따라 지나가므로 길이가 `|xi - xj| + |yi - yj|` 미터입니다.

**예시 1:**
```
입력: bowls = [[4,4],[4,3],[6,7],[10,2]]
출력: 13
설명: [4,4]-[4,3](길이 1), [4,4]-[6,7](길이 5), [4,3]-[10,2](길이 7) 호스를 깔면 모든 그릇이 연결되며 합이 13미터입니다.
```

```diagram-graph
edges: [[0,1],[0,2],[0,3],[1,2],[1,3],[2,3]]
directed: false
```

**예시 2:**
```
입력: bowls = [[0,0],[2,0]]
출력: 2
설명: 두 그릇을 잇는 데에는 길이 2짜리 호스 하나면 충분합니다.
```

**예시 3:**
```
입력: bowls = [[0,0]]
출력: 0
설명: 물그릇이 하나뿐이면 호스가 필요 없습니다.
```$$,
    constraints = $$- `1 <= bowls.length <= 1200`
- `-10^5 <= xi, yi <= 10^5`
- 모든 그릇 좌표는 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$connect-water-bowls$$);
