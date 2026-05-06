-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 6 (problems #51-#60)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (nums, height, shotOrder,
-- socks, scans, pattern, log, combo, k, baleTape, pairCount, readings)
-- stay verbatim. First mention of each variable in Korean prose is paired
-- with a Korean noun phrase describing its role. Constraint identifiers
-- are aligned with the canonical English parameter names from V135 / V149.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'sort-colors', 'next-speaker-order', 'missing-sock-number', 'trapping-rain-water',
      'move-voided-scans', 'find-name-anagram', 'peak-combo-window', 'eval-postfix-tape',
      'list-bracket-pairings', 'days-until-warmer'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. sort-colors
((SELECT id FROM problems WHERE slug = 'sort-colors'), 'ko',
 $$색깔 정렬$$,
 $$배열 `nums`의 원소는 `0`, `1`, `2` 세 가지뿐이며, 자연스러운 정렬 순서가 있습니다(관례상 빨강, 하양, 파랑에 해당합니다). 모든 `0`이 앞쪽에, 그다음 `1`들이, 마지막에 `2`들이 오도록 **제자리에서** 재배열하세요. 내장 정렬 함수는 사용할 수 없습니다.

상수 추가 공간만 쓰면서 한 번의 선형 탐색으로 처리하는 것이 목표입니다 — 고전적인 네덜란드 국기 분할 문제입니다.

**예시 1:**
```
입력: nums = [2,0,2,1,1,0]
출력: [0,0,1,1,2,2]
```

**예시 2:**
```
입력: nums = [2,0,1]
출력: [0,1,2]
```$$,
 $$- `1 <= nums.length <= 300`
- `nums[i]`는 `0`, `1`, `2` 중 하나입니다.$$),

-- 2. next-speaker-order
((SELECT id FROM problems WHERE slug = 'next-speaker-order'), 'ko',
 $$다음 발표 순서$$,
 $$아침마다 정해지는 발표 순서가 정수 ID 배열 `shotOrder`에 들어 있습니다. 매일 같은 ID들로 만들 수 있는 **사전순으로 바로 다음에 오는 순열**로 라인업이 넘어갑니다. 오늘 라인업이 이미 가장 큰 순열이라면 가장 작은 순열로 초기화됩니다.

`shotOrder`를 **제자리에서** 다음으로 큰 순열로 재배치하거나, 더 큰 순열이 없다면 가장 작은 순열로 바꾸는 `advanceShotOrder`를 구현하세요. 추가 메모리는 상수 크기만 사용해야 합니다.

**예시 1:**
```
입력: shotOrder = [2,3,4]
출력: [2,4,3]
설명: `[2,3,4]` 다음에 오는 순열은 `[2,4,3]`입니다.
```

**예시 2:**
```
입력: shotOrder = [5,4,3,2]
출력: [2,3,4,5]
설명: `[5,4,3,2]`는 가장 큰 순열이라, 라인업은 오름차순으로 초기화됩니다.
```$$,
 $$- `1 <= shotOrder.length <= 100`
- `0 <= shotOrder[i] <= 100`$$),

-- 3. missing-sock-number
((SELECT id FROM problems WHERE slug = 'missing-sock-number'), 'ko',
 $$사라진 빨래 번호$$,
 $$빨래 바구니에 들어 있는 양말들에 적힌 번호들이 정수 배열 `socks`에 담겨 있습니다. 양말 더미에 빠져 있는 가장 작은 양의 정수를 반환하세요. `0`과 음수는 정체불명의 보풀로 취급하고 무시합니다.

`lowestMissingTarget`을 구현하세요. 배열은 정렬되어 있지 않으며 같은 값이 반복될 수도 있습니다. O(n) 시간과 O(1) 보조 공간을 목표로 하세요.

**예시 1:**
```
입력: socks = [2,3,1,5]
출력: 4
설명: `1`, `2`, `3`은 모두 있지만 `4`가 없으니, 빠진 가장 작은 양의 정수는 `4`입니다.
```

**예시 2:**
```
입력: socks = [6,-2,8,10]
출력: 1
설명: `1`번 양말이 한 짝도 없으므로, 빠진 가장 작은 양의 정수는 `1`입니다.
```$$,
 $$- `1 <= socks.length <= 2 * 10^5`
- `|socks[i]| <= 10^8`$$),

