-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 8 (problems #71-#80)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (root, board, words, word,
-- digits, scores, k, field, n, PrefixIndex, WildcardLexicon) stay verbatim.
-- First mention of each variable in Korean prose is paired with a Korean
-- noun phrase describing its role. Constraint identifiers are aligned with
-- the canonical English parameter names from V135 / V137 / V149 source
-- descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'longest-folder-path', 'best-skill-tree-path', 'username-trie', 'wildcard-lexicon',
      'word-search-ii', 'word-search', 'flip-phone-codes', 'top-raid-score',
      'dual-waterbowl-flow', 'n-queens'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. longest-folder-path
((SELECT id FROM problems WHERE slug = 'longest-folder-path'), 'ko',
 $$가장 긴 폴더 경로$$,
 $$학교의 폴더 트리가 루트 노드 `root`로 주어집니다. 트리의 어떤 두 노드를 잇는 경로 중 가장 긴 것을, 그 경로에 포함된 **간선 수**로 세서 반환하세요.

경로는 중간의 어떤 폴더에서 꺾일 수도 있고, 한 가지를 따라 곧장 내려갈 수도 있습니다. 반드시 `root`를 지날 필요는 없습니다.

**예시 1:**
```
입력: root = [7,3,8,1,4,null,9]
출력: 4
설명: 1 -> 3 -> 7 -> 8 -> 9 경로는 간선 4개를 사용하며, 이것이 가장 긴 경로입니다.
```

**예시 2:**
```
입력: root = [2,null,5,3]
출력: 2
설명: 2 -> 5 -> 3 경로는 간선 2개를 지납니다.
```$$,
 $$- 트리의 노드 개수는 `[1, 10^4]` 범위입니다.
- `-100 <= Node.val <= 100`$$),

-- 2. best-skill-tree-path
((SELECT id FROM problems WHERE slug = 'best-skill-tree-path'), 'ko',
 $$최고의 스킬 트리 가지$$,
 $$협동 파티의 스킬 트리는 이진 트리이며, 각 노드는 양수 또는 음수일 수 있는 점수를 가집니다. 스킬 포인트를 투자할 가장 좋은 연속된 가지를 찾아주세요.

**가지(branch)** 는 간선으로 연결된 노드들의 시퀀스로, 같은 노드를 두 번 거치지 않으며 반드시 루트를 포함할 필요는 없습니다. 트리의 루트 `root`가 주어질 때, 비어 있지 않은 어떤 가지에서 얻을 수 있는 점수 합의 최댓값을 반환하세요.

**예시 1:**
```
입력: root = [4,5,6]
출력: 15
설명: 가장 좋은 가지는 5 -> 4 -> 6이며, 합은 5 + 4 + 6 = 15입니다.
```

**예시 2:**
```
입력: root = [-8,11,25,null,null,13,9]
출력: 47
설명: 가장 좋은 가지는 13 -> 25 -> 9이며, 합은 13 + 25 + 9 = 47입니다. -8 때문에 루트를 포함하면 점수가 오히려 떨어집니다.
```$$,
 $$- 트리의 노드 개수는 `[1, 3 * 10^4]` 범위입니다.
- `-1000 <= Node.val <= 1000`$$),

-- 3. username-trie
((SELECT id FROM problems WHERE slug = 'username-trie'), 'ko',
 $$유저네임 트라이$$,
 $$비디오 게임 유저명 등록부를 위한 자동완성 색인을 만들려고 합니다. 이 색인은 두 가지 질문에 빠르게 답해야 합니다. 주어진 이름이 완전한 유저명으로 등록돼 있는지, 그리고 주어진 접두어로 시작하는 유저명이 하나라도 존재하는지입니다.

`PrefixIndex` 클래스를 구현하세요.

- `PrefixIndex()` — 빈 색인을 생성합니다.
- `void insert(String word)` — `word`를 완전한 유저명으로 등록합니다. 중복 등록해도 문제없습니다.
- `boolean search(String word)` — `word`가 완전한 유저명으로 등록된 경우에만 `true`를 반환합니다.
- `boolean startsWith(String prefix)` — 등록된 유저명 중 `prefix`로 시작하는 것이 있으면 `true`를 반환합니다.

**예시 1:**
```
입력:
["PrefixIndex", "insert", "insert", "search", "search", "startsWith", "search", "startsWith"]
[[], ["cat"], ["car"], ["cat"], ["ca"], ["ca"], ["car"], ["dog"]]
출력: [null, null, null, true, false, true, true, false]
```

`"cat"`과 `"car"`을 등록한 뒤, `search("cat")`은 `true`이지만 `search("ca")`는 `false`입니다. `"ca"`는 완전한 유저명으로 등록된 적이 없고 단지 공통 접두어이기 때문입니다. `startsWith("ca")`는 여전히 `true`입니다. `startsWith("dog")`는 `"dog"`로 시작하는 유저명이 없으므로 `false`입니다.$$,
 $$- `1 <= word.length, prefix.length <= 2000`
- `word`와 `prefix`는 영어 소문자로만 이루어져 있습니다.
- `insert`, `search`, `startsWith`는 합쳐서 최대 `3 * 10^4`번 호출됩니다.$$),

