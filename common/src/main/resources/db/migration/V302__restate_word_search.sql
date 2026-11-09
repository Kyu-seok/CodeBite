-- V302: restate word-search (#234, part of #193). The Examples showed LeetCode's board
-- (`[["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]]` with "ABCCED", "SEE", "ABCB")
-- while the sample Test Cases are CodeBite's own (a 4 x 4 board with "PEAK", "NOID", "PARK").
-- Example N now shows sample N, in both languages; the Diagram under Example 1 is redrawn
-- to the sample board and its path, and the Explanations describe the new data. Only the
-- descriptions change; Slug, title, constraints, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    description = $$Given an `m x n` `board` of letters and a target `word`, return `true` if `word` can be traced on the board by walking between orthogonally adjacent cells (up/down/left/right). Each cell may be used at most once per trace.

**Example 1:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PEAK"
Output: true
Explanation: Start at the "P" in the top-left corner and walk straight down the first column: "P", "E", "A", "K".
```

```diagram-grid
cells: [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]]
highlight: [[0,0],[1,0],[2,0],[3,0]]
```

**Example 2:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "NOID"
Output: true
Explanation: From the "N" in the second row, walk right to "O", down to "I", then right to "D".
```

**Example 3:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PARK"
Output: false
Explanation: The only "P" is in the top-left corner, and its neighbours are "R" and "E", so no "A" can follow it.
```$$
WHERE slug = $$word-search$$;

UPDATE problem_translations SET
    description = $$`m x n` 글자 보드 `board`와 목표 단어 `word`가 주어졌을 때, 상하좌우로 인접한 칸을 따라 이동해서 `word`를 만들 수 있으면 `true`를 반환하세요. 한 칸은 한 번의 추적에서 한 번만 사용할 수 있습니다.

**예시 1:**
```
입력: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PEAK"
출력: true
설명: 왼쪽 위 모서리의 `"P"`에서 출발해 첫 번째 열을 따라 아래로 내려가면 `"P"`, `"E"`, `"A"`, `"K"`가 이어집니다.
```

```diagram-grid
cells: [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]]
highlight: [[0,0],[1,0],[2,0],[3,0]]
```

**예시 2:**
```
입력: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "NOID"
출력: true
설명: 두 번째 행의 `"N"`에서 오른쪽의 `"O"`, 아래의 `"I"`, 다시 오른쪽의 `"D"` 순서로 이동합니다.
```

**예시 3:**
```
입력: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PARK"
출력: false
설명: 유일한 `"P"`는 왼쪽 위 모서리에 있고 그 이웃은 `"R"`와 `"E"`뿐이라서, 뒤에 `"A"`가 이어질 수 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search$$);
