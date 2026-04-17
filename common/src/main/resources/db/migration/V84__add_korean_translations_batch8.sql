-- Korean translations: batch 8 (problems #71-80)

------------------------------------------------------------
-- #71 tree-diameter
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tree-diameter'),
    'ko',
    '트리의 지름',
    '이진 트리의 `root`가 주어졌을 때, 트리의 **지름**을 구하세요.

이진 트리의 **지름**이란, 트리 내 임의의 두 노드 사이의 경로 중 가장 긴 경로의 길이입니다. 이 경로가 반드시 루트를 지날 필요는 없습니다.

경로의 길이는 두 노드 사이의 간선 수로 측정됩니다.

**예시 1:**
```
Input: root = [1,2,3,4,5]
Output: 3
Explanation: 경로 [4,2,1,3] 또는 [5,2,1,3]의 길이가 3입니다.
```

**예시 2:**
```
Input: root = [1,2]
Output: 1
```',
    '- 트리의 노드 수는 `[1, 10^4]` 범위입니다.
- `-100 <= Node.val <= 100`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #72 max-path-sum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'max-path-sum'),
    'ko',
    '최대 경로 합',
    '이진 트리에서 **경로**란, 간선으로 연결된 노드들의 연속된 sequence입니다. 각 노드는 경로에 **최대 한 번**만 포함될 수 있으며, 경로가 루트를 지날 필요는 없습니다.

**경로 합**은 경로에 포함된 모든 노드 값의 합입니다.

이진 트리의 `root`가 주어졌을 때, 비어 있지 않은 경로 중 최대 경로 합을 반환하세요.

**예시 1:**
```
Input: root = [1,2,3]
Output: 6
Explanation: 최적 경로는 2 -> 1 -> 3이며, 경로 합은 2 + 1 + 3 = 6입니다.
```

**예시 2:**
```
Input: root = [-10,9,20,null,null,15,7]
Output: 42
Explanation: 최적 경로는 15 -> 20 -> 7이며, 경로 합은 15 + 20 + 7 = 42입니다.
```',
    '- 트리의 노드 수는 `[1, 3 * 10^4]` 범위입니다.
- `-1000 <= Node.val <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #73 prefix-tree
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'prefix-tree'),
    'ko',
    '접두사 트리',
    '**트라이**(trie, "try"로 발음)는 **접두사 트리**라고도 하며, 문자열 집합에서 키를 효율적으로 저장하고 검색하기 위한 트리 자료구조입니다.

다음 메서드를 가진 `Trie` 클래스를 구현하세요:

- `Trie()` — 트라이 객체를 초기화합니다.
- `void insert(String word)` — 문자열 `word`를 트라이에 삽입합니다.
- `boolean search(String word)` — `word`가 트라이에 존재하면 `true`, 아니면 `false`를 반환합니다.
- `boolean startsWith(String prefix)` — 이전에 삽입된 문자열 중 `prefix`로 시작하는 것이 있으면 `true`, 아니면 `false`를 반환합니다.

**예시 1:**
```
Input:
["Trie", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```',
    '- `1 <= word.length, prefix.length <= 2000`
- `word`와 `prefix`는 소문자 영어 글자로만 구성됩니다.
- `insert`, `search`, `startsWith` 호출 횟수의 합은 최대 `3 * 10^4`입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #74 word-dictionary
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'word-dictionary'),
    'ko',
    '단어 사전',
    '단어를 추가하고, 와일드카드 문자가 포함된 문자열을 검색할 수 있는 자료구조를 설계하세요.

`WordDictionary` 클래스를 구현하세요:

- `WordDictionary()` — 객체를 초기화합니다.
- `void addWord(word)` — `word`를 자료구조에 추가합니다.
- `bool search(word)` — 자료구조에 `word`와 일치하는 문자열이 있으면 `true`, 없으면 `false`를 반환합니다. 검색 `word`에는 `''.''`가 포함될 수 있으며, 각 점은 아무 글자 하나와 매치됩니다.

**예시 1:**
```
Input:
["WordDictionary","addWord","addWord","addWord","search","search","search","search"]
[[],["bad"],["dad"],["mad"],["pad"],["bad"],[".ad"],["b.."]]
Output: [null,null,null,null,false,true,true,true]
```',
    '- `1 <= word.length <= 25`
- `addWord`의 `word`는 소문자 영어 글자로 구성됩니다.
- `search`의 `word`는 `''.''` 또는 소문자 영어 글자로 구성됩니다.
- `addWord`와 `search` 호출은 최대 `10^4`번입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #75 word-finder
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'word-finder'),
    'ko',
    '단어 찾기 II',
    '`m x n` 문자 격자 `board`와 문자열 리스트 `words`가 주어졌을 때, 보드에서 찾을 수 있는 모든 단어를 반환하세요.

각 단어는 **가로 또는 세로로 인접한** 셀을 따라 구성해야 합니다. 하나의 단어 내에서 같은 셀을 두 번 이상 사용할 수 없습니다.

결과는 어떤 순서로든 반환할 수 있습니다.

**예시 1:**
```
Input: board = [["o","a","a","n"],["e","t","a","e"],["i","h","k","r"],["i","f","l","v"]], words = ["oath","pea","eat","rain"]
Output: ["eat","oath"]
```

**예시 2:**
```
Input: board = [["a","b"],["c","d"]], words = ["abcb"]
Output: []
```',
    '- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]`는 소문자 영어 글자입니다.
- `1 <= words.length <= 3 * 10^4`
- `1 <= words[i].length <= 10`
- `words[i]`는 소문자 영어 글자로 구성됩니다.
- `words`의 모든 문자열은 고유합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #76 last-stone
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'last-stone'),
    'ko',
    '마지막 돌의 무게',
    '정수 배열 `stones`가 주어지며, `stones[i]`는 `i`번째 돌의 무게입니다.

매 턴마다 **가장 무거운 두 돌**을 골라 부딪칩니다. 두 돌의 무게를 `x`, `y` (`x <= y`)라 하면:

- `x == y`이면 두 돌 모두 파괴됩니다.
- `x != y`이면 무게 `x`인 돌은 파괴되고, 무게 `y`인 돌은 `y - x`가 됩니다.

돌이 최대 1개 남을 때까지 반복합니다. 마지막 남은 돌의 무게를 반환하세요. 돌이 남지 않으면 `0`을 반환합니다.

**예시 1:**
```
Input: stones = [2,7,4,1,8,1]
Output: 1
Explanation:
We combine 7 and 8 to get 1 so the array converts to [2,4,1,1,1] then,
we combine 2 and 4 to get 2 so the array converts to [2,1,1,1] then,
we combine 2 and 1 to get 1 so the array converts to [1,1,1] then,
we combine 1 and 1 to get 0 so the array converts to [1] then that is the value of the last stone.
```

**예시 2:**
```
Input: stones = [1]
Output: 1
```',
    '- `1 <= stones.length <= 30`
- `1 <= stones[i] <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #77 k-closest-points
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'k-closest-points'),
    'ko',
    '가장 가까운 K개의 점',
    '`points[i] = [x, y]`가 X-Y 평면 위의 좌표인 배열 `points`와 정수 `k`가 주어졌을 때, 원점 `(0, 0)`에서 가장 가까운 `k`개의 점을 반환하세요.

원점과 점 사이의 거리는 **유클리드 거리**: `sqrt(x^2 + y^2)`로 계산합니다.

결과는 **어떤 순서**로든 반환할 수 있습니다. 답은 유일함이 보장됩니다(순서 제외).

**예시 1:**
```
Input: points = [[1,3],[-2,2]], k = 1
Output: [[-2,2]]
Explanation: (1, 3)과 원점 사이의 거리는 sqrt(10)이고, (-2, 2)와 원점 사이의 거리는 sqrt(8)입니다. sqrt(8) < sqrt(10)이므로 (-2, 2)가 더 가깝습니다.
```

**예시 2:**
```
Input: points = [[3,3],[5,-1],[-2,4]], k = 2
Output: [[3,3],[-2,4]]
```',
    '- `1 <= k <= points.length <= 10^4`
- `-10^4 <= x, y <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #78 array-kth-largest
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'array-kth-largest'),
    'ko',
    '배열의 K번째 큰 수',
    '정수 배열 `nums`와 정수 `k`가 주어졌을 때, 배열에서 `k`번째로 큰 원소를 반환하세요.

