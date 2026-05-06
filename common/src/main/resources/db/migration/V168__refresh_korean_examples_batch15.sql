-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 15 (problems #141-#150)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (board, beginWord, endWord,
-- wordList, rooms, conflicts, ratios, values, queries, bowls, links, n,
-- src, dst, maxHops, elevation) stay verbatim. First mention of each
-- variable in Korean prose is paired with a Korean noun phrase describing
-- its role. Constraint identifiers are aligned with the canonical English
-- parameter names from V135 / V149 source descriptions (e.g., the older
-- V124 constraint names like grid / aisles / valves / corridors /
-- startCode are mapped to board / rooms / bowls / links / beginWord).

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'capture-enclosed-tiles', 'word-ladder', 'shortest-dungeon-path',
      'open-all-rooms', 'two-shift-baristas', 'cafe-price-ratios',
      'connect-water-bowls', 'guild-chat-relay', 'cheapest-courier-route',
      'rising-water-path'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. capture-enclosed-tiles
((SELECT id FROM problems WHERE slug = 'capture-enclosed-tiles'), 'ko',
 $$갇힌 영역 점령$$,
 $$격자에서 영토 게임을 하고 있습니다. `'X'`는 내 타일이고, `'O'`는 적 타일입니다. 적 영역은 상/하/좌/우로 `'O'` 칸을 따라 이동해 테두리까지 닿을 수 있으면 살아남고, 그렇지 못하면 점령됩니다.

격자 `board`를 **그 자리에서** 수정하세요. 완전히 둘러싸인 `'O'`는 모두 `'X'`로 뒤집고, 테두리와 이어진 `'O'`는 그대로 둡니다. 수정된 보드를 반환합니다.

**예시 1:**
```
입력: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
출력: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
설명: (1,1)과 (2,2)의 `'O'`는 사방이 막혀 있어서 뒤집히고, (3,3)의 `'O'`는 테두리에 있어서 그대로 남습니다.
```

**예시 2:**
```
입력: board = [["O","X"],["O","X"]]
출력: [["O","X"],["O","X"]]
설명: 두 `'O'` 모두 첫 번째 열에 있어 이미 가장자리에 닿아 있으므로 아무것도 바뀌지 않습니다.
```$$,
 $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 180`
- `board[i][j]`는 `'X'` 또는 `'O'`입니다.$$),

-- 2. word-ladder
((SELECT id FROM problems WHERE slug = 'word-ladder'), 'ko',
 $$단어 사다리$$,
 $$같은 길이의 두 단어 `beginWord`와 `endWord`, 그리고 사전 `wordList`가 주어집니다. *변환*은 한 번에 정확히 한 글자만 바꾸는 동작이고, 변환 도중 거치는 모든 단어는 `wordList` 안에 있어야 합니다. `endWord` 자체도 사전에 들어 있어야 변환이 성립할 수 있습니다. 단, `beginWord`는 사전에 들어 있을 필요가 없습니다.

`beginWord`에서 `endWord`까지 가는 가장 짧은 변환 시퀀스의 길이를 양 끝 단어를 포함해서 반환하세요. 변환이 불가능하면 `0`을 반환합니다.

**예시 1:**
```
입력: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log","cog"]
출력: 5
설명: 가장 짧은 경로 중 하나는 "hit" → "hot" → "dot" → "dog" → "cog"이며 길이는 5입니다.
```

**예시 2:**
```
입력: beginWord = "hit", endWord = "cog", wordList = ["hot","dot","dog","lot","log"]
출력: 0
설명: "cog"가 사전에 없으므로 어떤 변환 시퀀스도 성립하지 않습니다.
```$$,
 $$- `1 <= beginWord.length <= 10`
- `endWord.length == beginWord.length`
- `1 <= wordList.length <= 4500`
- `wordList[i].length == beginWord.length`
- `beginWord`, `endWord`, `wordList[i]`는 모두 영어 소문자로만 이루어져 있습니다.
- `beginWord != endWord`$$),

-- 3. shortest-dungeon-path
((SELECT id FROM problems WHERE slug = 'shortest-dungeon-path'), 'ko',
 $$최단 던전 경로$$,
 $$던전 격자 `board`는 `n x n` 크기이며, 각 칸은 `0`(통과 가능) 또는 `1`(막힘)입니다. 어떤 칸에서든 주변 8방향 칸으로 이동할 수 있습니다. `(0, 0)`에서 `(n - 1, n - 1)`까지 가는 가장 짧은 통과 가능 경로를 찾으세요.

그 경로가 지나는 칸의 개수를 양 끝 포함으로 반환합니다. 경로 위 모든 칸은 `0`이어야 하며, 양 끝 중 하나가 막혀 있거나 경로가 존재하지 않으면 `-1`을 반환합니다.

**예시 1:**
```
입력: board = [[0,0],[0,0]]
출력: 2
설명: (0,0)에서 (1,1)로 대각선 한 걸음이면 통과 가능한 칸 2개를 거치는 경로가 됩니다.
```

**예시 2:**
```
입력: board = [[0,1,0],[0,0,0],[1,0,0]]
출력: 3
설명: (0,0) -> (1,1) -> (2,2) 경로가 통과 가능한 칸 3개를 지나갑니다.
```$$,
 $$- `n == board.length`
- `n == board[i].length`
- `1 <= n <= 120`
- 각 `board[i][j]`는 `0` 또는 `1`입니다.$$),

-- 4. open-all-rooms
((SELECT id FROM problems WHERE slug = 'open-all-rooms'), 'ko',
 $$모든 방 열 수 있는지$$,
 $$`0..n-1`로 번호가 붙은 방이 `n`개 있습니다. 처음에는 방 `0`만 열려 있고 나머지는 모두 잠겨 있습니다. 각 방 안에는 **다른 방**을 여는 열쇠들이 놓여 있는데, 방 목록 `rooms[i]`는 방 `i`에서 얻을 수 있는 열쇠 id 목록입니다.

어떤 방에 들어가면 그 방의 모든 열쇠를 수집하고, 수집한 열쇠로 대응되는 방을 언제든 열 수 있습니다. 모든 방을 방문할 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
입력: rooms = [[2,1],[4],[3],[],[3,0]]
출력: true
설명: 방 0에서 시작해 열쇠 2와 1을 얻습니다. 방 1은 열쇠 4를, 방 2는 열쇠 3을 줍니다. 방 3과 4까지 들르면 다섯 개 방을 모두 방문하게 됩니다.
```

**예시 2:**
```
입력: rooms = [[2],[3],[],[4],[1]]
출력: false
설명: 방 0에서는 열쇠 2만 얻을 수 있고 방 2에는 열쇠가 없습니다. 방 1, 3, 4의 열쇠는 그 방들 안에 갇혀 있어서 영원히 손에 넣을 수 없습니다.
```$$,
 $$- `1 <= n <= 1000`
- `0 <= rooms[i].length <= n`
- `0 <= rooms[i][j] < n`
- `rooms[i]`의 값들은 모두 서로 다릅니다.$$),