-- 4. trapping-rain-water
((SELECT id FROM problems WHERE slug = 'trapping-rain-water'), 'ko',
 $$빗물 가두기$$,
 $$높이 지도가 `height` 배열로 주어집니다. `height[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 비가 내린 뒤 더 높은 막대들 사이의 움푹한 곳에 물이 고이는데, 갇힌 물의 총량을 구하세요.

`i`번째 위치는 `min(maxLeft, maxRight) - height[i]`만큼의 물을 가둡니다. 여기서 `maxLeft`, `maxRight`는 각각 `i`의 왼쪽과 오른쪽에서 가장 높은 막대의 높이입니다. 한쪽에 더 높은 막대가 없으면 그쪽으로 물이 새어나가서 가둘 수 없습니다.

**예시 1:**
```
입력: height = [0,1,0,2,1,0,1,3,2,1,2,1]
출력: 6
설명: 높이 2, 3, 2인 막대들 사이의 움푹한 곳에 물 6칸이 고입니다.
```

**예시 2:**
```
입력: height = [4,2,0,3,2,5]
출력: 9
```$$,
 $$- `n == height.length`
- `1 <= n <= 2 * 10^4`
- `0 <= height[i] <= 10^5`$$),

-- 5. move-voided-scans
((SELECT id FROM problems WHERE slug = 'move-voided-scans'), 'ko',
 $$취소 주문 뒤로 밀기$$,
 $$카페 포스기는 주문이 들어온 순서대로 각 주문의 가격을 정수 배열 `scans`에 기록하며, 취소된 주문은 `0`으로 남깁니다. 모든 `0`을 배열의 끝으로 밀고, 실제 가격들은 원래 들어왔던 상대 순서를 그대로 유지하세요.

`scans`를 **제자리에서** 변경해야 하며, 새 배열을 할당해서는 안 됩니다. 드라이버는 메서드가 반환된 뒤 배열을 출력합니다.

**예시 1:**
```
입력: scans = [4,0,0,2,9,0,7]
출력: [4,2,9,7,0,0,0]
설명: 실제 가격 네 개는 들어온 순서를 유지하고, 취소 주문 세 개는 끝으로 밀려납니다.
```

**예시 2:**
```
입력: scans = [0,0,5]
출력: [5,0,0]
```$$,
 $$- `1 <= scans.length <= 2 * 10^5`
- `|scans[i]| <= 10^8`$$),

-- 6. find-name-anagram
((SELECT id FROM problems WHERE slug = 'find-name-anagram'), 'ko',
 $$애너그램 부분 문자열$$,
 $$메모 문자열 `log`와 이름 문자열 `pattern`이 주어집니다. `pattern`의 어떤 순열이 `log`의 연속된 부분 문자열로 등장하면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
입력: pattern = "ab", log = "ccbazz"
출력: true
설명: `log` 안에 있는 부분 문자열 `"ba"`는 `pattern`을 재배열한 형태입니다.
```

**예시 2:**
```
입력: pattern = "rp", log = "mailpirzone"
출력: false
설명: `log`의 길이 2짜리 부분 문자열 중 `'r'` 한 글자와 `'p'` 한 글자로만 이루어진 것은 없습니다.
```$$,
 $$- `1 <= pattern.length, log.length <= 8000`
- `pattern`과 `log`는 영어 소문자로만 구성됩니다.$$),

