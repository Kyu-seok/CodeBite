-- V460: rotate-pixel-art restated, title unchanged. The task now comes first instead of after
-- three sentences of editor story, and both examples say how the grid turns (each column,
-- read bottom-up, becomes a row). Names unchanged. Examples match the sample test cases,
-- which are unchanged, and each keeps its Diagram.

UPDATE problems SET
    description = $$Rotate the `n x n` grid `image` 90 degrees clockwise, in place. Each integer is the color of one pixel of a piece of pixel art.

After the rotation, column `j` of the original grid, read from bottom to top, is row `j`.

- Modify `image` itself; `rotateImage` returns nothing.
- Do not allocate a second `n x n` array.

**Example 1:**
```
Input: image = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
Explanation: The first column read bottom-up is 5, 8, 2, which becomes the first row; the second column gives 7, 1, 4 and the third 9, 3, 6.
```

```diagram-grid
cells: [[2,4,6],[8,1,3],[5,7,9]]
after: [[5,8,2],[7,1,4],[9,3,6]]
```

**Example 2:**
```
Input: image = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
Explanation: The first column read bottom-up is 14, 8, 1, 5, which becomes the first row, and so on for each column.
```

```diagram-grid
cells: [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
after: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$
WHERE slug = $$rotate-pixel-art$$;

UPDATE problem_translations SET
    description = $$`n x n` 격자 `image`를 그 자리에서 시계 방향으로 90도 회전하세요. 각 정수는 픽셀 아트 한 칸의 색상입니다.

회전한 뒤에는 원래 격자의 `j`번 열을 아래에서 위로 읽은 것이 `j`번 행이 됩니다.

- `image` 자체를 수정하세요. `rotateImage`는 아무것도 반환하지 않습니다.
- 두 번째 `n x n` 배열을 만들면 안 됩니다.

**예시 1:**
```
입력: image = [[2,4,6],[8,1,3],[5,7,9]]
출력: [[5,8,2],[7,1,4],[9,3,6]]
설명: 첫 번째 열을 아래에서 위로 읽으면 5, 8, 2이고, 이것이 첫 번째 행이 됩니다. 두 번째 열은 7, 1, 4, 세 번째 열은 9, 3, 6이 됩니다.
```

```diagram-grid
cells: [[2,4,6],[8,1,3],[5,7,9]]
after: [[5,8,2],[7,1,4],[9,3,6]]
```

**예시 2:**
```
입력: image = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
출력: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
설명: 첫 번째 열을 아래에서 위로 읽으면 14, 8, 1, 5이고, 이것이 첫 번째 행이 됩니다. 나머지 열도 같은 방식입니다.
```

```diagram-grid
cells: [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
after: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$rotate-pixel-art$$);
