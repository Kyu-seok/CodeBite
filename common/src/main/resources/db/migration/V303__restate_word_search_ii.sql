-- V303: restate word-search-ii (#235, part of #193). The Examples showed LeetCode's
-- data (the "oath"/"eat" board and the "abcb" board), which is no sample Test Case;
-- they now show samples 1 and 2 (the "code"/"chat" board with words
-- ["code","chat","maze","nail"], and [["p","a"],["g","c"]] with ["pcg"]), with the
-- Diagram redrawn to the new board in both languages, highlighting the path of
-- "chat", and the explanations rewritten for the new data. Slug, title, constraints,
-- Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    description = $$You're given an `m x n` `board` of letters and a list of `words`. Find every word from the list that can be formed by walking from cell to cell on the board, stepping only between orthogonally adjacent cells (up/down/left/right). A cell can appear at most once per word. Return the matched words in any order.

Multiple words may overlap on the board — each is checked independently.

**Example 1:**
```
Input: board = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], words = ["code","chat","maze","nail"]
Output: ["chat","code"]
Explanation: "code" runs along the top row, and "chat" steps down from "c" to "h", then right through "a" and "t". "maze" fails because no "a" is adjacent to "m", and "nail" because no "i" is adjacent to the "a" below "n".
```

```diagram-grid
cells: [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]]
highlight: [[0,0],[1,0],[1,1],[1,2]]
```

**Example 2:**
```
Input: board = [["p","a"],["g","c"]], words = ["pcg"]
Output: []
Explanation: Tracing "pcg" would require stepping from "p" straight to "c", but "c" is diagonal to "p", and only up/down/left/right steps are allowed.
```$$
WHERE slug = $$word-search-ii$$;

UPDATE problem_translations SET
    description = $$`m x n` 글자 보드 `board`와 단어 목록 `words`가 주어집니다. 보드 위에서 상하좌우로 인접한 칸을 따라 이동해 만들 수 있는 단어를 모두 찾으세요. 한 단어를 만드는 동안 같은 칸을 두 번 사용할 수 없습니다. 매칭된 단어들을 어떤 순서로든 반환하면 됩니다.

여러 단어의 경로가 보드에서 서로 겹쳐도 괜찮습니다 — 각 단어는 독립적으로 확인합니다.

**예시 1:**
```
입력: board = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], words = ["code","chat","maze","nail"]
출력: ["chat","code"]
설명: `"code"`는 맨 윗줄을 따라 이어지고, `"chat"`은 `"c"`에서 아래의 `"h"`로 내려간 뒤 오른쪽의 `"a"`, `"t"`로 이어집니다. `"maze"`는 `"m"` 옆에 `"a"`가 없고, `"nail"`은 `"n"` 아래의 `"a"` 옆에 `"i"`가 없어 만들 수 없습니다.
```

```diagram-grid
cells: [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]]
highlight: [[0,0],[1,0],[1,1],[1,2]]
```

**예시 2:**
```
입력: board = [["p","a"],["g","c"]], words = ["pcg"]
출력: []
설명: `"pcg"`를 만들려면 `"p"`에서 바로 `"c"`로 이동해야 하는데, `"c"`는 `"p"`의 대각선 방향에 있고 상하좌우 이동만 허용되므로 만들 수 없습니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search-ii$$);