**정렬 순서** 기준으로 `k`번째로 큰 원소를 찾는 것이며, 중복을 제외한 `k`번째가 아닙니다. 예를 들어 `[3, 1, 2, 2]`에서 1번째로 큰 수는 `3`, 2번째로 큰 수는 `2`입니다.

**예시 1:**
```
Input: nums = [3,2,1,5,6,4], k = 2
Output: 5
```

**예시 2:**
```
Input: nums = [3,2,3,1,2,4,5,5,6], k = 4
Output: 4
```

**예시 3:**
```
Input: nums = [1], k = 1
Output: 1
```',
    '- `1 <= k <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #79 queen-placement
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'queen-placement'),
    'ko',
    'N-퀸 배치',
    '**N-퀸 문제**는 `n x n` 체스판 위에 `n`개의 퀸을 서로 공격할 수 없도록 배치하는 문제입니다. 두 퀸이 같은 행, 열, 또는 대각선에 있으면 서로 공격할 수 있습니다.

정수 `n`이 주어졌을 때, N-퀸 문제의 모든 고유한 해를 반환하세요. 답은 어떤 순서로든 반환할 수 있습니다.

각 해는 보드를 나타내는 문자열 리스트이며, `''Q''`는 퀸, `''.''`는 빈 칸을 의미합니다.

**예시 1:**
```
Input: n = 4
Output: [["..Q.","Q...","...Q",".Q.."],[".Q..","...Q","Q...","..Q."]]
```

**예시 2:**
```
Input: n = 1
Output: [["Q"]]
```',
    '- `1 <= n <= 9`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #80 word-search
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'word-search'),
    'ko',
    '단어 검색',
    '`m x n` 문자 격자 `board`와 문자열 `word`가 주어졌을 때, 격자에 `word`가 존재하면 `true`, 아니면 `false`를 반환하세요.

단어는 **가로 또는 세로로 인접한** 셀을 따라 구성해야 하며, 경로에서 각 셀은 최대 한 번만 사용할 수 있습니다.

**예시 1:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCCED"
Output: true
```

**예시 2:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "SEE"
Output: true
```

**예시 3:**
```
Input: board = [["A","B","C","E"],["S","F","C","S"],["A","D","E","E"]], word = "ABCB"
Output: false
```',
    '- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 6`
- `1 <= word.length <= 15`
- `board`와 `word`는 소문자 및 대문자 영어 글자로만 구성됩니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
