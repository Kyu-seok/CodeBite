-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 17 (problems #161-#170)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (scores, tierPrices, tickets,
-- target, controllerA, controllerB, merged, notes, s, p, balloons, floor,
-- amount, coupons, grid) stay verbatim. First mention of each variable in
-- Korean prose is paired with a Korean noun phrase describing its role.
-- Constraint identifiers are aligned with the canonical English parameter
-- names from V135 source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'count-longest-cookie-runs', 'best-skin-flip-day', 'ticket-plus-or-minus',
      'check-interleaved-inputs', 'count-hint-matches', 'validate-homework-id',
      'best-balloon-pop-order', 'biggest-clear-floor', 'count-coupon-ways',
      'min-wait-drive'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. count-longest-cookie-runs
((SELECT id FROM problems WHERE slug = 'count-longest-cookie-runs'), 'ko',
 $$가장 긴 굽기 순서 개수$$,
 $$오븐 트레이에서 꺼낸 순서대로 쿠키의 색깔 점수를 적은 배열 `scores`가 주어집니다. `scores`에서 만들 수 있는 가장 긴 **엄격하게 증가하는 부분수열**의 길이를 구한 뒤, 그 길이에 도달하는 서로 다른 부분수열이 몇 개인지 반환하세요. (순서는 고정이며, 원소를 건너뛸 수는 있지만 재배열할 수는 없습니다.)

**예시 1:**
```
입력: scores = [2,6,4,5,8]
출력: 1
설명: 가장 긴 엄격 증가 부분수열은 길이 4짜리 [2,4,5,8] 하나뿐입니다. 다른 길이-4 부분수열은 없습니다.
```

**예시 2:**
```
입력: scores = [3,3,3]
출력: 3
설명: 두 원소가 엄격하게 정렬되는 경우가 없으므로 최장 길이는 1입니다. 세 원소 각각이 서로 다른 길이-1 부분수열을 이룹니다.
```$$,
 $$- `1 <= scores.length <= 2 * 10^3`
- `-8 * 10^5 <= scores[i] <= 8 * 10^5`$$),

-- 2. best-skin-flip-day
((SELECT id FROM problems WHERE slug = 'best-skin-flip-day'), 'ko',
 $$최고의 스킨 되팔이 날$$,
 $$게임 거래소에서 희귀 스킨을 되팔이하려고 합니다. 스킨 가격은 매일 바뀌고, 하루에 할 수 있는 행동은 다음 셋 중 하나입니다.

- 한 개 사기 (보유 중인 게 없을 때만)
- 들고 있는 걸 팔기
- 아무것도 안 하기

단, 판매한 다음 날은 무조건 쉬어야 하며 그 다음 날부터 다시 살 수 있습니다.

`tierPrices[i]`가 `i`일째 가격을 뜻하는 배열 `tierPrices`가 주어질 때, 얻을 수 있는 최대 총 이익을 반환하세요.

**예시 1:**
```
입력: tierPrices = [3,8,5,1,6]
출력: 10
설명: 0일에 3에 사서 1일에 8에 팝니다(이익 5). 2일은 강제 휴식. 3일에 1에 사서 4일에 6에 팝니다(이익 5). 합계 10.
```

**예시 2:**
```
입력: tierPrices = [9,2,5]
출력: 3
설명: 9는 건너뛰고, 1일에 2에 사서 2일에 5에 팔면 이익 3.
```$$,
 $$- `1 <= tierPrices.length <= 2000`
- `0 <= tierPrices[i] <= 900`$$),

-- 3. ticket-plus-or-minus
((SELECT id FROM problems WHERE slug = 'ticket-plus-or-minus'), 'ko',
 $$티켓에 플러스·마이너스 붙이기$$,
 $$팀이 백로그에 쌓인 티켓들을 처리하고 있습니다. 각 티켓에는 포인트 값이 매겨져 있고, 매 티켓마다 그 포인트를 팀 점수에 **더하거나** **빼서** 반영합니다. 포인트 배열 `tickets`와 정수 `target`이 주어질 때, 순합이 정확히 `target`이 되는 플러스/마이너스 배정의 개수를 세어 반환하세요.

`partitionTankDoses`를 구현해 그 개수를 반환하세요.

**예시 1:**
```
입력: tickets = [2,2,2,2], target = 4
출력: 4
설명: 순합이 +4가 되려면 티켓 3개를 더하고 1개를 빼야 합니다. 빼는 티켓을 고르는 방법이 4가지입니다.
```

**예시 2:**
```
입력: tickets = [4,6,8], target = 10
출력: 1
설명: 순합 +10을 만드는 유일한 배정은 -4 + 6 + 8 = 10 입니다.
```$$,
 $$- `1 <= tickets.length <= 22`
- `0 <= tickets[i] <= 900`
- `-900 <= target <= 900`$$),

