-- V514: count-desk-clusters restated, Slug and title unchanged. The first sentence now states
-- the task, and the examples list each cluster's cells as (row, column), 0-indexed, where
-- Example 1 used coordinates without saying so and called a zigzag an "L". Starter method
-- tallyPlantedRegions -> countClusters in all 4 Starter Codes and Drivers. Examples match the
-- sample test cases, which are unchanged, and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$Given an `m x n` grid `board` where `"1"` marks an occupied desk and `"0"` an empty one, return the number of **clusters**.

A cluster is a maximal group of occupied desks connected up, down, left or right. Desks that touch only diagonally are not connected.

**Example 1:**
```
Input: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: With cells as (row, column), 0-indexed, the clusters are {(0,1),(0,2),(1,0),(1,1)}, {(0,5),(1,5)}, {(2,3),(3,3),(3,4)}, {(3,0),(4,0)} and {(4,5)}.
```

```diagram-grid
cells: [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
```

**Example 2:**
```
Input: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: The clusters are {(0,0),(0,1),(1,1)} and {(1,3),(2,3)}.
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 250`
- `board[i][j]` is `"0"` or `"1"`.$$
WHERE slug = $$count-desk-clusters$$;

UPDATE problem_translations SET
    description = $$`"1"`은 책상이 있는 칸, `"0"`은 빈 칸인 `m x n` 격자 `board`가 주어질 때, **그룹**의 개수를 반환하세요.

그룹은 상하좌우로 이어진 책상들의 최대 묶음입니다. 대각선으로만 맞닿은 책상은 이어진 것이 아닙니다.

**예시 1:**
```
입력: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
출력: 5
설명: 칸을 0부터 센 (행, 열)로 쓰면 그룹은 {(0,1),(0,2),(1,0),(1,1)}, {(0,5),(1,5)}, {(2,3),(3,3),(3,4)}, {(3,0),(4,0)}, {(4,5)}입니다.
```

```diagram-grid
cells: [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
```

**예시 2:**
```
입력: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
출력: 2
설명: 그룹은 {(0,0),(0,1),(1,1)}과 {(1,3),(2,3)}입니다.
```$$,
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 250`
- `board[i][j]`는 `"0"` 또는 `"1"`입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-desk-clusters$$);