-- 5. two-shift-baristas
((SELECT id FROM problems WHERE slug = 'two-shift-baristas'), 'ko',
 $$바리스타 두 교대 나누기$$,
 $$`0`부터 `n - 1`까지 번호가 매겨진 `n`명의 바리스타를 정확히 두 교대로 나누되, 충돌 관계인 쌍이 같은 교대에 묶이지 않도록 해야 합니다. 충돌 목록 `conflicts[i]`에는 바리스타 `i`와 같이 일할 수 없는 동료들의 번호가 들어 있으며, 이 관계는 대칭이고 그래프가 여러 덩어리로 분리돼 있을 수도 있습니다.

이러한 분할이 가능하면 `true`, 불가능하면 `false`를 반환하는 `splitIntoTwoShifts(conflicts)`를 구현하세요.

**예시 1:**
```
입력: conflicts = [[1],[0,2],[1,3],[2]]
출력: true
설명: 바리스타 0과 2를 오전 교대에, 1과 3을 저녁 교대에 배치하면 모든 충돌이 다른 교대 사이에서만 일어납니다.
```

**예시 2:**
```
입력: conflicts = [[1,2],[0,2],[0,1]]
출력: false
설명: 바리스타 0, 1, 2가 서로 모두 충돌하므로 셋을 두 교대로 나누면 반드시 둘이 같은 교대에 묶이게 됩니다.
```$$,
 $$- `1 <= conflicts.length <= 150`
- `0 <= conflicts[i].length < conflicts.length`
- `conflicts[i]`는 `i` 자신을 포함하지 않습니다.
- `conflicts[i]`에 `j`가 있으면 `conflicts[j]`에도 `i`가 있습니다.
- 충돌 그래프는 여러 덩어리로 분리돼 있을 수 있습니다.$$),

