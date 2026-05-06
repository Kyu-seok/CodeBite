-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 2 (problems #11-#20)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (menuPrice, budget, deltas,
-- lockers, readings, feed, code, k, shelf, needed, tape, val, query)
-- stay verbatim. First mention of each variable in Korean prose is paired
-- with a Korean noun phrase describing its type or role. Constraint
-- identifiers are aligned with the canonical English parameter names
-- from V135.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'two-menu-sum', 'zero-sum-trio', 'biggest-locker-poster', 'peak-temp-jump',
      'longest-genre-window', 'longest-combo-run', 'shortest-book-span', 'valid-brackets',
      'low-score-stack', 'find-locker-number'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. two-menu-sum
((SELECT id FROM problems WHERE slug = 'two-menu-sum'), 'ko',
 $$예산 맞춰 두 메뉴 고르기$$,
 $$비내림차순으로 정렬된 **1-인덱스** 메뉴 가격 배열 `menuPrice`와, 지갑에 정확히 들어 있는 정수 `budget`이 주어집니다. 가격의 합이 `budget`과 정확히 같아지는 서로 다른 두 메뉴를 골라 그 메뉴 번호를 `[item1, item2]` 형태로 반환하세요. 단, `1 <= item1 < item2 <= menuPrice.length`를 만족해야 합니다.

조건을 만족하는 짝은 정확히 하나뿐이며, 입력 외에는 상수 크기의 추가 공간만 사용해야 합니다.

**예시 1:**
```
입력: menuPrice = [12,30,45,58,70,85], budget = 100
출력: [2,5]
설명: 메뉴 2번의 가격은 30, 메뉴 5번의 가격은 70이고 30 + 70 = 100으로 예산과 정확히 일치합니다.
```

**예시 2:**
```
입력: menuPrice = [5,14,22,40], budget = 54
출력: [2,4]
설명: 메뉴 2번의 가격은 14, 메뉴 4번의 가격은 40이고 14 + 40 = 54입니다.
```$$,
 $$- `2 <= menuPrice.length <= 2 * 10^5`
- `-10^8 <= menuPrice[i] <= 10^8`
- `menuPrice`는 비내림차순으로 정렬되어 있습니다.
- `-2 * 10^8 <= budget <= 2 * 10^8`
- 입력은 유효한 짝이 정확히 하나만 존재하도록 만들어져 있습니다.$$),

-- 2. zero-sum-trio
((SELECT id FROM problems WHERE slug = 'zero-sum-trio'), 'ko',
 $$합이 0인 삼인방$$,
 $$협동 게임에서 각 플레이어의 점수 차이를 부호 있는 정수로 기록한 배열 `deltas`가 주어집니다(음수는 뒤처짐, 양수는 앞섬을 뜻합니다).

서로 다른 세 플레이어의 `deltas` 값을 더해 정확히 0이 되는 모든 고유한 삼인방을 `[deltas[i], deltas[j], deltas[k]]` 형태로 반환하세요. 같은 값 조합은 가능한 인덱스가 여러 개여도 결과에 한 번만 포함되며, 삼인방들의 반환 순서는 자유입니다.

**예시 1:**
```
입력: deltas = [-3,1,2,-2,0,-1,1]
출력: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
설명: 합이 정확히 0이 되는 서로 다른 삼인방이 네 개 존재합니다.
```

**예시 2:**
```
입력: deltas = [2,3,4]
출력: []
설명: 모든 값이 양수이므로 합이 0이 되는 삼인방을 만들 수 없습니다.
```

**예시 3:**
```
입력: deltas = [0,0,0,0]
출력: [[0,0,0]]
설명: 0이 네 개 있어 `[0,0,0]` 한 가지 조합만 가능합니다.
```$$,
 $$- `3 <= deltas.length <= 2 * 10^3`
- `-10^8 <= deltas[i] <= 10^8`$$),

-- 3. biggest-locker-poster
((SELECT id FROM problems WHERE slug = 'biggest-locker-poster'), 'ko',
 $$가장 큰 사물함 포스터$$,
 $$복도에 사물함이 한 줄로 늘어서 있고, 정수 배열 `lockers`의 `lockers[i]`는 `i`번 사물함의 높이입니다. 사물함 두 개를 골라 그 사이에 직사각형 포스터를 붙이려고 합니다. 포스터의 높이는 두 사물함 중 더 낮은 쪽에 맞춰지고, 너비는 두 사물함의 인덱스 차이만큼이 됩니다.

길이 `n`인 `lockers`가 주어졌을 때, 이런 식으로 만들 수 있는 포스터의 최대 넓이를 반환하세요.

**예시 1:**
```
입력: lockers = [2,6,4,1,5,3,6,2,8]
출력: 42
설명: 인덱스 1번 사물함(높이 6)과 인덱스 8번 사물함(높이 8) 사이는 너비 7, 높이 6의 포스터를 받칠 수 있어 넓이가 42입니다.
```

**예시 2:**
```
입력: lockers = [2,3]
출력: 2
설명: 두 사물함 사이의 너비는 1이고 높이는 더 낮은 쪽인 2이므로 넓이는 2입니다.
```$$,
 $$- `n == lockers.length`
- `2 <= n <= 2 * 10^5`
- `0 <= lockers[i] <= 8 * 10^4`$$),

