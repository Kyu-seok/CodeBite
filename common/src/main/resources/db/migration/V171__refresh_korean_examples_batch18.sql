-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 18 (problems #171-#180)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (scores, cards, groupSize,
-- stickers, tags, bags, target, players, trays, bookings, probes, zones)
-- stay verbatim. The first mention of each variable in Korean prose is
-- paired with a Korean noun phrase describing its role. Constraint
-- identifiers align with the canonical English parameter names from V135
-- (longest-level-up-path, can-attend-bookings, cover-aquarium-zones,
-- shortest-table-booking, verify-pizza-rotation) and V137
-- (group-study-cards, split-sticker-runs, balance-print-queue,
-- grocery-bag-triple, rebuild-tournament-line).

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'longest-level-up-path', 'group-study-cards', 'split-sticker-runs',
      'balance-print-queue', 'grocery-bag-triple', 'rebuild-tournament-line',
      'verify-pizza-rotation', 'can-attend-bookings', 'shortest-table-booking',
      'cover-aquarium-zones'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. longest-level-up-path
((SELECT id FROM problems WHERE slug = 'longest-level-up-path'), 'ko',
 $$가장 긴 레벨업 경로$$,
 $$퍼즐 게임의 보드는 `m x n` 격자 `scores`로 표현됩니다. 어느 칸에서든 출발할 수 있고, 인접한 칸(상하좌우)으로 이동하려면 그 칸의 점수가 **엄격하게 더 커야** 합니다.

`scores` 위에서 점수가 엄격하게 증가하는 가장 긴 경로의 길이를 반환하는 `longestVineAscent`를 구현하세요.

**예시 1:**
```
입력: scores = [[2,5,8],[3,4,7],[1,6,9]]
출력: 5
설명: 좌하단의 1에서 출발해 1 -> 3 -> 4 -> 7 -> 9 순으로 이동하면 다섯 칸을 거치며 매번 점수가 더 커집니다.
```

**예시 2:**
```
입력: scores = [[4,2,1],[5,6,3]]
출력: 5
설명: 1 -> 2 -> 4 -> 5 -> 6 콤보가 인접한 다섯 칸을 점수가 엄격히 증가하며 통과합니다.
```$$,
 $$- `m == scores.length`
- `n == scores[i].length`
- `1 <= m, n <= 200`
- `0 <= scores[i][j] <= 10^8`$$),