-- 6. cafe-price-ratios
((SELECT id FROM problems WHERE slug = 'cafe-price-ratios'), 'ko',
 $$가격 비율 계산하기$$,
 $$카페에 알려진 가격 비율 목록이 있습니다. 비율 `ratios[i] = [Ai, Bi]`와 `values[i]`는 `Ai` 하나의 가격이 `Bi` 하나의 가격의 `values[i]`배라는 뜻입니다.

질의 `queries[i] = [Ci, Di]`에 대해, 주어진 비율들로부터 유도되는 `Ci / Di` 값을 반환하세요. 두 음료가 비율로 연결되지 않거나 둘 중 하나가 `ratios`에 한 번도 등장하지 않으면 `-1.0`을 반환합니다.

참고: `A / B = k`를 알고 있으면 `B / A = 1 / k`이고, 최소 한 번 이상 등장한 음료에 대해서는 `A / A = 1.0`입니다.

**예시 1:**
```
입력: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
출력: [8.00000,0.50000,0.25000,1.00000,-1.00000]
설명: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap는 한 번도 등장하지 않으므로 해당 질의는 -1.0입니다.
```

**예시 2:**
```
입력: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
출력: [12.00000,0.08333,2.00000,-1.00000]
설명: apple과 plum은 pear를 통해 연결되어 3.0 * 4.0 = 12.0과 그 역수가 나옵니다. kiwi와 lime은 별개의 덩어리를 이루므로 kiwi/lime은 알 수 있지만 apple/kiwi는 알 수 없습니다.
```$$,
 $$- `1 <= ratios.length <= 25`
- `ratios[i].length == 2`
- `1 <= ratios[i][0].length, ratios[i][1].length <= 8`
- `values.length == ratios.length`
- `0.0 < values[i] <= 25.0`
- `1 <= queries.length <= 25`
- `queries[i].length == 2`
- `1 <= queries[i][0].length, queries[i][1].length <= 8`
- 음료 코드는 영어 소문자와 숫자로만 이루어져 있습니다.$$),

-- 7. connect-water-bowls
((SELECT id FROM problems WHERE slug = 'connect-water-bowls'), 'ko',
 $$반려동물 급수대 연결$$,
 $$동네 고양이들을 위한 물그릇을 좌표가 정해진 자리들에 놓고, 호스 길이 총합을 최소로 하여 서로 연결하려고 합니다. 그릇 좌표 목록 `bowls`가 주어지며, `bowls[i] = [xi, yi]`는 물그릇 `i`의 위치입니다. 물그릇 `i`와 `j`를 잇는 호스는 격자를 따라 지나가므로 길이가 `|xi - xj| + |yi - yj|` 미터입니다.

중간 물그릇을 거쳐도 좋으니, 모든 물그릇이 서로 도달 가능하도록 만드는 최소 총 호스 길이를 반환하세요.

**예시 1:**
```
입력: bowls = [[4,4],[4,3],[6,7],[10,2]]
출력: 13
설명: [4,4]-[4,3](길이 1), [4,4]-[6,7](길이 5), [4,3]-[10,2](길이 7) 호스를 깔면 모든 그릇이 연결되며 합이 13미터입니다.
```

**예시 2:**
```
입력: bowls = [[0,0],[2,0]]
출력: 2
설명: 두 그릇을 잇는 데에는 길이 2짜리 호스 하나면 충분합니다.
```$$,
 $$- `1 <= bowls.length <= 1200`
- `-10^8 <= xi, yi <= 10^8`
- 모든 그릇 좌표는 서로 다릅니다.$$),