-- 4. peak-temp-jump
((SELECT id FROM problems WHERE slug = 'peak-temp-jump'), 'ko',
 $$최대 온도 변동$$,
 $$아파트 온도계에서 한 시간 간격으로 측정한 값들이 정수 배열 `readings`에 들어 있습니다. `i < j`를 만족하는 인덱스 쌍 중에서 가장 큰 `readings[j] - readings[i]` 값을 반환하세요.

온도가 한 번도 오르지 않고 계속 내려가기만 했다면 `0`을 반환합니다.

**예시 1:**
```
입력: readings = [14,9,11,8,12,15,10]
출력: 7
설명: 인덱스 3에서 8까지 떨어졌다가 인덱스 5에서 15까지 올라가므로 변동 폭이 7입니다.
```

**예시 2:**
```
입력: readings = [20,18,15,11]
출력: 0
설명: 값이 계속 줄어들기만 하므로 양의 변동이 존재하지 않습니다.
```$$,
 $$- `1 <= readings.length <= 2 * 10^5`
- `0 <= readings[i] <= 8000`$$),

-- 5. longest-genre-window
((SELECT id FROM problems WHERE slug = 'longest-genre-window'), 'ko',
 $$가장 긴 장르 몰아보기$$,
 $$넷플릭스 시청 대기열을 나타내는 문자열 `feed`가 주어지고, 각 문자는 장르 태그 하나를 의미합니다. 모든 문자가 서로 다른 가장 긴 연속 부분 문자열의 길이를 반환하세요.

**예시 1:**
```
입력: feed = "finance"
출력: 4
설명: 부분 문자열 "ance"는 서로 다른 네 글자로 이루어져 있고, 이보다 긴 모두-다른 구간은 없습니다.
```

**예시 2:**
```
입력: feed = "zzzz"
출력: 1
설명: 모든 문자가 같은 장르라서 서로 다른 글자만 모은 구간은 길이 1짜리뿐입니다.
```

**예시 3:**
```
입력: feed = "xxxyz"
출력: 3
설명: 끝부분 "xyz"가 서로 다른 세 글자로 이루어진 가장 긴 구간입니다.
```$$,
 $$- `0 <= feed.length <= 8 * 10^4`
- `feed`는 영문자, 숫자, 기호, 공백으로 이루어져 있습니다.$$),

-- 6. longest-combo-run
((SELECT id FROM problems WHERE slug = 'longest-combo-run'), 'ko',
 $$최장 콤보 구간$$,
 $$리듬 게임이 당신이 누른 버튼을 대문자 문자열 `code`로 기록합니다. 정수 `k`만큼의 글자를 원하는 어떤 글자로든 덮어쓸 수 있습니다.

최대 `k`번의 덮어쓰기를 거친 뒤 같은 글자만으로 이어지도록 만들 수 있는 가장 긴 연속 부분 문자열의 길이를 반환하세요.

**예시 1:**
```
입력: code = "PQPQ", k = 2
출력: 4
설명: 두 개의 P를 모두 Q로 덮어쓰면 "QQQQ"가 되어 길이 4짜리 같은 글자 구간이 만들어집니다.
```

**예시 2:**
```
입력: code = "XXYXYYX", k = 1
출력: 4
설명: 인덱스 2의 Y를 X로 덮어쓰면 인덱스 0..3 구간이 "XXXX"가 되어 길이가 4입니다.
```$$,
 $$- `1 <= code.length <= 2 * 10^5`
- `code`는 대문자 영어 알파벳으로만 이루어져 있습니다.
- `0 <= k <= code.length`$$),

