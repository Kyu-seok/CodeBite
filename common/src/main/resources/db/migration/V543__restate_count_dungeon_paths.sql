-- V543: count-dungeon-paths restated, title unchanged. The statement named
-- countGateRoutes, left over from another theme, and the Python Starter Code had
-- unique_paths; both become countPaths. The stated bound rows, cols <= 80 let the answer
-- pass the int the Starter Code returns (80 x 80 has C(158, 79) paths); the largest grid
-- in any case is 15 x 15 (40116600 paths), so the bound is now 15.
-- Starter method countGateRoutes / unique_paths -> countPaths in all 4 Starter Codes and
-- Drivers. Examples and the Diagram match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A dungeon is a grid of `rows` by `cols` tiles. Your character starts on the top-left tile, the treasure is on the bottom-right tile, and each move steps one tile down or one tile right. Return the number of distinct paths from the start to the treasure.

**Example 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Every path makes 3 moves down and 4 moves right in some order, and there are 35 ways to order those 7 moves.
```

```diagram-grid
cells: [[".",".",".",".","."],[".",".",".",".","."],[".",".",".",".","."],[".",".",".",".","."]]
blank: "."
```

**Example 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: A path moves down exactly once, and it can do so in any of the 6 columns.
```$$,
    constraints = $$- `1 <= rows, cols <= 15`$$
WHERE slug = $$count-dungeon-paths$$;

UPDATE problem_translations SET
    description = $$던전은 `rows`행 `cols`열의 타일 격자입니다. 캐릭터는 왼쪽 위 타일에서 출발하고 보물은 오른쪽 아래 타일에 있으며, 한 번에 한 칸 아래나 한 칸 오른쪽으로만 움직입니다. 출발 타일에서 보물까지 가는 서로 다른 경로의 수를 반환하세요.

**예시 1:**
```
입력: rows = 4, cols = 5
출력: 35
설명: 모든 경로는 아래로 3번, 오른쪽으로 4번 움직이며, 이 7번의 이동을 배열하는 방법은 35가지입니다.
```

```diagram-grid
cells: [[".",".",".",".","."],[".",".",".",".","."],[".",".",".",".","."],[".",".",".",".","."]]
blank: "."
```

**예시 2:**
```
입력: rows = 2, cols = 6
출력: 6
설명: 경로는 아래로 정확히 한 번 내려가며, 6개 열 중 어느 열에서든 내려갈 수 있습니다.
```$$,
    constraints = $$- `1 <= rows, cols <= 15`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-dungeon-paths$$);
