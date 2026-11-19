-- V565: capture-enclosed-tiles restated, Slug and title unchanged. "Return the modified board"
-- contradicted the in-place, nothing-returned signature: the statement now says the function
-- returns nothing and the grader reads board after the call. Example 1 says its coordinates are
-- (row, column), 0-indexed. Starter method seizeEnclosedZones -> captureEnclosedTiles in all 4
-- Starter Codes and Drivers. Examples match the sample test cases, which are unchanged, and
-- Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$You're playing a territory game on an `m x n` grid `board`, where `'X'` is your tile and `'O'` is an enemy tile. An enemy tile survives when it can reach the border of the board by moving up, down, left or right through `'O'` tiles; an `'O'` on the border always survives. Every other `'O'` is **captured** and becomes `'X'`.

Change `board` **in place**: the function returns nothing, and the grader reads `board` after the call.

**Example 1:**
```
Input: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: With cells as (row, column), 0-indexed, the `'O'` at (1,1) and (2,2) are boxed in, so they flip. The `'O'` at (3,3) sits on the border and survives.
```

```diagram-grid
cells: [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
after: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
```

**Example 2:**
```
Input: board = [["O"]]
Output: [["O"]]
Explanation: On a 1 × 1 board the only cell is on the border, so the `'O'` survives.
```

**Example 3:**
```
Input: board = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: Both `'O'` cells are in the first column, on the border, so nothing changes.
```$$
WHERE slug = $$capture-enclosed-tiles$$;

UPDATE problem_translations SET
    description = $$`m x n` 격자 `board`에서 영토 게임을 하고 있습니다. `'X'`는 내 타일이고, `'O'`는 적 타일입니다. 적 타일은 상하좌우로 `'O'` 타일을 따라 이동해 보드의 테두리에 닿을 수 있으면 살아남고, 테두리 위의 `'O'`는 언제나 살아남습니다. 그 밖의 `'O'`는 모두 **점령**되어 `'X'`가 됩니다.

`board`를 **제자리에서** 바꾸세요. 함수는 아무것도 반환하지 않고, 채점기는 호출이 끝난 뒤의 `board`를 읽습니다.

**예시 1:**
```
입력: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
출력: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
설명: 칸을 0부터 센 (행, 열)로 쓰면, (1,1)과 (2,2)의 `'O'`는 사방이 막혀 있어 뒤집히고, (3,3)의 `'O'`는 테두리에 있어 그대로 남습니다.
```

```diagram-grid
cells: [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
after: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
```

**예시 2:**
```
입력: board = [["O"]]
출력: [["O"]]
설명: 1 × 1 보드에서는 유일한 칸이 테두리에 있으므로 `'O'`는 그대로 남습니다.
```

**예시 3:**
```
입력: board = [["O","X"],["O","X"]]
출력: [["O","X"],["O","X"]]
설명: 두 `'O'` 모두 첫 번째 열, 곧 테두리에 있으므로 아무것도 바뀌지 않습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$capture-enclosed-tiles$$);
