-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 14 (problems #131-#140)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (userId, messageId, num,
-- cookies, topics, k, snacks, pastries, tab, menu, digits, n, edges,
-- rooms) stay verbatim. First mention of each variable in Korean prose is
-- paired with a Korean noun phrase describing its role. Constraint
-- identifiers are aligned with the canonical English parameter names from
-- V135 / V152 source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'micro-feed', 'running-median-timer', 'space-cookie-bakes',
      'trending-chat-topics', 'snack-combo-picks', 'menu-combos-tab',
      'palindrome-menu-splits', 'restore-wifi-ip', 'graph-valid-tree',
      'walls-and-gates'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. micro-feed
((SELECT id FROM problems WHERE slug = 'micro-feed'), 'ko',
 $$짧은 글 피드$$,
 $$게임 친목 보드용 `MicroFeed` 클래스를 만들어 보세요. 플레이어들은 짧은 상태 글을 올리고, 서로 팔로우하고, 최신순 피드를 확인할 수 있어야 합니다.

- `MicroFeed()` — 빈 보드로 시작합니다.
- `publishPost(int userId, int messageId)` — 플레이어 `userId`가 글 식별자 `messageId`를 올립니다. `messageId`는 전역에서 유일하며, 호출된 순서대로 들어옵니다.
- `List<Integer> latestFeed(int userId)` — `userId` 본인과 현재 팔로우 중인 플레이어들의 글 중 가장 최근 메시지 id를 최대 10개까지 최신순으로 반환합니다.
- `subscribe(int followerId, int followeeId)` — `followerId`가 `followeeId`를 팔로우합니다. 두 id가 같으면 아무것도 하지 않습니다.
- `unsubscribe(int followerId, int followeeId)` — `followerId`가 `followeeId` 팔로우를 끊습니다. 두 id가 같거나 팔로우 중이 아니면 아무것도 하지 않습니다.

**예시 1:**
```
입력: ["MicroFeed","publishPost","publishPost","latestFeed"]
      [[],[1,10],[1,20],[1]]
출력: [null,null,null,[20,10]]
설명: 플레이어 1이 두 번 글을 올리고, 자기 글을 최신순으로 확인합니다.
```

**예시 2:**
```
입력: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
      [[],[1,10],[2,20],[1,2],[1]]
출력: [null,null,null,null,[20,10]]
설명: 플레이어 1이 2를 팔로우한 뒤부터는 2의 글도 피드에 보입니다.
```

**예시 3:**
```
입력: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
      [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
출력: [null,null,null,null,[20,10],null,[10]]
설명: 언팔하는 즉시 플레이어 2의 글은 1의 피드에서 사라집니다.
```$$,
 $$- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 8000`
- `publishPost`, `latestFeed`, `subscribe`, `unsubscribe`를 통틀어 최대 `20000`회의 호출이 발생합니다.$$),

-- 2. running-median-timer
((SELECT id FROM problems WHERE slug = 'running-median-timer'), 'ko',
 $$실시간 중앙값 추적$$,
 $$스피드런 타이머는 시도할 때마다 완주한 초를 기록합니다. 새로운 시도가 실시간으로 쌓이는 상황에서도, 원할 때마다 지금까지의 완주 시간 중앙값을 바로 얻고 싶습니다. 기록을 추적하면서 누적 중앙값을 알려주는 `StreamMedian`을 만드세요. 기록 개수가 짝수면 중앙값은 가운데 두 값의 평균이고, 홀수면 가운데 한 값입니다. 두 경우 모두 `double`로 반환합니다.

`StreamMedian` 클래스를 구현하세요.

- `StreamMedian()` — 기록이 하나도 없는 상태에서 시작합니다.
- `void record(int num)` — 새 시도의 완주 시간 `num`을 기록합니다.
- `double median()` — 지금까지 기록된 모든 시도의 중앙값을 반환합니다. `record`가 최소 한 번 호출된 뒤에만 불립니다.

**예시:**
```
collector = new StreamMedian()
collector.record(1)
collector.median()    // 1.0
collector.record(2)
collector.median()    // (1 + 2) / 2 = 1.5
collector.record(3)
collector.median()    // [1, 2, 3]의 가운데 값 = 2.0
```$$,
 $$- `-80000 <= num <= 80000`
- `record`와 `median` 호출은 합쳐서 최대 `40000`회입니다.
- `median`은 첫 번째 `record` 이전에는 호출되지 않습니다.$$),

-- 3. space-cookie-bakes
((SELECT id FROM problems WHERE slug = 'space-cookie-bakes'), 'ko',
 $$쿠키 사이 간격 두기$$,
 $$문자열 `cookies`가 주어졌을 때, 인접한 두 글자가 서로 같지 않도록 글자를 재배열하세요. 가능한 배열 중 아무거나 하나를 반환하고, 그런 배열이 불가능하면 `""`를 반환합니다.

**예시 1:**
```
입력: cookies = "bread"
출력: "brade"
설명: 인접한 두 글자가 같지 않은 어떤 배열이든 정답으로 인정합니다 — 예를 들어 "brade"나 "dabre".
```

**예시 2:**
```
입력: cookies = "aaaab"
출력: ""
설명: 길이 5인 문자열에서 'a'가 4번 등장하므로, 어떻게 배열해도 'a' 두 개가 반드시 붙게 됩니다.
```

**예시 3:**
```
입력: cookies = "flour"
출력: "flour"
설명: 모든 글자가 서로 다르므로 입력 자체가 이미 유효한 배열입니다.
```$$,
 $$- `1 <= cookies.length <= 800`
- `cookies`는 영어 소문자로만 이루어져 있습니다.$$),

-- 4. trending-chat-topics
((SELECT id FROM problems WHERE slug = 'trending-chat-topics'), 'ko',
 $$단톡방 유행 주제$$,
 $$반 단톡방이 쉴 새 없이 울리는 와중에 오늘 메시지에서 가장 많이 언급된 주제 태그 `k`개를 뽑아 보려 합니다. 등장 횟수가 같다면 알파벳 오름차순으로 우선순위를 정합니다.

등장 횟수 내림차순, 동점 시 라벨 오름차순으로 정렬된 상위 `k`개의 태그를 반환하도록 `rankTrendingTopics(topics, k)`를 구현하세요.

**예시 1:**
```
입력: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
출력: ["climate","market"]
설명: "climate"는 3번, "market"은 2번 등장하며, 가장 많이 언급된 두 태그입니다.
```

**예시 2:**
```
입력: topics = ["tech","tech","film","film","music","books","music"], k = 3
출력: ["film","music","tech"]
설명: "film", "music", "tech"가 모두 두 번씩 등장해서 알파벳 순으로 반환됩니다.
```$$,
 $$- `1 <= topics.length <= 2 * 10^3`
- `1 <= topics[i].length <= 10`
- `topics[i]`는 영어 소문자로만 이루어져 있습니다.
- `k`는 `[1, 서로 다른 주제 수]` 범위에 있습니다.
- 정답은 유일함이 보장됩니다.$$),

-- 5. snack-combo-picks
((SELECT id FROM problems WHERE slug = 'snack-combo-picks'), 'ko',
 $$간식 조합 뽑기$$,
 $$간식팩 티켓이 담긴 배열 `snacks`가 있고, 각 티켓에는 맛 코드가 적혀 있으며 같은 맛이 중복해서 나올 수 있습니다. 여기서 만들 수 있는 서로 다른 조합을 모두 나열해야 합니다.

정수 배열 `snacks`가 주어질 때, 티켓으로 만들 수 있는 모든 서로 다른 중복집합(multiset)을 리스트의 리스트로 반환하는 `listMontageScenes`를 구현하세요. 빈 조합도 포함해야 하며, 결과의 순서는 상관없습니다.

**예시 1:**
```
입력: snacks = [2,5,5]
출력: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**예시 2:**
```
입력: snacks = [5]
출력: [[],[5]]
```

**예시 3:**
```
입력: snacks = [2,2,2,1,2]
출력: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
설명: 맛 2는 네 번, 맛 1은 한 번 등장하며, 서로 다른 중복집합이 각각 정확히 한 번씩 결과에 포함됩니다.
```$$,
 $$- `1 <= snacks.length <= 10`
- `-10 <= snacks[i] <= 10`$$),

