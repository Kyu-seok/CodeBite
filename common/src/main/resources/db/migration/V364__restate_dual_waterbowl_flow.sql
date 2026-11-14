-- V364: dual-waterbowl-flow keeps its Slug, title and Starter Code. The hamster-playpen
-- story had to be translated back into two border regions, and the statement never said
-- that a corner cell touches both bowls, which the cases depend on. The task now comes
-- first in terms of borders, the theme is one clause, and the corners are stated.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an `m x n` grid `field` of heights, return every cell `[r, c]` whose water can flow to both the top/left border and the bottom/right border.

Picture a hamster's sloped playpen with one water bowl along the top row and left column, and another along the bottom row and right column. Water moves from a cell to any of its 4 neighbors (up, down, left, right) whose height is **less than or equal to** its own. A cell in the top row or left column drains into the first bowl; a cell in the bottom row or right column drains into the second. So the top-right and bottom-left corner cells touch both bowls, and in a grid with one row or one column every cell does.

Return the cells in any order.

**Example 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: (0,4) and (4,0) are corners touching both bowls. From (2,2), height 5, water flows through heights 3, 2, 1 to (0,1) in the top row, and through heights 4, 3 to (4,2) in the bottom row.
```

```diagram-grid
cells: [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
highlight: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
```

**Example 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: Heights rise toward the bottom-right, so water from the right column and bottom row can still step down to the top row or left column, while water from any other cell can never climb to the bottom/right border.
```$$,
    constraints = $$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 80000`$$
WHERE slug = $$dual-waterbowl-flow$$;

UPDATE problem_translations SET
    description = $$높이를 담은 `m x n` 격자 `field`가 주어질 때, 물이 위/왼쪽 가장자리와 아래/오른쪽 가장자리 양쪽으로 모두 흘러갈 수 있는 칸 `[r, c]`를 모두 반환하세요.

햄스터의 경사진 놀이판에 물그릇 하나는 맨 윗줄과 맨 왼쪽 열을 따라, 다른 하나는 맨 아랫줄과 맨 오른쪽 열을 따라 놓여 있다고 생각하면 됩니다. 물은 한 칸에서 상하좌우 4방향 이웃 중 높이가 **작거나 같은** 칸으로 흐릅니다. 맨 윗줄이나 맨 왼쪽 열의 칸은 첫 번째 물그릇으로, 맨 아랫줄이나 맨 오른쪽 열의 칸은 두 번째 물그릇으로 흘러 들어갑니다. 따라서 오른쪽 위와 왼쪽 아래 모서리 칸은 두 물그릇에 모두 닿고, 행이나 열이 하나뿐인 격자에서는 모든 칸이 그렇습니다.

칸의 순서는 상관없습니다.

**예시 1:**
```
입력: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
출력: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
설명: (0,4)와 (4,0)은 두 물그릇에 모두 닿는 모서리 칸입니다. 높이 5인 (2,2)에서 물은 높이 3, 2, 1을 거쳐 맨 윗줄의 (0,1)로, 높이 4, 3을 거쳐 맨 아랫줄의 (4,2)로 흘러갑니다.
```

```diagram-grid
cells: [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
highlight: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
```

**예시 2:**
```
입력: field = [[2,4,6],[5,7,9],[8,10,12]]
출력: [[0,2],[1,2],[2,0],[2,1],[2,2]]
설명: 높이가 오른쪽 아래로 갈수록 높아지므로, 오른쪽 열과 맨 아랫줄의 물은 맨 윗줄이나 맨 왼쪽 열까지 내려갈 수 있지만, 다른 칸의 물은 아래/오른쪽 가장자리로 올라갈 수 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$dual-waterbowl-flow$$);
