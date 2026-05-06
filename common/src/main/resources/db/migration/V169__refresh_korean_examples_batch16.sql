-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 16 (problems #151-#160)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (tags, links, routes, s,
-- effort, tickets, pages, n, parent, span) stay verbatim. The first
-- mention of each variable in Korean prose is paired with a Korean noun
-- phrase describing its role. Constraint identifiers align with the
-- canonical English parameter names from V135 (eight problems), V137
-- (redundant-friendship), and V152 (longest-palindromic-substring).

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'recover-tier-order', 'redundant-friendship', 'dog-street-walk',
      'longest-palindromic-substring', 'min-stamina-checkpoints',
      'split-ticket-pile', 'count-square-candy-bags',
      'nth-unlockable-level', 'count-task-orderings', 'split-candy-bar'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. recover-tier-order
((SELECT id FROM problems WHERE slug = 'recover-tier-order'), 'ko',
 $$티어 순서 복원$$,
 $$친구가 소문자 영웅 태그 목록을 자기만의 티어 순서 — 알파벳 26글자에 대한 어떤 알 수 없는 순열 — 로 정렬해 두었습니다. 이미 정렬된 태그 목록 `tags`가 주어지면, 그 순서를 문자열 하나로 복원하세요.

인접한 두 태그가 어떤 순서로도 설명되지 않는다면(예: 더 긴 태그가 자기를 접두사로 가지는 짧은 태그보다 먼저 나오는 경우) `""`를 반환합니다. 유효한 순서가 존재할 때, 입력은 `tags`에 등장하는 글자에 대해 정확히 하나의 순서만 성립하도록 주어집니다.

**예시 1:**
```
입력: tags = ["ab","ba","bc","cb","cd","dc"]
출력: "abcd"
설명: 인접 쌍들이 a는 b보다, b는 c보다, c는 d보다 앞이라는 제약을 강제하므로 a -> b -> c -> d가 유일한 순서입니다.
```

**예시 2:**
```
입력: tags = ["studio","stud"]
출력: ""
설명: "stud"가 "studio"의 접두사인데 뒤에 등장하므로, 어떤 알파벳 순서로도 이 배치를 정당화할 수 없습니다.
```$$,
 $$- `tags`에는 최소 하나의 태그가 포함됩니다.
- 각 태그는 영어 소문자로 이루어진 비어 있지 않은 문자열입니다.
- 유효한 순서가 존재할 때, 테스트 입력은 `tags`에 등장하는 알파벳에 대해 인접 쌍 제약과 일관되는 순서가 정확히 하나만 존재하도록 구성됩니다.$$),

-- 2. redundant-friendship
((SELECT id FROM problems WHERE slug = 'redundant-friendship'), 'ko',
 $$불필요한 친구 관계 찾기$$,
 $$`1`부터 `n`까지 번호가 매겨진 학생 `n`명의 친구 관계도는 원래 트리여야 했는데, 누군가 간선을 하나 더 추가하는 바람에 지금은 정확히 하나의 순환이 생겼습니다. 친구 관계 목록 `links`가 주어지고, 각 `links[i] = [a, b]`는 방향이 없는 친구 관계를 의미합니다.

다시 트리가 되도록 제거해야 할 간선 하나를 반환하세요. 순환을 끊을 수 있는 간선이 여러 개라면, `links`에서 **가장 나중에** 등장하는 간선을 반환합니다.

**예시 1:**
```
입력: links = [[1,2],[1,3],[2,3]]
출력: [2,3]
설명: [1,2]와 [1,3]만으로도 학생 1, 2, 3이 이미 연결되어 있고, [2,3]이 순환을 닫는 가장 나중 간선입니다.
```

**예시 2:**
```
입력: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
출력: [2,5]
설명: 순환은 2 - 3 - 4 - 5 - 2이고, [3,4]와 [2,5]가 모두 순환에 속하지만 [2,5]가 더 뒤에 등장하므로 이를 제거합니다.
```$$,
 $$- `n == links.length`
- `3 <= n <= 1200`
- `links[i].length == 2`
- `1 <= links[i][0], links[i][1] <= n`
- `links[i][0] != links[i][1]`
- 같은 쌍을 나타내는 간선은 두 번 나오지 않습니다.
- 친구 관계 그래프는 연결되어 있고 정확히 하나의 순환을 포함합니다.$$),