-- 8. guild-chat-relay
((SELECT id FROM problems WHERE slug = 'guild-chat-relay'), 'ko',
 $$길드 공지 전파 시간$$,
 $$`1`번부터 `n`번까지 번호가 매겨진 `n`명의 플레이어가 있는 길드가 있습니다. 중계 목록 `links`는 일방향 핑 목록으로, `links[i] = [source, target, minutes]`는 `source`에서 `target`으로 `minutes`분 뒤 핑이 전달된다는 뜻입니다. 각 플레이어는 메시지를 처음 받는 순간 곧바로 재전송합니다.

시작 플레이어 `src`가 주어질 때, 모든 플레이어가 메시지를 받기까지 걸리는 **최소 분**을 반환하세요. 닿지 못하는 플레이어가 있으면 `-1`을 반환합니다.

**예시 1:**
```
입력: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
출력: 6
설명: 플레이어 3은 2분에, 플레이어 2는 3분에(1 -> 3 -> 2 경로), 플레이어 4는 6분에(1 -> 3 -> 2 -> 4 경로) 메시지를 받습니다.
```

**예시 2:**
```
입력: links = [[1,2,5]], n = 3, src = 1
출력: -1
설명: 플레이어 3에게 도달하는 중계가 없으므로 전파가 끝나지 않습니다.
```$$,
 $$- `1 <= n <= 120`
- `1 <= links.length <= 6500`
- `links[i].length == 3`
- `1 <= source, target <= n`이고 `source != target`
- `1 <= minutes <= 120`
- 모든 `(source, target)` 쌍은 유일합니다.$$),

-- 9. cheapest-courier-route
((SELECT id FROM problems WHERE slug = 'cheapest-courier-route'), 'ko',
 $$가장 싼 배송 경로$$,
 $$어떤 배송 도구가 `0..n-1`로 번호 매겨진 `n`개 카페 사이를 단방향 배달 링크로 이어 주문을 전달합니다. 링크 목록 `links[i] = [from, to, minutes]`는 카페 `from`에서 카페 `to`까지 `minutes`분이 걸리는 한 구간을 뜻합니다.

출발지 `src`, 도착지 `dst`, 그리고 중간에 거칠 수 있는 카페 수의 상한 `maxHops`가 주어졌을 때, `src`에서 `dst`까지 배달하는 **최소 총 소요 분**을 반환하세요. 경유 카페 수가 `maxHops` 이하인 경로가 존재하지 않으면 `-1`을 반환합니다.

**예시 1:**
```
입력: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
출력: 220
설명: 0 -> 1 -> 3 -> 4 경로(비용 50 + 150 + 20 = 220)는 중간 카페 2개를 거칩니다. 더 싼 0 -> 1 -> 2 -> 3 -> 4 경로는 중간 카페 3개가 필요해서 허용되지 않습니다.
```

**예시 2:**
```
입력: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
출력: 400
설명: maxHops = 0이므로 직행 링크 0 -> 3(400분)만 인정됩니다. 0 -> 1 -> 2 -> 3 경로는 합이 210분이지만 경유 카페가 너무 많아 제외됩니다.
```$$,
 $$- `1 <= n <= 120`
- `0 <= links.length <= n * (n - 1) / 2`
- `links[i].length == 3`
- `0 <= from, to < n`이고 `from != to`
- `1 <= minutes <= 8000`
- `0 <= src, dst, maxHops < n`
- `src != dst`$$),

-- 10. rising-water-path
((SELECT id FROM problems WHERE slug = 'rising-water-path'), 'ko',
 $$물에 잠기는 통로 건너기$$,
 $$수위가 점점 올라가는 `n x n` 격자를 가로질러 건너가야 합니다. 높이 격자 `elevation[r][c]`는 행 `r`, 열 `c`에 있는 타일의 높이입니다. 시각 `t`에는 높이가 `<= t`인 타일은 밟을 수 있고, 그보다 높은 타일은 아직 잠겨 있어 통과할 수 없습니다.

`(0, 0)`에서 출발해 상하좌우로 인접한 밟을 수 있는 타일들만 이동해서 `(n - 1, n - 1)`까지 도달해야 합니다. 유효한 경로가 처음 생기는 최소 시각 `t`를 반환하세요.

**예시 1:**
```
입력: elevation = [[1,0],[2,3]]
출력: 3
설명: 도착지 자체의 높이가 3이므로 t = 3 이전에는 어떤 경로도 존재할 수 없습니다. t = 3에서 모든 타일을 밟을 수 있게 됩니다.
```

**예시 2:**
```
입력: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
출력: 14
설명: 최적 경로 (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) 위에서 가장 높은 칸의 높이는 도착지 자체의 14입니다.
```$$,
 $$- `n == elevation.length == elevation[i].length`
- `1 <= n <= 60`
- `0 <= elevation[r][c] < n * n`
- `elevation`의 모든 높이 값은 서로 다릅니다.$$);