-- 7. peak-combo-window
((SELECT id FROM problems WHERE slug = 'peak-combo-window'), 'ko',
 $$구간 최고 콤보$$,
 $$리듬 게임 리플레이를 살펴봅니다. 정수 배열 `combo`의 `combo[i]`는 비트 `i`에서의 콤보 수치이며, `k`는 하이라이트 영상에 쓰이는 슬라이딩 윈도의 폭입니다.

`peakFlowPerStretch`를 구현해, 윈도가 처음부터 끝까지 한 칸씩 미끄러질 때 `i`번째 출력이 `combo[i..i+k-1]`의 최댓값이 되도록 하세요.

**예시 1:**
```
입력: combo = [4,2,8,5,1,7,9,3], k = 4
출력: [8,8,8,9,9]
설명:
윈도                            최댓값
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**예시 2:**
```
입력: combo = [6,6,6], k = 2
출력: [6,6]
설명: 두 비트짜리 윈도는 모두 같은 최고 콤보를 보여줍니다.
```$$,
 $$- `1 <= combo.length <= 2 * 10^5`
- `-8000 <= combo[i] <= 8000`
- `1 <= k <= combo.length`$$),

-- 8. eval-postfix-tape
((SELECT id FROM problems WHERE slug = 'eval-postfix-tape'), 'ko',
 $$후위 표기식 계산$$,
 $$수학 선생님이 칠판에 적어 둔 후위 표기식을 계산합니다. 토큰 테이프 `baleTape`의 각 원소는 부호 있는 정수이거나 `+`, `-`, `*`, `/` 중 하나의 연산자입니다. 각 연산자는 스택 위쪽의 두 수를 꺼내 결합한 뒤 결과를 다시 스택에 넣습니다.

나눗셈은 0쪽으로 버림합니다. 테이프는 평가 후 스택에 정확히 숫자 하나만 남는 유효한 후위 표기식이며, 0으로 나누는 경우는 없음이 보장됩니다. 그 정수를 반환하세요.

**예시 1:**
```
입력: baleTape = ["5","3","-","2","*"]
출력: 4
설명: (5 - 3) * 2 = 4 입니다.
```

**예시 2:**
```
입력: baleTape = ["8","2","/","7","+","3","*"]
출력: 33
설명: ((8 / 2) + 7) * 3 = 33 입니다.
```$$,
 $$- `1 <= baleTape.length <= 2 * 10^3`
- `baleTape[i]`는 `{"+", "-", "*", "/"}` 중 하나의 연산자이거나 `|baleTape[i]| <= 250`인 부호 있는 정수입니다.$$),

-- 9. list-bracket-pairings
((SELECT id FROM problems WHERE slug = 'list-bracket-pairings'), 'ko',
 $$괄호 짝 만들기$$,
 $$정수 `pairCount`가 주어질 때, `pairCount`개의 괄호 쌍으로 만들 수 있는 모든 올바른 형식의 문자열을 반환하세요. 모든 `(`가 나중에 대응되는 `)`로 닫히고, `(` 이전에 그에 대응되는 `)`가 등장하지 않을 때 그 문자열을 올바르다고 합니다.

순서는 어떻게 반환해도 됩니다 — 채점기는 비교 전에 정렬합니다.

**예시 1:**
```
입력: pairCount = 2
출력: ["(())","()()"]
설명: 두 쌍의 괄호로 만들 수 있는 두 가지 올바른 배치입니다.
```

**예시 2:**
```
입력: pairCount = 4
출력: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$$,
 $$- `1 <= pairCount <= 9`$$),

-- 10. days-until-warmer
((SELECT id FROM problems WHERE slug = 'days-until-warmer'), 'ko',
 $$기온이 오를 때까지 며칠?$$,
 $$날씨 위젯이 일일 최고기온을 배열 `readings`에 날짜별 인덱스로 기록합니다. 각 날짜에 대해, **엄격히 더 따뜻한** 기온이 나타날 때까지 며칠을 기다려야 하는지 구하세요.

같은 길이의 배열 `wait`를 반환하며, `wait[i]`는 `i`일 이후 엄격히 더 따뜻한 기온이 나올 때까지의 날수입니다. 이후에 더 따뜻한 날이 없다면 `wait[i]`를 `0`으로 둡니다.

**예시 1:**
```
입력: readings = [55,58,52,50,54,60]
출력: [1,4,2,1,1,0]
설명: 0일차 다음으로 더 따뜻한 날은 1일차(58)입니다. 1일차 다음으로 더 따뜻한 날은 5일차(60)이고, 5일차보다 더 따뜻한 날은 없습니다.
```

**예시 2:**
```
입력: readings = [45,45,45,50]
출력: [3,2,1,0]
설명: 앞의 세 날은 모두 다음으로 엄격히 더 따뜻한 기온인 3일차(50)를 기다려야 합니다.
```$$,
 $$- `1 <= readings.length <= 2 * 10^5`
- `30 <= readings[i] <= 110`$$);