-- 3. dog-street-walk
((SELECT id FROM problems WHERE slug = 'dog-street-walk'), 'ko',
 $$강아지 동네 산책$$,
 $$강아지가 동네의 모든 길을 한 번씩 빠짐없이 걷고 싶어하고, 시작점은 우리집(`"HUB"` 구역)입니다. 일방통행 길 목록 `routes`가 주어지며, 각 항목은 `[from, to]` 형태의 한 구간입니다.

`"HUB"`에서 출발해 모든 구간을 정확히 한 번씩 사용하는 산책 경로를 반환하세요. 가능한 경로가 여러 개라면, 구역 코드를 앞에서부터 차례로 비교했을 때 **사전순으로 가장 작은** 경로를 반환합니다. 유효한 경로가 최소 하나는 존재함이 보장됩니다.

**예시 1:**
```
입력: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
출력: ["HUB","BIR","ELM","HUB","CED"]
설명: HUB -> BIR -> ELM -> HUB -> CED 순서로 가면 네 구간을 모두 사용합니다. CED를 먼저 가버리면 BIR과 ELM에 가기 전에 갇혀 버립니다.
```

**예시 2:**
```
입력: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
출력: ["HUB","NOR","SOU","HUB","SOU","NOR"]
설명: 허브에서 SOU보다 NOR로 먼저 가는 쪽이 모든 구간을 끝까지 도는 경로 중 사전순으로 가장 작습니다.
```$$,
 $$- `1 <= routes.length <= 320`
- `routes[i].length == 2`
- 각 `from`과 `to`는 세 글자 대문자 구역 코드입니다.
- 같은 구간 안에서 `from != to`입니다.
- 주어진 구간들은 `"HUB"`에서 시작하는 유효한 경로를 최소 하나 이상 허용합니다.$$),

-- 4. longest-palindromic-substring
((SELECT id FROM problems WHERE slug = 'longest-palindromic-substring'), 'ko',
 $$가장 긴 회문 부분 문자열$$,
 $$문자열 `s`가 주어졌을 때, `s`의 가장 긴 회문 부분 문자열의 **길이**를 반환하세요. 회문 부분 문자열이란 앞에서 읽으나 뒤에서 읽으나 같은 부분 문자열을 말합니다.

**예시 1:**
```
입력: s = "babad"
출력: 3
설명: "bab"와 "aba"가 모두 길이 3인 회문 부분 문자열입니다.
```

**예시 2:**
```
입력: s = "cbbd"
출력: 2
설명: "bb"의 길이는 2이고, 그보다 긴 회문 부분 문자열은 존재하지 않습니다.
```

**예시 3:**
```
입력: s = "a"
출력: 1
```$$,
 $$- `1 <= s.length <= 1000`
- `s`는 영어 소문자로만 이루어져 있습니다.$$),

-- 5. min-stamina-checkpoints
((SELECT id FROM problems WHERE slug = 'min-stamina-checkpoints'), 'ko',
 $$체크포인트 최소 스태미나$$,
 $$플랫포머 게임에 `0`번부터 `n-1`번까지 번호가 매겨진 `n`개의 체크포인트가 있습니다. 체크포인트 `i`에 착지하면 스태미나 `effort[i]`만큼을 소모합니다. 시작은 `0`번 또는 `1`번 체크포인트에서 할 수 있고, 어느 체크포인트에서든 한 칸 또는 두 칸 앞으로 점프할 수 있으며, 착지하는 체크포인트의 비용을 지불합니다.

마지막 체크포인트를 지나(`n`번 위치) 빠져나오기 위해 필요한 최소 총 스태미나를 반환하세요.

**예시 1:**
```
입력: effort = [4,2,8,3,5,6]
출력: 10
설명: 체크포인트 1에서 시작(2 지불), 체크포인트 3으로 점프(3 지불), 체크포인트 5로 점프(5 지불) 후 빠져나옵니다. 합계 2 + 3 + 5 = 10입니다.
```

**예시 2:**
```
입력: effort = [7,1,7,1,7]
출력: 2
설명: 체크포인트 1에서 시작(1 지불), 두 칸 점프해 체크포인트 3에 도착(1 지불), 두 칸 더 점프해 빠져나옵니다. 총 비용은 2입니다.
```$$,
 $$- `2 <= effort.length <= 2 * 10^3`
- `0 <= effort[i] <= 800`$$),

-- 6. split-ticket-pile
((SELECT id FROM problems WHERE slug = 'split-ticket-pile'), 'ko',
 $$티켓 더미 균등 분할$$,
 $$각 티켓에 정수 노력 점수가 적힌 배열 `tickets`가 주어집니다. 이 더미를 노력 합이 똑같은 두 개의 서로소 그룹으로 나눌 수 있는지 판단하세요.

균등하게 나눌 수 있으면 `true`, 그렇지 않으면 `false`를 반환하도록 `canSplitLoads(tickets)`를 구현하세요.

**예시 1:**
```
입력: tickets = [3,1,1,2,2,1]
출력: true
설명: 합이 10이므로 각자 5씩 가져가야 합니다. 한 가지 분할 예: 한 사람은 {3, 2}, 다른 사람은 {1, 1, 2, 1}로 양쪽 모두 5가 됩니다.
```

**예시 2:**
```
입력: tickets = [2,2,3,5]
출력: false
설명: 합이 12라서 각자 6씩 가져가야 하는데, {2, 2, 3, 5}의 어떤 부분집합도 합이 6이 되지 않습니다.
```$$,
 $$- `1 <= tickets.length <= 200`
- `1 <= tickets[i] <= 100`$$),