-- 4. wildcard-lexicon
((SELECT id FROM problems WHERE slug = 'wildcard-lexicon'), 'ko',
 $$와일드카드 단어 사전$$,
 $$단어 타일 게임을 위한 치트 단어 검사기를 만듭니다. 플레이어가 즐겨 쓰는 단어들을 저장해 두면, 나중에 추측한 단어를 검사할 수 있는데, 이때 `.`은 어떤 한 글자에도 매칭됩니다. 저장된 단어 중 길이가 같고 위치별로 모두 매칭되는 것이 있으면 추측이 통과합니다.

`WildcardLexicon` 클래스를 구현하세요.

- `WildcardLexicon()` — 저장된 단어가 없는 빈 사전으로 시작합니다.
- `void enroll(String word)` — `word`를 사전에 저장합니다(영어 소문자만). 같은 단어를 여러 번 저장해도 문제없습니다.
- `boolean match(String word)` — 와일드카드 규칙에 따라 `word`와 매칭되는 저장 단어가 하나라도 있으면 `true`, 그렇지 않으면 `false`를 반환합니다(아무 단어도 저장되지 않은 경우 포함).

`match`의 입력은 영어 소문자와 `.`이 섞여 있을 수 있고, `enroll`의 입력에는 절대 `.`이 들어 있지 않습니다. 두 메서드는 임의의 순서로 번갈아 호출될 수 있으며, `match`는 저장된 단어 집합을 변경하지 않습니다.$$,
 $$- `1 <= word.length <= 25`
- `enroll`의 `word`는 영어 소문자로만 이루어져 있습니다.
- `match`의 `word`는 영어 소문자와/또는 와일드카드 문자 `.`로 이루어져 있습니다.
- `enroll`과 `match`는 합쳐서 최대 `10^4`번 호출됩니다.$$),

-- 5. word-search-ii
((SELECT id FROM problems WHERE slug = 'word-search-ii'), 'ko',
 $$단어 찾기 II$$,
 $$`m x n` 글자 보드 `board`와 단어 목록 `words`가 주어집니다. 보드 위에서 상하좌우로 인접한 칸을 따라 이동해 만들 수 있는 단어를 모두 찾으세요. 한 단어를 만드는 동안 같은 칸을 두 번 사용할 수 없습니다. 매칭된 단어들을 어떤 순서로든 반환하면 됩니다.

여러 단어의 경로가 보드에서 서로 겹쳐도 괜찮습니다 — 각 단어는 독립적으로 확인합니다.

**예시 1:**
```
입력: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
출력: ["eat","oath"]
```

**예시 2:**
```
입력: board = [["a","b"],["c","d"]], words = ["abcb"]
출력: []
설명: `"abcb"`를 만들려면 `"b"`가 들어 있는 칸을 다시 방문해야 하는데, 그것은 허용되지 않습니다.
```$$,
 $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]`는 영어 소문자입니다.
- `1 <= words.length <= 3 * 10^4`
- `1 <= words[i].length <= 10`
- `words[i]`는 영어 소문자로 이루어져 있습니다.
- `words`의 모든 문자열은 서로 다릅니다.$$),

-- 6. word-search
((SELECT id FROM problems WHERE slug = 'word-search'), 'ko',
 $$단어 찾기$$,
 $$`m x n` 글자 보드 `board`와 목표 단어 `word`가 주어졌을 때, 상하좌우로 인접한 칸을 따라 이동해서 `word`를 만들 수 있으면 `true`를 반환하세요. 한 칸은 한 번의 추적에서 한 번만 사용할 수 있습니다.

**예시 1:**
```
입력: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
출력: true
```

**예시 2:**
```
입력: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
출력: true
```

**예시 3:**
```
입력: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
출력: false
설명: 두 번째 `"B"`에 도달하려면 시작 칸을 다시 방문해야 하는데, 그것은 허용되지 않습니다.
```$$,
 $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 6`
- `1 <= word.length <= 15`
- `board`와 `word`는 영어 대소문자로만 이루어져 있습니다.$$),

