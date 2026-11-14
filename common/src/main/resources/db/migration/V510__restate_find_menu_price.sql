-- V510: find-menu-price restated, Slug and title unchanged. The first sentence now states the
-- task, and Example 1 says its row and column are 0-indexed. Starter method detectFlowValue ->
-- hasPrice in all 4 Starter Codes and Drivers. Examples match the sample test cases, which are
-- unchanged, and Example 1 keeps its Diagram.

UPDATE problems SET
    description = $$Given an `m x n` grid of prices `menu` and an integer `target`, return `true` if some cell of `menu` equals `target`, otherwise `false`.

Each row is sorted in ascending order from left to right, and the first price of each row is greater than the last price of the row above, so reading the rows in order gives one ascending list. Run in `O(log(m * n))` time.

**Example 1:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 (both 0-indexed) holds 22.
```

```diagram-grid
cells: [[2,4,8,13],[15,19,22,28],[31,37,44,52]]
highlight: [[1,2]]
```

**Example 2:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell holds 9.
```$$
WHERE slug = $$find-menu-price$$;

UPDATE problem_translations SET
    description = $$가격이 적힌 `m x n` 격자 `menu`와 정수 `target`이 주어질 때, `menu`의 어떤 칸이 `target`과 같으면 `true`, 아니면 `false`를 반환하세요.

각 행은 왼쪽에서 오른쪽으로 오름차순으로 정렬되어 있고, 각 행의 첫 가격은 바로 위 행의 마지막 가격보다 큽니다. 그래서 행을 차례로 이어 읽으면 하나의 오름차순 목록이 됩니다. `O(log(m * n))` 시간 안에 동작해야 합니다.

**예시 1:**
```
입력: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
출력: true
설명: 1번 행, 2번 열(둘 다 0부터 셉니다)의 칸에 22가 있습니다.
```

```diagram-grid
cells: [[2,4,8,13],[15,19,22,28],[31,37,44,52]]
highlight: [[1,2]]
```

**예시 2:**
```
입력: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
출력: false
설명: 9가 적힌 칸이 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-menu-price$$);
