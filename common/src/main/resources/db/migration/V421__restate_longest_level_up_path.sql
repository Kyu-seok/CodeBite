-- V421: longest-level-up-path restated, title unchanged. "The length of the longest path"
-- didn't say whether length counts tiles or moves (it counts tiles: a lone tile is 1, sample
-- 3), and Example 2's "combo" added vocabulary. Both fixed, sample 3 is Example 3. Starter
-- method longestVineAscent -> longestIncreasingPath in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A puzzle game board is an `m x n` grid `scores`, one score per tile. A path starts on any tile and repeatedly steps to an adjacent tile (up, down, left or right) whose score is **strictly higher** than the current one.

Return the length of the longest such path, counted in tiles visited. A single tile on its own is a path of length `1`.

**Example 1:**
```
Input: scores = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting from the 1 in the bottom-left, 1 -> 3 -> 4 -> 7 -> 9 visits 5 tiles, each higher than the last.
```

```diagram-grid
cells: [[2,5,8],[3,4,7],[1,6,9]]
highlight: [[2,0],[1,0],[1,1],[1,2],[2,2]]
```

**Example 2:**
```
Input: scores = [[4,2,1],[5,6,3]]
Output: 5
Explanation: Starting from the 1 in the top-right, 1 -> 2 -> 4 -> 5 -> 6 visits 5 tiles, each higher than the last.
```

**Example 3:**
```
Input: scores = [[1]]
Output: 1
Explanation: The only path is the single tile, which has length 1.
```$$,
    constraints = $$- `m == scores.length`
- `n == scores[i].length`
- `1 <= m, n <= 200`
- `0 <= scores[i][j] <= 10^8`$$
WHERE slug = $$longest-level-up-path$$;

UPDATE problem_translations SET
    description = $$퍼즐 게임의 보드는 칸마다 점수가 하나씩 적힌 `m x n` 격자 `scores`입니다. 경로는 아무 칸에서나 출발해, 상하좌우로 인접한 칸 중 점수가 지금 칸보다 **엄격하게 큰** 칸으로 한 칸씩 이동합니다.

이런 경로 중 가장 긴 경로의 길이를 거쳐 간 칸의 개수로 세어 반환하세요. 칸 하나만으로 이루어진 경로의 길이는 `1`입니다.

**예시 1:**
```
입력: scores = [[2,5,8],[3,4,7],[1,6,9]]
출력: 5
설명: 좌하단의 1에서 출발해 1 -> 3 -> 4 -> 7 -> 9 순으로 이동하면 다섯 칸을 거치며 매번 점수가 더 커집니다.
```

```diagram-grid
cells: [[2,5,8],[3,4,7],[1,6,9]]
highlight: [[2,0],[1,0],[1,1],[1,2],[2,2]]
```

**예시 2:**
```
입력: scores = [[4,2,1],[5,6,3]]
출력: 5
설명: 우상단의 1에서 출발해 1 -> 2 -> 4 -> 5 -> 6 순으로 이동하면 다섯 칸을 거치며 매번 점수가 더 커집니다.
```

**예시 3:**
```
입력: scores = [[1]]
출력: 1
설명: 가능한 경로는 칸 하나뿐이고, 그 길이는 1입니다.
```$$,
    constraints = $$- `m == scores.length`
- `n == scores[i].length`
- `1 <= m, n <= 200`
- `0 <= scores[i][j] <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-level-up-path$$);
