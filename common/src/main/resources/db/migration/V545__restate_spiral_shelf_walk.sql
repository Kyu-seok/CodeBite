-- V545: spiral-shelf-walk restated, title unchanged. The method traceOutwardWalk said
-- "outward" for a spiral that winds inward, and the title's shelf never appeared in the
-- statement; the method becomes spiralOrder, the parameter board becomes shelf, and the
-- statement reads the grid as a shelf. Both examples are now explained.
-- Starter method traceOutwardWalk -> spiralOrder and parameter board -> shelf in all 4
-- Starter Codes and Drivers. Examples and the Diagram match the sample test cases, which
-- are unchanged.

UPDATE problems SET
    description = $$A shelf is a grid of `m` rows and `n` columns of cubbies, and `shelf[i][j]` is the number in the cubby at row `i`, column `j`. Return every number in spiral order, visiting each cubby exactly once.

The spiral starts at the top-left cubby and goes right along the top row, down the rightmost column, left along the bottom row and up the leftmost column. It then steps one cubby inward and repeats on the cubbies not yet visited.

**Example 1:**
```
Input: shelf = [[1,2],[3,4]]
Output: [1,2,4,3]
Explanation: Right along the top row (1, 2), down to 4, then left along the bottom row to 3.
```

**Example 2:**
```
Input: shelf = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
Explanation: The outer ring gives 5, 6, 7, 10, 13, 16, 15, 14, 11, 8. Inside it, only 9 and 12 are left, read top to bottom.
```

```diagram-grid
cells: [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
highlight: [[0,0],[0,1],[0,2],[1,2],[2,2],[3,2],[3,1],[3,0],[2,0],[1,0]]
```$$,
    constraints = $$- `m == shelf.length`
- `n == shelf[i].length`
- `1 <= m, n <= 10`
- `-100 <= shelf[i][j] <= 100`$$
WHERE slug = $$spiral-shelf-walk$$;

UPDATE problem_translations SET
    description = $$선반은 `m`행 `n`열의 칸으로 이루어진 격자이고, `shelf[i][j]`는 `i`행 `j`열 칸에 적힌 수입니다. 모든 칸을 정확히 한 번씩 방문하며 나선 순서로 수를 반환하세요.

나선은 왼쪽 위 칸에서 시작해 맨 윗줄을 따라 오른쪽으로, 가장 오른쪽 열을 따라 아래로, 맨 아랫줄을 따라 왼쪽으로, 가장 왼쪽 열을 따라 위로 갑니다. 그다음 한 칸 안쪽으로 들어가 아직 방문하지 않은 칸들에서 같은 순서를 반복합니다.

**예시 1:**
```
입력: shelf = [[1,2],[3,4]]
출력: [1,2,4,3]
설명: 맨 윗줄을 따라 오른쪽으로(1, 2), 아래로 내려가 4, 맨 아랫줄을 따라 왼쪽으로 3을 방문합니다.
```

**예시 2:**
```
입력: shelf = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
출력: [5,6,7,10,13,16,15,14,11,8,9,12]
설명: 바깥 테두리에서 5, 6, 7, 10, 13, 16, 15, 14, 11, 8이 나옵니다. 그 안쪽에는 9와 12만 남으며, 위에서 아래로 읽습니다.
```

```diagram-grid
cells: [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
highlight: [[0,0],[0,1],[0,2],[1,2],[2,2],[3,2],[3,1],[3,0],[2,0],[1,0]]
```$$,
    constraints = $$- `m == shelf.length`
- `n == shelf[i].length`
- `1 <= m, n <= 10`
- `-100 <= shelf[i][j] <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$spiral-shelf-walk$$);