-- 7. shortest-book-span
((SELECT id FROM problems WHERE slug = 'shortest-book-span'), 'ko',
 $$가장 짧은 책장 구간$$,
 $$책장에 꽂힌 순서대로 권당 한 글자짜리 태그가 나열된 문자열 `shelf`가 있습니다. 그리고 챙겨야 하는 태그를 개수까지 반영한 요구 문자열 `needed`가 주어집니다. 예를 들어 `needed`에 `'O'`가 두 번 들어 있다면 `'O'` 태그 책이 최소 두 권 필요하다는 뜻입니다.

`needed`의 모든 글자를 요구된 개수만큼 포함하는 `shelf`의 가장 짧은 연속 부분 문자열을 반환하세요. 그런 구간이 없다면 `""`를 반환합니다. 길이가 같은 후보가 여러 개라면 가장 앞에 있는 것을 반환합니다.

**예시 1:**
```
입력: shelf = "FINDTHEBOOKSNOW", needed = "BOK"
출력: "BOOK"
설명: 구간 "BOOK"은 `'B'`, `'O'`, `'K'`를 모두 포함하며, 세 태그를 전부 덮는 더 짧은 구간은 없습니다.
```

**예시 2:**
```
입력: shelf = "XY", needed = "Y"
출력: "Y"
설명: 태그가 `'Y'`인 책 한 권이 이미 요구사항을 충족합니다.
```

**예시 3:**
```
입력: shelf = "Q", needed = "QQ"
출력: ""
설명: 요구사항은 `'Q'` 태그 책 두 권이지만 책장에는 한 권밖에 없습니다.
```$$,
 $$- `m == shelf.length`
- `n == needed.length`
- `1 <= m, n <= 2 * 10^5`
- `shelf`와 `needed`는 영어 대소문자로만 이루어져 있습니다.$$),

-- 8. valid-brackets
((SELECT id FROM problems WHERE slug = 'valid-brackets'), 'ko',
 $$괄호 중첩 검사하기$$,
 $$문자열 `tape`은 `(`, `)`, `[`, `]`, `{`, `}` 여섯 가지 괄호 문자만으로 이루어져 있습니다. 모든 여는 괄호가 같은 종류의 닫는 괄호로 닫히고, 바깥쪽 괄호가 안쪽 괄호보다 먼저 닫히지 않을 때 괄호가 올바르게 중첩되어 있다고 합니다. 올바르게 중첩되어 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
입력: tape = "{[()]}"
출력: true
설명: 모든 여는 괄호가 같은 종류의 닫는 괄호로, 올바른 중첩 순서대로 닫혀 있습니다.
```

**예시 2:**
```
입력: tape = "{[(])}"
출력: false
설명: `(`이 짝인 `)`보다 먼저 `]`로 닫혀 중첩 구조가 깨집니다.
```$$,
 $$- `1 <= tape.length <= 2 * 10^3`
- `tape`은 문자 `'('`, `')'`, `'['`, `']'`, `'{'`, `'}'`로만 이루어져 있습니다.$$),

-- 9. low-score-stack
((SELECT id FROM problems WHERE slug = 'low-score-stack'), 'ko',
 $$최저값 추적 스택$$,
 $$스피드런 시도 점수를 쌓아 두는 스택을 설계하세요. 이 스택은 현재 담겨 있는 점수 중 가장 낮은 값도 함께 알려줘야 하며, 모든 연산은 `O(1)`에 동작해야 합니다.

`LowTrackStack`을 구현하세요.

- `LowTrackStack()` — 빈 스택으로 시작합니다.
- `void push(int val)` — 시도 점수 `val`을 맨 위에 올립니다.
- `void pop()` — 맨 위 점수를 제거합니다.
- `int top()` — 맨 위 점수를 제거하지 않고 반환합니다.
- `int getMin()` — 현재 스택에 있는 점수 중 가장 작은 값을 반환합니다.

`pop`, `top`, `getMin`은 최소 한 번 `push`가 이루어진 뒤에만 호출됩니다.

**예시 1:**
```
입력:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
출력: [null,null,null,null,-2,null,6,6]
```
점수 12, 6, -2를 차례로 push하면 `getMin`은 `-2`를 반환합니다. `pop` 한 번 뒤 스택은 `[12, 6]`이 되고, `top`은 `6`, 직전 최솟값이 빠졌으므로 `getMin`도 `6`을 반환합니다.$$,
 $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, `getMin`은 적어도 한 번 `push`가 이루어진 후에만 호출됩니다.
- `push`, `pop`, `top`, `getMin`은 합쳐서 최대 `20000`번 호출됩니다.$$),

-- 10. find-locker-number
((SELECT id FROM problems WHERE slug = 'find-locker-number'), 'ko',
 $$사물함 위치 찾기$$,
 $$서로 다른 사물함 번호들이 오름차순으로 정렬되어 담긴 정수 배열 `shelf`와 찾고자 하는 정수 `query`가 주어집니다. `shelf`에서 `query`가 위치한 0-인덱스 자리를 반환하고, `query`가 들어 있지 않으면 `-1`을 반환하세요.

알고리즘은 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
입력: shelf = [102,145,201,247,318,402,510,633], query = 318
출력: 4
설명: 318번 사물함은 줄에서 4번 자리에 있습니다.
```

**예시 2:**
```
입력: shelf = [102,145,201,247,318,402,510,633], query = 200
출력: -1
설명: 200번 사물함은 리스트에 존재하지 않습니다.
```$$,
 $$- `1 <= shelf.length <= 2 * 10^5`
- `|shelf[i]| <= 10^8`
- `|query| <= 10^8`
- `shelf`의 모든 사물함 번호는 서로 다릅니다.
- `shelf`는 엄격히 오름차순으로 정렬되어 있습니다.$$);