-- 7. count-square-candy-bags
((SELECT id FROM problems WHERE slug = 'count-square-candy-bags'), 'ko',
 $$제곱수 사탕 봉지 개수$$,
 $$어느 사탕 가게는 완전제곱수 크기의 봉지 — 1, 4, 9, 16, 25 등 — 만 판매하며, 어떤 크기든 원하는 만큼 살 수 있습니다. 봉지 크기들의 합이 정확히 `pages`가 되도록 하는 데 필요한 최소 봉지 개수를 반환하도록 `countExactTargets(pages)`를 구현하세요.

**예시 1:**
```
입력: pages = 7
출력: 4
설명: 크기 4인 봉지 하나에 크기 1인 봉지 세 개를 더하면 합이 7이 됩니다. 봉지를 1개, 2개, 또는 3개만 써서는 7을 만들 수 없습니다.
```

**예시 2:**
```
입력: pages = 17
출력: 2
설명: 17 = 16 + 1.
```

**예시 3:**
```
입력: pages = 5
출력: 2
설명: 5 = 4 + 1.
```$$,
 $$- `1 <= pages <= 12000`$$),

-- 8. nth-unlockable-level
((SELECT id FROM problems WHERE slug = 'nth-unlockable-level'), 'ko',
 $$N번째 해금 가능 레벨$$,
 $$**해금 가능한** 레벨이란 모든 소인수가 `{2, 3, 5}` 안에 들어 있는 양의 정수를 말하며, 관례상 `1`도 해금 가능한 레벨입니다. 해금 가능한 레벨을 작은 순서대로 늘어놓으면 `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...`이 됩니다(`7`은 빠집니다).

`n`번째(1-인덱스) 해금 가능 레벨을 반환하세요.

**예시 1:**
```
입력: n = 7
출력: 8
설명: 처음 일곱 개의 해금 가능 레벨은 1, 2, 3, 4, 5, 6, 8이므로 7번째는 8입니다.
```

**예시 2:**
```
입력: n = 12
출력: 16
설명: 처음 열두 개의 해금 가능 레벨은 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16이므로 12번째는 16입니다.
```$$,
 $$- `1 <= n <= 1500`$$),

-- 9. count-task-orderings
((SELECT id FROM problems WHERE slug = 'count-task-orderings'), 'ko',
 $$유효한 작업 순서 개수$$,
 $$팀 프로젝트에 `0`번부터 `n - 1`번까지 번호가 매겨진 `n`개의 하위 작업이 있습니다. 작업 `0`을 제외한 모든 작업은 먼저 끝나야 하는 선행 작업을 정확히 하나씩 가지므로, 의존 관계는 트리를 이루고 루트에서는 `parent[0] = -1`입니다.

한 번에 한 사람만 작업할 수 있으므로 작업은 한 개씩 처리됩니다. `n`개의 작업 전체에 대해 유효한 완료 순서의 수를 `10^8 + 7`로 나눈 나머지로 반환하세요.

**예시 1:**
```
입력: parent = [-1,0,0,2,2]
출력: 8
설명: 작업 0이 가장 먼저입니다. 그 아래에서 작업 1은 잎이고, 작업 3과 4는 작업 2에 매달려 있습니다. 두 가지 가지를 끼워 넣어 만들 수 있는 서로 다른 순서가 8가지입니다.
```

**예시 2:**
```
입력: parent = [-1,0,1,2,3]
출력: 1
설명: 0 -> 1 -> 2 -> 3 -> 4로 이어지는 사슬 구조이므로 유효한 순서는 단 하나뿐입니다.
```

**예시 3:**
```
입력: parent = [-1,0,0,0,0]
출력: 24
설명: 작업 0 다음에는 네 자식 작업을 어떤 순서로든 처리할 수 있으므로 4! = 24가지 순서가 나옵니다.
```$$,
 $$- `1 <= n <= 2 * 10^5`
- `parent.length == n`
- `parent[0] == -1`
- `i >= 1`일 때 `0 <= parent[i] < n`
- 입력은 항상 유효한 루트 트리를 나타냄이 보장됩니다.$$),

-- 10. split-candy-bar
((SELECT id FROM problems WHERE slug = 'split-candy-bar'), 'ko',
 $$사탕 막대 분할로 곱 최대화$$,
 $$길이 `span`(양의 정수) 칸짜리 사탕 막대를 길이가 양의 정수인 두 개 이상의 연속된 조각으로 나눕니다. 분할의 점수는 조각 길이들의 곱입니다.

모든 유효한 분할 중에서 얻을 수 있는 최대 곱을 반환하도록 `splitProductMax(span)`을 구현하세요.

**예시 1:**
```
입력: span = 5
출력: 6
설명: 가장 좋은 분할은 5 = 2 + 3이고, 곱은 2 * 3 = 6입니다. 다른 분할(1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1)은 모두 점수가 더 낮습니다.
```

**예시 2:**
```
입력: span = 11
출력: 54
설명: 가장 좋은 분할은 11 = 3 + 3 + 3 + 2이고, 곱은 3 * 3 * 3 * 2 = 54입니다. 3+4+4는 48, 3+3+5는 45가 됩니다.
```$$,
 $$- `2 <= span <= 60`$$);