-- 2. group-study-cards
((SELECT id FROM problems WHERE slug = 'group-study-cards'), 'ko',
 $$스터디 카드 묶기$$,
 $$스터디 모임에서 플래시카드를 `groupSize`개씩 연속된 숫자로 이뤄진 묶음(예: `groupSize = 3`이면 `{7,8,9}`)으로 나눠 가지려고 합니다. 모든 카드는 정확히 하나의 묶음에 들어가야 합니다.

정수 배열 `cards`와 정수 `groupSize`가 주어질 때, 카드 더미를 이런 식으로 나눌 수 있으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
입력: cards = [1,2,3,4,5,6,7,8], groupSize = 2
출력: true
설명: [1,2], [3,4], [5,6], [7,8]처럼 두 장씩 묶을 수 있습니다.
```

**예시 2:**
```
입력: cards = [1,2,3,4], groupSize = 3
출력: false
설명: 카드 네 장은 세 장짜리 묶음으로 나누어떨어지지 않습니다.
```$$,
 $$- `1 <= cards.length <= 2 * 10^5`
- `0 <= cards[i] <= 10^8`
- `1 <= groupSize <= cards.length`$$),

-- 3. split-sticker-runs
((SELECT id FROM problems WHERE slug = 'split-sticker-runs'), 'ko',
 $$스티커 문자열 구간 분할$$,
 $$스티커가 한 줄로 붙어 있는 문자열 `stickers`를 가능한 한 적은 수의 연속된 조각으로 나누되, 각 알파벳 글자는 정확히 한 조각 안에서만 등장하도록 해야 합니다. 조각들을 차례로 이으면 원래 `stickers`와 같아야 합니다.

각 조각의 길이를 순서대로 반환하세요.

**예시 1:**
```
입력: stickers = "abacbcd"
출력: [6,1]
설명: 'a', 'b', 'c'는 모두 인덱스 5 이전에 마지막으로 나타나므로 첫 조각이 0..5 (스티커 6장)을 덮습니다. 'd'는 끝에 홀로 남습니다.
```

**예시 2:**
```
입력: stickers = "rsrsr"
출력: [5]
설명: 'r'과 's'가 문자열 전체에 걸쳐 다시 나타나므로 전체가 하나의 조각이 됩니다.
```$$,
 $$- `1 <= stickers.length <= 500`
- `stickers`는 영어 소문자로 이루어져 있습니다.$$),

-- 4. balance-print-queue
((SELECT id FROM problems WHERE slug = 'balance-print-queue'), 'ko',
 $$인쇄 작업 균형 맞추기$$,
 $$인쇄 작업 큐가 문자열로 주어집니다. `(`는 배치 시작, `)`는 배치 종료를 뜻하고, `*`는 `(`, `)`, 또는 빈 칸 중 무엇으로든 쓸 수 있는 유연한 슬롯입니다.

큐 문자열 `tags`가 주어질 때, 유연한 슬롯들을 적절히 배정해서 모든 여는 괄호가 뒤쪽의 닫는 괄호와 짝을 이룰 수 있으면 `true`를 반환하세요.

**예시 1:**
```
입력: tags = "((*)"
출력: true
설명: 유연한 슬롯을 `)`로 해석하면 `"(())"`가 되어 균형이 맞습니다.
```

**예시 2:**
```
입력: tags = "(("
출력: false
설명: 여는 괄호 두 개를 닫을 짝이 없고, `*`를 빈 칸으로 써도 해결할 수 없습니다.
```$$,
 $$- `1 <= tags.length <= 120`
- `tags`의 각 문자는 `'('`, `')'`, 또는 `'*'`입니다.$$),

-- 5. grocery-bag-triple
((SELECT id FROM problems WHERE slug = 'grocery-bag-triple'), 'ko',
 $$장바구니 세 묶음$$,
 $$장바구니 봉투 하나에는 세 가지 측정값 `[produce, dairy, frozen]`이 적혀 있습니다. 어떤 봉투든 모든 채널에서 `target`을 넘지 않을 때만 사용할 수 있고, 사용 가능한 봉투들의 부분집합을 골라 채널별 최댓값이 정확히 `target`과 같아지도록 만들고자 합니다.

봉투 배열 `bags`와 목표 배열 `target`을 받아 그러한 부분집합이 존재하면 `true`, 그렇지 않으면 `false`를 반환하는 `canBuildBales(bags, target)`를 작성하세요.

**예시 1:**
```
입력: bags = [[1,2,3],[4,2,1],[1,5,3],[2,1,4]], target = [4,5,4]
출력: true
설명: 두 번째 봉투가 채널 0의 목표 4에 도달하고, 세 번째 봉투가 채널 1의 5에, 네 번째 봉투가 채널 2의 4에 도달합니다. 모든 봉투가 세 채널 한도를 넘지 않습니다.
```

**예시 2:**
```
입력: bags = [[1,2,3],[4,5,6]], target = [3,4,5]
출력: false
설명: 두 번째 봉투는 모든 채널에서 target을 넘으므로 쓸 수 없습니다. 첫 번째 봉투만 쓰면 [1,2,3]이 되어 채널 2가 3에서 멈추고 5에 도달하지 못합니다.
```$$,
 $$- `1 <= bags.length <= 2 * 10^5`
- `bags[i].length == 3`
- `1 <= bags[i][j], target[j] <= 1000`$$),

-- 6. rebuild-tournament-line
((SELECT id FROM problems WHERE slug = 'rebuild-tournament-line'), 'ko',
 $$참가자 줄 세우기$$,
 $$비디오 게임 토너먼트의 대기 줄을 다시 세우려고 합니다. 각 참가자는 `[h, k]` 쌍으로 주어지며, `h`는 키, `k`는 자기 **앞에** 서 있는 사람 중 키가 `h` 이상인 사람의 수입니다. 현재 줄은 뒤죽박죽 섞여 있습니다.

참가자 목록 `players`가 주어질 때, 올바른 순서대로 정렬된 줄을 앞에서 뒤로 가는 `[h, k]` 쌍 리스트로 반환하세요. 유효한 정렬이 존재함이 보장됩니다.

**예시 1:**
```
입력: players = [[3,0],[6,0],[6,1],[4,1]]
출력: [[3,0],[6,0],[4,1],[6,1]]
설명: 키 큰 사람부터 배치하면 [6,0], [6,1]이 됩니다. 그다음 [4,1]을 인덱스 1에 끼워 넣으면 키 4 이상인 사람이 앞에 한 명 있게 됩니다. 마지막으로 [3,0]을 맨 앞 인덱스 0에 두면 앞에 더 큰 사람이 없습니다.
```

**예시 2:**
```
입력: players = [[2,0],[5,0],[2,1],[5,1]]
출력: [[2,0],[2,1],[5,0],[5,1]]
설명: 먼저 5 두 명을 [5,0], [5,1]로 배치합니다. [2,0]을 맨 앞에, [2,1]을 그 바로 뒤에 끼우면 각 2의 앞에 키 2 이상인 사람의 수가 정확히 맞습니다.
```$$,
 $$- `1 <= players.length <= 2 * 10^3`
- `0 <= h <= 8 * 10^5`
- `0 <= k < players.length`
- 유효한 줄 정렬이 존재함이 보장됩니다.$$),

-- 7. verify-pizza-rotation
((SELECT id FROM problems WHERE slug = 'verify-pizza-rotation'), 'ko',
 $$피자 트레이 정렬 확인하기$$,
 $$컨베이어 오븐의 슬롯마다 들어 있는 피자 개수가 배열 `trays`에 주어집니다. 이 수열을 비감소(non-decreasing) 순서로 만들고 싶습니다.

슬롯 **하나만** 임의의 정수로 바꾸어 `trays`를 비감소로 만들 수 있으면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
입력: trays = [3,1,4,5]
출력: true
설명: 첫 슬롯을 1로 낮추면 [1,1,4,5]가 되어 비감소가 됩니다.
```

**예시 2:**
```
입력: trays = [6,4,2,3]
출력: false
설명: 순서가 어긋난 슬롯이 두 군데여서 한 번만 수정해서는 고칠 수 없습니다.
```$$,
 $$- `1 <= trays.length <= 2 * 10^5`
- `-10^8 <= trays[i] <= 10^8`$$),

