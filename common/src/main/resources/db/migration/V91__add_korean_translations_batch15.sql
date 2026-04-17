-- Korean translations: batch 15 (problems #141-150)

------------------------------------------------------------
-- #141 border-capture
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'border-capture'),
    'ko',
    '영역 점령',
    '`m x n` 크기의 보드가 `''X''`와 `''O''`로 이루어져 있습니다. 테두리에 연결되지 않은 모든 `''O''`를 `''X''`로 바꾸세요. 보드를 **in-place**로 수정하여 반환합니다.

`''O''` 칸이 **테두리에 연결되어 있다**는 것은, 상하좌우로 인접한 `''O''` 칸들을 따라 첫 번째/마지막 행 또는 첫 번째/마지막 열에 도달할 수 있다는 뜻입니다. 이 조건을 만족하지 않고 `''X''`에 완전히 둘러싸인 `''O''` 영역은 점령하여 뒤집어야 합니다.

**예시 1:**
```
Input: board = [["X","X","X","X"],["X","O","O","X"],["X","X","O","X"],["X","O","X","X"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","O","X","X"]]
Explanation: (3,1)의 O는 마지막 행에 있어 유지됩니다. 내부의 (1,1), (1,2), (2,2) O는 완전히 둘러싸여 있어 점령됩니다.
```

**예시 2:**
```
Input: board = [["X"]]
Output: [["X"]]
```

**예시 3:**
```
Input: board = [["O","O"],["O","O"]]
Output: [["O","O"],["O","O"]]
Explanation: 모든 O가 테두리에 있으므로 점령되지 않습니다.
```',
    '- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 200`