-- 4. check-interleaved-inputs
((SELECT id FROM problems WHERE slug = 'check-interleaved-inputs'), 'ko',
 $$입력 합쳐쓰기 검사$$,
 $$리듬 게임에서 두 컨트롤러가 각자 고정된 버튼 글자 순서를 누르고, 화면에는 모든 입력이 합쳐진 기록이 남습니다. 이 기록이 진짜 인터리브가 되려면 모든 입력이 정확히 한 번씩 나오고, 두 컨트롤러 각각의 원래 순서가 유지되어야 합니다.

문자열 `controllerA`, `controllerB`, `merged`가 주어질 때, `merged`가 `controllerA`와 `controllerB`의 유효한 인터리브이면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
입력: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
출력: true
설명: A에서 c, B에서 d와 o, A에서 a, B에서 g, A에서 t를 차례로 가져옵니다. 두 컨트롤러의 순서가 모두 보존됩니다.
```

**예시 2:**
```
입력: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
출력: false
설명: a 다음 x가 나온 뒤 B의 다음 글자는 y여야 하지만, 합쳐진 기록은 y보다 z가 먼저 나와 B의 순서를 어깁니다.
```$$,
 $$- `0 <= controllerA.length, controllerB.length <= 120`
- `0 <= merged.length <= 240`
- `controllerA`, `controllerB`, `merged`는 영어 소문자로 이루어져 있습니다.$$),

-- 5. count-hint-matches
((SELECT id FROM problems WHERE slug = 'count-hint-matches'), 'ko',
 $$노트 매칭 개수 세기$$,
 $$강의 노트 문자열 `notes`와 짧은 힌트 문자열 `target`이 주어집니다. `notes` 안에서 `target`이 부분수열로 등장하는 횟수를 세어 반환하세요. 부분수열은 `notes`에서 글자를 순서대로 골라 만들되 원하는 글자는 건너뛸 수 있고, 고른 글자가 같아 보여도 위치가 다르면 서로 다른 매칭으로 칩니다.

총 매칭 개수를 반환하는 `countFilterMatches`를 구현하세요. 답은 64비트 부호 있는 정수 범위 안에 들어갑니다.

**예시 1:**
```
입력: notes = "ggrrg", target = "grg"
출력: 4
설명: 매칭마다 g 하나, 그 뒤의 r 하나, 다시 그 뒤의 g 하나를 골라야 합니다. g 위치 (0, 1, 4)와 r 위치 (2, 3) 중에서 유효한 (i, j, k) 세 쌍은 (0,2,4), (0,3,4), (1,2,4), (1,3,4) 입니다.
```

**예시 2:**
```
입력: notes = "uvuvu", target = "uu"
출력: 3
설명: u의 위치는 0, 2, 4입니다. 두 자리를 순서대로 고르는 경우 (0,2), (0,4), (2,4) 모두 매칭이 됩니다.
```$$,
 $$- `1 <= notes.length <= 900`
- `1 <= target.length <= 900`
- `notes`와 `target`은 영어 소문자로 이루어져 있습니다.$$),

-- 6. validate-homework-id
((SELECT id FROM problems WHERE slug = 'validate-homework-id'), 'ko',
 $$과제 ID 검증$$,
 $$과제에서 작은 패턴 언어를 사용합니다. `.`은 임의의 글자 하나와 매치되고, `*`는 바로 앞 글자가 0번 이상 반복됨을 의미합니다. 패턴은 ID의 일부가 아니라 전체를 처음부터 끝까지 덮어야 합니다.

ID 문자열 `s`와 패턴 `p`가 주어질 때, `p`가 `s` 전체와 매치되면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
입력: s = "bbbc", p = "b*c"
출력: true
설명: `b*`가 앞쪽 b 세 개를 흡수하고, 이어 `c`가 마지막 c와 매치되어 ID 전체를 덮습니다.
```

**예시 2:**
```
입력: s = "xyzw", p = "x.y"
출력: false
설명: 패턴은 글자 세 개만 묘사하고 늘릴 `*`도 없으므로 네 글자짜리 ID를 다 덮을 수 없습니다.
```$$,
 $$- `1 <= s.length <= 24`
- `1 <= p.length <= 24`
- `s`는 영어 소문자로 이루어져 있습니다.
- `p`는 영어 소문자와 `.`, `*`로 이루어져 있습니다.
- `p`의 모든 `*` 앞에는 유효한 문자가 하나 있습니다(맨 앞에 `*`가 올 수 없고, `*`가 연달아 두 번 오지도 않습니다).$$),