-- 8. can-attend-bookings
((SELECT id FROM problems WHERE slug = 'can-attend-bookings'), 'ko',
 $$테이블 예약 충돌 검사$$,
 $$카페에 창가 테이블이 하나 있습니다. 예약 목록 `bookings`의 각 항목은 개점 후 분 단위 구간 `[start, end]`로 표시됩니다.

예약끼리 서로 겹치지 않으면 `true`, 그렇지 않으면 `false`를 반환하세요. 한 예약이 끝나는 바로 그 시각에 다음 예약이 시작되는 경우는 겹침으로 보지 않습니다.

**예시 1:**
```
입력: bookings = [[18,20],[19,21],[22,23]]
출력: false
설명: [18,20]과 [19,21]이 모두 19분을 포함하므로 두 팀이 충돌합니다.
```

**예시 2:**
```
입력: bookings = [[18,20],[20,22],[22,23]]
출력: true
설명: 각 예약이 끝나는 시각에 다음 예약이 시작되어 테이블이 깔끔하게 회전합니다.
```

**예시 3:**
```
입력: bookings = [[45,90],[30,60]]
출력: false
```$$,
 $$- `0 <= bookings.length <= 8000`
- `bookings[i].length == 2`
- `0 <= start < end <= 2 * 10^5`$$),

-- 9. shortest-table-booking
((SELECT id FROM problems WHERE slug = 'shortest-table-booking'), 'ko',
 $$가장 짧은 예약 찾기$$,
 $$카페의 예약 목록 `bookings[i] = [start, end]`는 공유 타임라인 위의 닫힌 분 구간으로 각 테이블 예약을 표현합니다. 한 예약의 길이는 `end - start + 1`입니다.

조회 시점 배열 `probes`의 각 분에 대해, 그 분을 포함하는 예약 중 **가장 짧은** 예약의 길이를 반환하세요. 그 분을 포함하는 예약이 없으면 `-1`을 반환합니다. 결과는 `probes`와 길이가 같은 배열로 돌려줍니다.

**예시 1:**
```
입력: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
출력: [4,4,5,-1]
설명: 3분은 [2,5] (길이 4)와 [1,9] (길이 9)에 들어가므로 가장 짧은 길이는 4입니다. 11분은 어떤 예약에도 포함되지 않습니다.
```

**예시 2:**
```
입력: bookings = [[10,12],[8,20]], probes = [9,11,25]
출력: [13,3,-1]
설명: 9분은 [8,20] (길이 13)에만 속합니다. 11분은 [10,12] (길이 3)과 [8,20] (길이 13)에 모두 속하므로 가장 짧은 길이는 3입니다. 25분은 어떤 예약에도 포함되지 않습니다.
```$$,
 $$- `1 <= bookings.length <= 2 * 10^5`
- `1 <= probes.length <= 2 * 10^5`
- `1 <= start <= end <= 10^8`
- `1 <= probes[i] <= 10^8`$$),

-- 10. cover-aquarium-zones
((SELECT id FROM problems WHERE slug = 'cover-aquarium-zones'), 'ko',
 $$수조 구역 덮기$$,
 $$어종마다 1차원 구간 `[start, end]` (양 끝 포함) 안에서 먹이를 먹습니다. 위치 `x`에 알갱이 하나를 떨어뜨리면 그 위치를 덮는 모든 어종이 먹이를 받게 됩니다.

이런 구간들의 목록 `zones`가 주어질 때, 모든 어종이 적어도 한 번씩 먹이를 받도록 하는 데 필요한 알갱이의 최소 개수를 반환하세요.

**예시 1:**
```
입력: zones = [[5,11],[3,9],[8,14],[12,18],[20,25]]
출력: 3
설명: 9, 18, 25에 알갱이를 두면 됩니다. 위치 9는 [3,9], [5,11], [8,14]를 덮고, 18은 [12,18]을, 25는 [20,25]를 덮습니다.
```

**예시 2:**
```
입력: zones = [[1,5],[6,10],[11,15]]
출력: 3
설명: 어떤 두 구간도 겹치지 않으므로 각자 알갱이가 하나씩 필요합니다.
```$$,
 $$- `1 <= zones.length <= 2 * 10^5`
- `zones[i].length == 2`
- `-10^8 <= start <= end <= 10^8`$$);