- `board[i][j]`는 ''X'' 또는 ''O'''
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #142 word-chain
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'word-chain'),
    'ko',
    '단어 사슬',
    '두 단어 `beginWord`와 `endWord`, 그리고 유효한 단어 목록 `wordList`가 주어집니다. `beginWord`에서 `endWord`까지의 **최단 변환 사슬** 길이를 구하세요.

각 단계에서는 정확히 **한 글자**만 바꿀 수 있으며, 중간 단어는 모두 `wordList`에 있어야 합니다. `beginWord`는 `wordList`에 없어도 되지만, `endWord`는 반드시 포함되어야 합니다.

`beginWord`와 `endWord`를 포함한 최단 사슬의 **총 단어 수**를 반환하세요. 유효한 사슬이 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
Output: 5
Explanation: hit -> hot -> dot -> dog -> cog (총 5단어)
```

**예시 2:**
```
Input: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log"]
Output: 0
Explanation: endWord "cog"가 wordList에 없으므로 변환이 불가능합니다.
```

**예시 3:**
```
Input: beginWord = "a", endWord = "c", wordList = ["a","b","c"]
Output: 2
Explanation: a -> c (총 2단어)
```',
    '- `1 <= beginWord.length <= 10`
- `endWord.length == beginWord.length`
- `1 <= wordList.length <= 5000`
- `wordList[i].length == beginWord.length`
- `beginWord`, `endWord`, `wordList[i]`는 소문자 영어로 구성됩니다
- `beginWord != endWord`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #143 shortest-grid-path
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shortest-grid-path'),
    'ko',
    '최단 격자 경로',
    '`n x n` 이진 격자가 주어질 때, **좌상단** `(0, 0)`에서 **우하단** `(n - 1, n - 1)`까지의 최단 경로 길이를 구하세요.

**8방향**(수평, 수직, 대각선)으로 이동할 수 있습니다. 경로상의 각 칸은 값이 `0`(빈 칸)이어야 하며, 값이 `1`인 칸은 막혀 있어 지나갈 수 없습니다.

경로의 **길이**는 시작 칸과 끝 칸을 포함하여 방문한 칸의 총 개수입니다. 유효한 경로가 없으면 `-1`을 반환하세요.

**예시 1:**
```
Input: grid = [[0,1],[1,0]]
Output: 2
Explanation: (0,0) -> (1,1) 대각선으로 이동하여 2칸 방문합니다.
```

**예시 2:**
```
Input: grid = [[0,0,0],[1,1,0],[1,1,0]]
Output: 4
Explanation: 최단 경로 중 하나: (0,0) -> (0,1) -> (1,2) -> (2,2), 총 4칸입니다.
```

**예시 3:**
```
Input: grid = [[1,0,0],[1,1,0],[1,1,0]]
Output: -1
Explanation: 시작 칸 (0,0)이 막혀 있어 경로가 존재하지 않습니다.
```',
    '- `n == grid.length`
- `n == grid[i].length`
- `1 <= n <= 100`
- `grid[i][j]`는 `0` 또는 `1`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #144 room-explorer
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'room-explorer'),
    'ko',
    '방 탐험',
    '`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 방이 있습니다. 각 방에는 다른 방을 열 수 있는 열쇠가 들어 있을 수 있습니다. 0번 방만 처음부터 열려 있고 나머지는 잠겨 있습니다.

방에 들어가면 안에 있는 모든 열쇠를 획득하고, 획득한 열쇠로 해당 방을 열 수 있습니다.

**모든** 방을 방문할 수 있으면 `true`를, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: rooms = [[1],[2],[3],[]]
Output: true
Explanation: 0번 방에서 열쇠 1을 얻습니다. 1번 방에서 열쇠 2, 2번 방에서 열쇠 3을 얻어 모든 방을 방문합니다.
```

**예시 2:**
```
Input: rooms = [[1,3],[3,0,1],[2],[0]]
Output: false
Explanation: 0번 방에서 1번, 3번 방의 열쇠를 얻지만, 어떤 방에서도 2번 방의 열쇠를 얻을 수 없어 2번 방에 도달할 수 없습니다.
```

**예시 3:**
```
Input: rooms = [[]]
Output: true
Explanation: 방이 하나뿐이고 이미 열려 있습니다.
```',
    '- `1 <= n <= 1000`
- `0 <= rooms[i].length <= n`
- `0 <= rooms[i][j] < n`
- `rooms[i]`의 모든 값은 서로 다릅니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #145 two-colorable
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'two-colorable'),
    'ko',
    '이분 그래프 판별',
    '인접 리스트 형태의 무방향 그래프가 주어집니다. `graph[i]`는 노드 `i`에 직접 연결된 모든 노드의 인덱스를 담고 있습니다.

그래프가 **이분 그래프(two-colorable)**인지 판별하세요. 즉, 두 가지 색을 사용하여 인접한 두 노드가 같은 색이 되지 않도록 모든 노드를 칠할 수 있는지 확인합니다.

가능하면 `true`를, 불가능하면 `false`를 반환하세요. 그래프에 연결되지 않은 컴포넌트가 있을 수 있습니다.

**예시 1:**
```
Input: graph = [[1,3],[0,2],[1,3],[0,2]]
Output: true
Explanation: 노드 0, 2에 색 A를, 노드 1, 3에 색 B를 칠하면 인접 노드끼리 같은 색이 되지 않습니다.
```

**예시 2:**
```
Input: graph = [[1,2,3],[0,2],[0,1,3],[0,2]]
Output: false
Explanation: 노드 0, 1, 2가 서로 모두 연결된 삼각형을 이루므로 두 가지 색으로는 칠할 수 없습니다.
```

**예시 3:**
```
Input: graph = [[],[]]
Output: true
Explanation: 두 개의 고립된 노드에 아무 색이나 칠해도 충돌이 없습니다.
```',
    '- `1 <= graph.length <= 100`
- `0 <= graph[i].length < graph.length`
- `graph[i]`에 `i`는 포함되지 않습니다 (자기 루프 없음)
- `graph[i]`에 `j`가 있으면 `graph[j]`에도 `i`가 있습니다 (무방향)
- 그래프가 연결되어 있지 않을 수 있습니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #146 equation-solver
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'equation-solver'),
    'ko',
    '나눗셈 계산기',
    '변수 쌍 목록 `equations`와 대응하는 값 배열 `values`가 주어집니다. `equations[i] = [Ai, Bi]`이고 `values[i]`는 `Ai / Bi`의 결과입니다.

예를 들어, `equations = [["a","b"],["b","c"]]`이고 `values = [2.0, 3.0]`이면 `a / b = 2.0`, `b / c = 3.0`입니다.

`queries` 목록이 주어지며, 각 쿼리는 두 변수의 나눗셈 결과를 구합니다. 알려진 관계를 이용하여 계산할 수 없으면 해당 쿼리에 대해 `-1.0`을 반환하세요. 어떤 등식에도 등장하지 않는 변수는 항상 미지수입니다.

`a / b = k`이면 `b / a = 1 / k`입니다.

**예시 1:**
```
Input: equations = [["a","b"],["b","c"]], values = [2.0,3.0], queries = [["a","c"],["b","a"],["a","e"],["a","a"],["x","x"]]
Output: [6.00000,0.50000,-1.00000,1.00000,-1.00000]
Explanation: a/c = (a/b) * (b/c) = 2.0 * 3.0 = 6.0; b/a = 1/2.0 = 0.5; "e"는 미지수이므로 a/e = -1.0; a/a = 1.0; "x"는 등장한 적 없으므로 x/x = -1.0.
```

**예시 2:**
```
Input: equations = [["a","b"],["b","c"],["bc","cd"]], values = [1.5,2.5,5.0], queries = [["a","c"],["c","b"],["bc","cd"],["cd","bc"]]
Output: [3.75000,0.40000,5.00000,0.20000]
```

**예시 3:**
```
Input: equations = [["a","b"]], values = [0.5], queries = [["a","b"],["b","a"],["a","c"]]
Output: [0.50000,2.00000,-1.00000]
```',
    '- `1 <= equations.length <= 20`
- `equations[i].length == 2`
- `1 <= equations[i][0].length, equations[i][1].length <= 5`
- `values.length == equations.length`
- `0.0 < values[i] <= 20.0`
- `1 <= queries.length <= 20`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 5`
- 변수는 소문자 영어와 숫자로 구성됩니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #147 point-connector
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'point-connector'),
    'ko',
    '점 연결하기',
    '2D 평면 위의 점 배열 `points`가 주어집니다. `points[i] = [xi, yi]`는 하나의 점 좌표입니다. 모든 점을 연결하는 데 필요한 **최소 총 비용**을 반환하세요.

두 점 `[xi, yi]`와 `[xj, yj]`를 연결하는 비용은 **맨해튼 거리**: `|xi - xj| + |yi - yj|`입니다.

모든 점이 직접 또는 다른 점을 거쳐 서로 도달할 수 있는 네트워크를 구성해야 합니다. 이는 완전 그래프의 **최소 신장 트리**를 구하는 것과 같습니다.

**예시 1:**
```
Input: points = [[0,0],[2,2],[3,10],[5,2],[7,0]]
Output: 20
Explanation: 최적 연결의 비용 합은 4 + 3 + 9 + 4 = 20입니다.
```

**예시 2:**
```
Input: points = [[3,12],[-2,5],[-4,1]]
Output: 18
Explanation: [-4,1]과 [-2,5]를 연결(비용 6)하고 [-2,5]와 [3,12]를 연결(비용 12)하면 총 18입니다.
```

**예시 3:**
```
Input: points = [[0,0]]
Output: 0
Explanation: 점이 하나뿐이므로 연결이 필요 없습니다.
```',
    '- `1 <= points.length <= 1000`
- `-10^6 <= xi, yi <= 10^6`
- 모든 점은 서로 다릅니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #148 signal-time
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'signal-time'),
    'ko',
    '신호 전파 시간',
    '`1`부터 `n`까지 번호가 매겨진 노드로 이루어진 방향 가중 그래프가 주어집니다. 각 간선은 `[source, destination, weight]`로 표현되며, 해당 이동 시간을 가진 단방향 연결을 나타냅니다.

시작 노드 `src`에서 신호를 보냅니다. 그래프의 **모든** 노드에 신호가 도달하는 데 걸리는 **최소 시간**을 반환하세요. 도달할 수 없는 노드가 있으면 `-1`을 반환합니다.

모든 신호가 동시에 전파되므로, 답은 `src`에서 각 노드까지의 최단 거리 중 최댓값입니다.

**예시 1:**
```
Input: edges = [[2,1,1],[2,3,1],[3,4,1]], n = 4, src = 2
Output: 2
Explanation: 노드 2에서 신호 출발. 노드 1, 3은 1단위 시간에 도달. 노드 4는 노드 3을 거쳐 2단위 시간에 도달합니다.
```

**예시 2:**
```
Input: edges = [[1,2,1]], n = 2, src = 2
Output: -1
Explanation: 노드 2에서 다른 노드에 도달할 수 없지만 노드 1이 존재하므로 신호가 전달되지 않습니다.
```

**예시 3:**
```
Input: edges = [[1,2,3],[1,3,5],[2,3,1]], n = 3, src = 1
Output: 4
Explanation: 노드 2는 3단위, 노드 3은 4단위에 도달합니다 (노드 2를 거치는 것이 직접 경로 5보다 빠름).
```',
    '- `1 <= n <= 100`
- `1 <= edges.length <= 6000`
- `edges[i].length == 3`
- `1 <= source_i, dest_i <= n`
- `source_i != dest_i`
- `1 <= weight_i <= 100`
- 모든 `(source_i, dest_i)` 쌍은 유일합니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #149 budget-flights
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'budget-flights'),
    'ko',
    '저가 항공편',
    '`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 도시를 여행하려 합니다. 배열 `flights`가 주어지며, `flights[i] = [from, to, price]`는 도시 `from`에서 `to`로 가는 편도 항공편의 가격입니다.

출발 도시 `src`, 도착 도시 `dst`, 최대 경유 횟수 `k`가 주어질 때, **최대** `k`번 경유하여 `src`에서 `dst`까지 이동하는 **최저 총 비용**을 반환하세요.

해당 경로가 없으면 `-1`을 반환합니다.

**예시 1:**
```
Input: n = 4, flights = [[0,1,100],[1,2,100],[2,0,100],[1,3,600],[2,3,200]], src = 0, dst = 3, k = 1
Output: 700
Explanation: 경로 0 -> 1 -> 3의 비용은 100 + 600 = 700입니다. 더 싼 경로 0 -> 1 -> 2 -> 3은 400이지만 경유가 2번이라 불가합니다.
```

**예시 2:**
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 1
Output: 200
Explanation: 경로 0 -> 1 -> 2의 비용은 100 + 100 = 200으로, 직항 500보다 저렴합니다.
```

**예시 3:**
```
Input: n = 3, flights = [[0,1,100],[1,2,100],[0,2,500]], src = 0, dst = 2, k = 0
Output: 500
Explanation: 경유 0회이므로 직항 0 -> 2만 가능하며, 비용은 500입니다.
```',
    '- `1 <= n <= 100`
- `0 <= flights.length <= n * (n - 1) / 2`
- `flights[i].length == 3`
- `0 <= from, to < n`
- `from != to`
- `1 <= price <= 10000`
- `0 <= src, dst, k < n`
- `src != dst`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #150 rising-tide
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rising-tide'),
    'ko',
    '밀려오는 조수',
    '`n x n` 정수 격자 `elevation`이 주어지며, 각 칸은 해당 위치의 지형 높이를 나타냅니다. 시간 `t = 0`부터 물이 차오르기 시작하여, 시간 `t`에는 높이가 `<= t`인 모든 칸이 물에 잠겨 통과할 수 있게 됩니다.

좌상단 `(0, 0)`에서 출발하여 우하단 `(n - 1, n - 1)`에 도달하려 합니다. 매 이동마다 상하좌우로 인접한 칸으로 이동할 수 있으며, 현재 칸과 이동할 칸 **모두** 높이가 `<= t`여야 합니다.

좌상단에서 우하단까지 경로가 존재하는 **최소 `t` 값**을 반환하세요.

**예시 1:**
```
Input: elevation = [[0,2],[1,3]]
Output: 3
Explanation: t = 3일 때 모든 칸이 잠기고 (0,0) -> (1,0) -> (1,1) 경로가 가능해집니다.
```

**예시 2:**
```
Input: elevation = [[0,1,2,3,4],[24,23,22,21,5],[12,13,14,15,16],[11,17,18,19,20],[10,9,8,7,6]]
Output: 16
Explanation: t = 16일 때 높이 <= 16인 칸들을 따라 경로가 존재합니다.
```

**예시 3:**
```
Input: elevation = [[3,2],[0,1]]
Output: 3
Explanation: t = 3일 때 (0,0) -> (0,1) -> (1,1) 또는 (0,0) -> (1,0) -> (1,1) 경로가 가능해집니다.
```',
    '- `n == elevation.length == elevation[i].length`
- `1 <= n <= 50`
- `0 <= elevation[i][j] < n * n`
- elevation의 모든 값은 서로 다릅니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
