-- V274: restate capture-enclosed-tiles (#206, part of #193). Example 2 showed a
-- 2x2 board that is sample 3, not sample 2; it now shows sample 2 (a lone 'O'),
-- and the 2x2 board moves to Example 3, matching sample 3, in English and Korean.
-- Text only: Slug, title, constraints, Test Cases, Starter Code and Drivers are
-- unchanged. Production's text matched the previous migrations.

UPDATE problems SET
    description = $$You're playing a territory game on a grid. `'X'` is your tile and `'O'` is an enemy tile. An enemy region survives if any of its cells can reach the border by moving up, down, left, or right through other `'O'` cells; otherwise it is captured.

Modify `board` **in place**: flip every surrounded `'O'` to `'X'` and leave border-connected `'O'` cells alone. Return the modified board.

**Example 1:**
```
Input: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: The `'O'` at (1,1) and (2,2) are boxed in, so they flip. The `'O'` at (3,3) sits on the border and survives.
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
Explanation: Both `'O'` cells are on the first column, already touching the edge, so nothing changes.
```$$
WHERE slug = $$capture-enclosed-tiles$$;

UPDATE problem_translations SET
    description = $$격자에서 영토 게임을 하고 있습니다. `'X'`는 내 타일이고, `'O'`는 적 타일입니다. 적 영역은 상/하/좌/우로 `'O'` 칸을 따라 이동해 테두리까지 닿을 수 있으면 살아남고, 그렇지 못하면 점령됩니다.

격자 `board`를 **그 자리에서** 수정하세요. 완전히 둘러싸인 `'O'`는 모두 `'X'`로 뒤집고, 테두리와 이어진 `'O'`는 그대로 둡니다. 수정된 보드를 반환합니다.

**예시 1:**
```
입력: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
출력: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
설명: (1,1)과 (2,2)의 `'O'`는 사방이 막혀 있어서 뒤집히고, (3,3)의 `'O'`는 테두리에 있어서 그대로 남습니다.
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
설명: 두 `'O'` 모두 첫 번째 열에 있어 이미 가장자리에 닿아 있으므로 아무것도 바뀌지 않습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$capture-enclosed-tiles$$);