-- 6. menu-combos-tab
((SELECT id FROM problems WHERE slug = 'menu-combos-tab'), 'ko',
 $$계산서에 딱 맞는 메뉴 조합$$,
 $$배열 `pastries`에는 카페 페이스트리들의 가격이 들어 있습니다(같은 값이 반복될 수 있음). 합이 정확히 `tab`이 되는 서로 다른 모든 조합을 찾으세요. 진열대의 각 페이스트리는 한 조합 안에서 최대 한 번만 쓸 수 있고, 가격 중복집합이 같은 두 조합은 하나로 취급합니다.

`listQuotaBatches`를 구현해 서로 다른 모든 중복집합을 반환하세요. 반환 순서는 자유입니다.

**예시 1:**
```
입력: pastries = [2,3,6,1,3,4], tab = 7
출력: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**예시 2:**
```
입력: pastries = [4,2,1,2,3], tab = 5
출력: [[1,2,2],[1,4],[2,3]]
```

**예시 3:**
```
입력: pastries = [8,8,8], tab = 16
출력: [[8,8]]
설명: 8이 세 번 등장하지만, 합이 16이 되는 묶음은 8 두 개로 이루어진 짝뿐입니다.
```$$,
 $$- `1 <= pastries.length <= 100`
- `1 <= pastries[i] <= 50`
- `1 <= tab <= 30`$$),

-- 7. palindrome-menu-splits
((SELECT id FROM problems WHERE slug = 'palindrome-menu-splits'), 'ko',
 $$팰린드롬 조각으로 쪼개기$$,
 $$소문자로 이루어진 문자열 `menu`가 주어집니다. `menu`를 왼쪽부터 오른쪽까지 전부 덮도록 조각으로 나누되, **각 조각이 팰린드롬**이 되는 모든 분할을 반환하는 `splitMirrorPhrases`를 구현하세요. 글자 하나짜리도 팰린드롬으로 칩니다. 바깥 리스트의 순서는 상관없습니다.

**예시 1:**
```
입력: menu = "dbbc"
출력: [["d","b","b","c"],["d","bb","c"]]
설명: 두 가지 분할이 유효합니다. "d", "b", "bb", "c" 모두 팰린드롬입니다.
```

**예시 2:**
```
입력: menu = "ef"
출력: [["e","f"]]
설명: "ef"가 팰린드롬이 아니므로 글자별로 쪼개는 것만 가능합니다.
```$$,
 $$- `1 <= menu.length <= 16`
- `menu`는 영어 소문자로만 이루어져 있습니다.$$),

-- 8. restore-wifi-ip
((SELECT id FROM problems WHERE slug = 'restore-wifi-ip'), 'ko',
 $$IP 주소로 쪼개기$$,
 $$룸메이트가 Wi-Fi IP를 숫자만 쭉 이어서 적어 놨습니다. 이 숫자열로부터 만들 수 있는 모든 유효한 주소를 복원하세요. 유효한 주소는 점으로 구분된 정확히 네 조각으로 이루어지며, 각 조각은 `0` 이상 `255` 이하의 값이고, 조각이 `"0"` 자체가 아니라면 선행 0을 가질 수 없습니다.

문자열 `digits`가 주어지면, 점 세 개를 끼워 넣어 만들 수 있는 유효한 주소를 모두 반환하세요. 결과는 사전식 오름차순으로 정렬하며, 유효한 주소가 하나도 없으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: digits = "19216811"
출력: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**예시 2:**
```
입력: digits = "0202"
출력: ["0.2.0.2"]
설명: `"0"` 한 글자짜리 조각은 괜찮지만, 두 자리 조각은 `0`으로 시작할 수 없습니다.
```$$,
 $$- `1 <= digits.length <= 20`
- `digits`는 십진수 숫자로만 이루어져 있습니다.$$),

-- 9. graph-valid-tree
((SELECT id FROM problems WHERE slug = 'graph-valid-tree'), 'ko',
 $$유효한 트리 판별$$,
 $$정수 `n`(`0..n-1`로 번호가 매겨진 노드의 개수)과 무방향 간선 배열 `edges`가 주어집니다. 각 `edges[i] = [u, v]`는 `u`와 `v`를 잇는 간선입니다. `(n, edges)`가 유효한 트리를 이루는지 판단하세요.

유효한 트리란 모든 노드가 서로 도달 가능한 **연결 그래프**이고, **사이클이 없으며**, 정확히 `n - 1`개의 간선을 갖는 그래프를 뜻합니다.

**예시 1:**
```
입력: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
출력: true
```

**예시 2:**
```
입력: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
출력: false
설명: 간선 1-2, 2-3, 1-3이 사이클을 이룹니다.
```$$,
 $$- `1 <= n <= 2 * 10^3`
- `0 <= edges.length <= 4500`
- `edges[i].length == 2`
- `0 <= edges[i][0], edges[i][1] < n`
- 자기 자신으로의 루프나 중복된 간선은 없습니다.$$),

-- 10. walls-and-gates
((SELECT id FROM problems WHERE slug = 'walls-and-gates'), 'ko',
 $$벽과 문 거리 채우기$$,
 $$`m × n` 격자 `rooms`가 주어집니다. 각 칸은 다음 셋 중 하나입니다:
- `-1` — **벽**(이동 불가).
- `0` — **문**.
- `2147483647`(즉, INT_MAX) — **빈 방**.

각 빈 방에 가장 가까운 문까지의 거리(상하좌우로 이동한 칸 수)를 채워 `rooms`를 **제자리에서** 갱신하세요. 어떤 문에도 도달할 수 없는 빈 방은 그대로 `2147483647`로 둡니다.

**예시 1:**
```
입력: rooms = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
출력: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
```

**예시 2:**
```
입력: rooms = [[-1]]
출력: [[-1]]
```$$,
 $$- `1 <= m, n <= 250`
- `rooms[i][j]`는 `-1`, `0`, 또는 `2147483647`입니다.$$);