-- 7. flip-phone-codes
((SELECT id FROM problems WHERE slug = 'flip-phone-codes'), 'ko',
 $$플립폰 키패드 코드$$,
 $$옛날 폴더폰 키패드에서는 각 숫자가 여러 글자에 매핑됩니다.

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

`2`부터 `9`까지의 문자만 포함하는 문자열 `digits`가 주어질 때, 그 숫자들이 만들 수 있는 모든 글자 조합을 반환하도록 `mapKeypadCodes`를 구현하세요. 결과 순서는 임의입니다. `digits`가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: digits = "45"
출력: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
설명: 숫자 4는 `"ghi"`에, 숫자 5는 `"jkl"`에 매핑되며, 각 자리에서 한 글자씩 골라 만든 모든 짝이 결과에 포함됩니다.
```

**예시 2:**
```
입력: digits = "2"
출력: ["a","b","c"]
설명: 숫자 2는 글자 a, b, c에 매핑됩니다.
```$$,
 $$- `0 <= digits.length <= 4`
- `digits[i]`는 `'2'`부터 `'9'`까지의 숫자입니다.$$),

-- 8. top-raid-score
((SELECT id FROM problems WHERE slug = 'top-raid-score'), 'ko',
 $$상위 레이드 점수$$,
 $$레이드를 마친 길드는 모든 멤버의 데미지 수치를 정수 배열 `scores`에 모았습니다. 동점도 각각 한 자리로 세서 `k`번째로 큰 점수를 반환하세요. 예를 들어 `[8, 3, 5, 5]`에서 1번째는 `8`, 2번째는 `5`입니다.

`scores`를 내림차순으로 정렬했을 때 `k`번째 위치의 값을 반환하도록 `findBrightestTargets(scores, k)`를 구현하세요.

**예시 1:**
```
입력: scores = [7,2,9,4,9,6,3], k = 3
출력: 7
설명: 내림차순으로 정렬하면 `[9,9,7,6,4,3,2]`이며, 3번째 값은 7입니다.
```

**예시 2:**
```
입력: scores = [12,5,8,5,8,15,3,11], k = 4
출력: 8
설명: 내림차순으로 정렬하면 `[15,12,11,8,8,5,5,3]`이며, 4번째 값은 8입니다.
```$$,
 $$- `1 <= k <= scores.length <= 10^5`
- `-10^4 <= scores[i] <= 10^4`$$),

-- 9. dual-waterbowl-flow
((SELECT id FROM problems WHERE slug = 'dual-waterbowl-flow'), 'ko',
 $$두 물그릇 모두 닿기$$,
 $$햄스터의 경사진 놀이판이 `m x n` 격자 `field`로 주어집니다. `field[r][c]`는 `(r, c)` 칸의 높이입니다. 한쪽 물그릇은 좌상단 가장자리(맨 윗줄과 맨 왼쪽 열)에, 다른 한쪽 물그릇은 우하단 가장자리(맨 아랫줄과 맨 오른쪽 열)에 놓여 있습니다. 물은 현재 칸의 높이보다 **작거나 같은** 높이를 지닌 4방향 이웃 칸으로 흐르며, 가장자리 칸은 그쪽 물그릇으로 곧바로 흘러 들어갑니다.

물이 **두 물그릇 모두**로 흘러갈 수 있는 모든 좌표 `[r, c]`를 반환하세요. 순서는 상관없습니다.

**예시 1:**
```
입력: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
출력: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
설명: 칸 (2,2)는 능선에 자리잡고 있어, 물이 왼쪽 아래로 내려가 좌상단 물그릇에, 오른쪽 아래로 내려가 우하단 물그릇에 닿을 수 있습니다.
```

**예시 2:**
```
입력: field = [[2,4,6],[5,7,9],[8,10,12]]
출력: [[0,2],[1,2],[2,0],[2,1],[2,2]]
설명: 높이가 우하단으로 갈수록 단조롭게 올라가므로, 오른쪽 열과 맨 아랫줄만 두 물그릇 모두로 흘러갈 수 있습니다.
```$$,
 $$- `m == field.length`
- `n == field[r].length`
- `1 <= m, n <= 200`
- `0 <= field[r][c] <= 10^5`$$),

-- 10. n-queens
((SELECT id FROM problems WHERE slug = 'n-queens'), 'ko',
 $$N-퀸$$,
 $$`n × n` 체스판 위에 `n`개의 퀸을, 어떤 두 퀸도 서로 공격하지 않도록 — 즉 같은 행, 같은 열, 같은 대각선을 공유하지 않도록 — 놓으세요. 가능한 모든 서로 다른 배치를 반환하세요.

각 배치는 길이가 `n`인 문자열 `n`개의 리스트입니다. `'Q'`는 퀸이 놓인 칸, `'.'`은 빈 칸을 나타냅니다. 결과 배치들의 출력 순서는 상관없습니다.

**예시 1:**
```
입력: n = 4
출력: [[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]
설명: `n = 4`일 때 두 가지 서로 다른 안전한 배치가 존재합니다.
```

**예시 2:**
```
입력: n = 1
출력: [["Q"]]
```$$,
 $$- `1 <= n <= 9`$$);