-- 7. best-balloon-pop-order
((SELECT id FROM problems WHERE slug = 'best-balloon-pop-order'), 'ko',
 $$최고의 풍선 터뜨리기 순서$$,
 $$숫자가 적힌 풍선들이 한 줄로 놓여 있고, 그 값들이 `balloons`에 주어집니다. 점수를 최대로 얻도록 원하는 순서대로 풍선을 하나씩 터뜨리세요.

풍선 `i`를 터뜨리면 `balloons[i - 1] * balloons[i] * balloons[i + 1]` 만큼 점수를 얻습니다. 여기서 이웃은 터뜨리는 시점에 `i` 양옆에 남아 있는 풍선을 뜻하며, 이웃이 없는 경우(배열 바깥이거나 이미 터진 경우)에는 `1`로 취급합니다. 모든 풍선을 터뜨렸을 때 얻을 수 있는 최대 총점을 반환하세요.

**예시 1:**
```
입력: balloons = [2,4,1,6]
출력: 90
설명: 1, 4, 2, 6 순으로 터뜨리면 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90 입니다.
```

**예시 2:**
```
입력: balloons = [3,5]
출력: 20
설명: 먼저 3을 터뜨리면 1*3*5 = 15, 그다음 5를 터뜨리면 1*5*1 = 5. 합계 20.
```$$,
 $$- `1 <= balloons.length <= 300`
- `0 <= balloons[i] <= 100`$$),

-- 8. biggest-clear-floor
((SELECT id FROM problems WHERE slug = 'biggest-clear-floor'), 'ko',
 $$가장 큰 빈 교실 바닥$$,
 $$교실 바닥이 타일 격자로 표현됩니다. `"1"`은 비어 있는 카펫 칸, `"0"`은 책상이 놓여 있는 칸입니다.

격자 `floor`가 주어질 때, 전부 `"1"`로만 이뤄진 가장 큰 축 정렬 정사각형의 넓이를 반환하세요. 비어 있는 칸이 하나도 없다면 `0`을 반환합니다.

**예시 1:**
```
입력: floor = [["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]
출력: 9
설명: 우하단의 3x3 블록 전체가 비어 있어, 가장 큰 정사각형의 한 변 길이는 3이고 넓이는 9입니다.
```

**예시 2:**
```
입력: floor = [["0","0","0"],["0","1","1"],["0","1","1"]]
출력: 4
설명: 우하단의 2x2 블록이 모두 비어 있어 넓이는 4입니다.
```$$,
 $$- `m == floor.length`
- `n == floor[i].length`
- `1 <= m, n <= 300`
- `floor[i][j]`는 `'0'` 또는 `'1'`입니다.$$),

-- 9. count-coupon-ways
((SELECT id FROM problems WHERE slug = 'count-coupon-ways'), 'ko',
 $$쿠폰 조합 세기$$,
 $$카페에서 정해진 액면가의 스토어 크레딧 쿠폰을 받았고, 이번 결제에서 정확히 `amount`원을 맞춰 쓰고 싶습니다. 정수 `amount`와 쿠폰 액면가 배열 `coupons`가 주어질 때, 합이 `amount`가 되는 서로 다른 조합의 개수를 반환하세요. 각 쿠폰 액면가는 원하는 만큼 반복해서 쓸 수 있고, 순서는 고려하지 않습니다. 어떤 조합으로도 만들 수 없으면 `0`을 반환합니다.

**예시 1:**
```
입력: amount = 8, coupons = [1,3,4]
출력: 6
설명: 가능한 6가지 조합은 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, 4+4 입니다.
```

**예시 2:**
```
입력: amount = 4, coupons = [5]
출력: 0
설명: 5원짜리 쿠폰만으로는 4원을 만들 수 없습니다.
```$$,
 $$- `1 <= coupons.length <= 300`
- `1 <= coupons[i] <= 5000`
- `coupons`의 값은 모두 서로 다릅니다.
- `0 <= amount <= 5000`$$),

-- 10. min-wait-drive
((SELECT id FROM problems WHERE slug = 'min-wait-drive'), 'ko',
 $$최소 대기 경로$$,
 $$지도 앱이 격자 위 모든 교차로의 대기 시간(분)을 보여줍니다. 좌상단에서 우하단까지 운전하는데, 한 번에 한 블록 동쪽 또는 한 블록 남쪽으로만 이동할 수 있습니다.

격자 `grid`가 주어질 때, 시작과 끝을 포함해 지나는 모든 교차로의 대기 시간을 합한 값 중 가장 작은 총합을 반환하세요.

**예시 1:**
```
입력: grid = [[2,1,4],[5,3,2],[1,2,1]]
출력: 9
설명: 2 -> 1 -> 3 -> 2 -> 1 경로의 합이 9분으로 가장 작습니다.
```

**예시 2:**
```
입력: grid = [[3,1],[2,4],[1,5]]
출력: 11
설명: 3 -> 2 -> 1 -> 5 경로는 합이 11분이고, 다른 경로 3 -> 1 -> 4 -> 5는 13분이므로 더 큽니다.
```$$,
 $$- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`$$);
