-- V493: zero-out-rows-cols restated, title unchanged. The task now comes first, says only the
-- original zeros wipe, and Example 2 says rows and columns count from 0. Korean title
-- "불량 줄 싹 지우기" ("defective lines") -> "0이 있는 행과 열 지우기". Method clearDefectRows ->
-- zeroOutRowsAndCols in all 4 Starter Codes and Drivers. Examples match the sample test
-- cases, which are unchanged.

UPDATE problems SET
    description = $$Given an `m x n` grid `board`, set to `0` every cell that shares a row or a column with a cell that was originally `0`. Modify `board` **in place**; the method returns nothing.

Think of a puzzle game where each `0` tile wipes its whole row and column. Only the original zeros wipe: a cell that becomes `0` does not wipe its own row and column in turn. Cells whose row and column held no `0` keep their value.

**Example 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: There is no zero, so the board is unchanged.
```

**Example 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero is in row 1, column 1 (counting from 0), so every cell of row 1 and of column 1 becomes 0.
```

```diagram-grid
cells: [[4,6,8],[2,0,5],[7,9,3]]
after: [[4,0,8],[0,0,0],[7,0,3]]
```$$
WHERE slug = $$zero-out-rows-cols$$;

UPDATE problem_translations SET
    title = $$0이 있는 행과 열 지우기$$,
    description = $$`m x n` 격자 `board`가 주어집니다. 원래 `0`이던 칸과 같은 행 또는 같은 열에 있는 모든 칸을 `0`으로 바꾸세요. `board`를 **제자리에서** 수정하며, 메서드는 아무것도 반환하지 않습니다.

`0`이 적힌 타일이 자기 행과 열 전체를 지우는 퍼즐 게임을 떠올려 보세요. 지우는 것은 원래 있던 `0`뿐입니다. 새로 `0`이 된 칸이 다시 자기 행과 열을 지우지는 않습니다. 행에도 열에도 `0`이 없던 칸은 원래 값을 그대로 유지합니다.

**예시 1:**
```
입력: board = [[2,3],[4,5]]
출력: [[2,3],[4,5]]
설명: 0이 하나도 없으므로 격자는 변하지 않습니다.
```

**예시 2:**
```
입력: board = [[4,6,8],[2,0,5],[7,9,3]]
출력: [[4,0,8],[0,0,0],[7,0,3]]
설명: 0부터 세어 1행 1열에 0이 있으므로, 1행과 1열의 모든 칸이 0이 됩니다.
```

```diagram-grid
cells: [[4,6,8],[2,0,5],[7,9,3]]
after: [[4,0,8],[0,0,0],[7,0,3]]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$zero-out-rows-cols$$);
