-- V286: restate n-queens (#218, part of #193). Examples 1 and 2 showed LeetCode's data
-- (n = 4 and n = 1), which is no sample Test Case; they now show samples 1 and 2 (n = 5,
-- its ten boards in the Drivers' sorted order, and n = 3, no arrangement) in both
-- languages. Example 1's two Diagrams are redrawn as two of the ten n = 5 boards.
-- Slug, title, constraints, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$Place `n` queens on an `n × n` chessboard so that no two queens attack each other — meaning no two share a row, column, or diagonal. Return every distinct arrangement.

Each arrangement is a list of `n` strings of length `n`, where `'Q'` marks a queen and `'.'` marks an empty square. Order of arrangements in the output does not matter.

**Example 1:**
```
Input: n = 5
Output: [["....Q","..Q..","Q....","...Q.",".Q..."],["....Q",".Q...","...Q.","Q....","..Q.."],["...Q.",".Q...","....Q","..Q..","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["..Q..","....Q",".Q...","...Q.","Q...."],["..Q..","Q....","...Q.",".Q...","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],[".Q...","...Q.","Q....","..Q..","....Q"],["Q....","...Q.",".Q...","....Q","..Q.."],["Q....","..Q..","....Q",".Q...","...Q."]]
Explanation: Ten distinct safe placements exist for n = 5. Two of them are drawn below.
```

```diagram-grid
cells: [[".",".","Q",".","."],["Q",".",".",".","."],[".",".",".","Q","."],[".","Q",".",".","."],[".",".",".",".","Q"]]
blank: "."
```

```diagram-grid
cells: [[".","Q",".",".","."],[".",".",".","Q","."],["Q",".",".",".","."],[".",".","Q",".","."],[".",".",".",".","Q"]]
blank: "."
```

**Example 2:**
```
Input: n = 3
Output: []
Explanation: Three queens can't be placed on a 3 × 3 board without two of them attacking each other, so no arrangement exists.
```$$
WHERE slug = $$n-queens$$;

UPDATE problem_translations SET
    description = $$`n × n` 체스판 위에 `n`개의 퀸을, 어떤 두 퀸도 서로 공격하지 않도록 — 즉 같은 행, 같은 열, 같은 대각선을 공유하지 않도록 — 놓으세요. 가능한 모든 서로 다른 배치를 반환하세요.

각 배치는 길이가 `n`인 문자열 `n`개의 리스트입니다. `'Q'`는 퀸이 놓인 칸, `'.'`은 빈 칸을 나타냅니다. 결과 배치들의 출력 순서는 상관없습니다.

**예시 1:**
```
입력: n = 5
출력: [["....Q","..Q..","Q....","...Q.",".Q..."],["....Q",".Q...","...Q.","Q....","..Q.."],["...Q.",".Q...","....Q","..Q..","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["..Q..","....Q",".Q...","...Q.","Q...."],["..Q..","Q....","...Q.",".Q...","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],[".Q...","...Q.","Q....","..Q..","....Q"],["Q....","...Q.",".Q...","....Q","..Q.."],["Q....","..Q..","....Q",".Q...","...Q."]]
설명: `n = 5`일 때 열 가지 서로 다른 안전한 배치가 존재합니다. 그중 두 가지를 아래에 그렸습니다.
```

```diagram-grid
cells: [[".",".","Q",".","."],["Q",".",".",".","."],[".",".",".","Q","."],[".","Q",".",".","."],[".",".",".",".","Q"]]
blank: "."
```

```diagram-grid
cells: [[".","Q",".",".","."],[".",".",".","Q","."],["Q",".",".",".","."],[".",".","Q",".","."],[".",".",".",".","Q"]]
blank: "."
```

**예시 2:**
```
입력: n = 3
출력: []
설명: `3 × 3` 체스판에는 세 퀸을 서로 공격하지 않게 놓을 방법이 없으므로, 가능한 배치가 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$n-queens$$);
