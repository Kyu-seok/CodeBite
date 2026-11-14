-- V473: find-menu-calorie restated. The task now comes first, and the Korean constraints
-- drop the two sorted-order bullets the English lacks (the description states the order).
-- Starter method probeSugarReading, left over from a sugar-reading theme, -> findCalorie
-- in all 4 Starter Codes and Drivers. Examples match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$A cafe's calorie chart is an `m x n` grid `menu`. Return `true` if some cell equals `target`, otherwise `false`.

Each row of `menu` is sorted ascending from left to right, and each column ascending from top to bottom. Rows may overlap: the first value of a row can be smaller than the last value of the row above.

**Example 1:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

```diagram-grid
cells: [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]]
highlight: [[3,2]]
```

**Example 2:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**Example 3:**
```
Input: menu = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1 sits in the first row, second column.
```$$
WHERE slug = $$find-menu-calorie$$;

UPDATE problem_translations SET
    description = $$카페의 칼로리 표가 `m x n` 크기의 격자 `menu`로 주어집니다. `target`과 같은 칸이 있으면 `true`를, 없으면 `false`를 반환하세요.

`menu`의 각 행은 왼쪽에서 오른쪽으로, 각 열은 위에서 아래로 오름차순 정렬되어 있습니다. 단, 행끼리는 겹칠 수 있어, 한 행의 첫 값이 바로 윗행의 마지막 값보다 작을 수도 있습니다.

**예시 1:**
```
입력: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
출력: true
```

```diagram-grid
cells: [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]]
highlight: [[3,2]]
```

**예시 2:**
```
입력: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
출력: false
```

**예시 3:**
```
입력: menu = [[-4,-1],[3,5]], target = -1
출력: true
설명: -1은 첫 번째 행, 두 번째 열에 있습니다.
```$$,
    constraints = $$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 250`
- `|menu[i][j]| <= 10^8`
- `|target| <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-menu-calorie$$);
