-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 11 (problems #101-#110)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (votes, books, codes,
-- readings, queue, trays, demand, crates, capacity, drifts, target,
-- treats, k, n) stay verbatim. First mention of each variable in Korean
-- prose is paired with a Korean noun phrase describing its role.
-- Constraint identifiers are aligned with the canonical English parameter
-- names from the V135 source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'majority-boss-vote', 'dedupe-textbook-shelf', 'repeat-attendance-codes',
      'battery-window-tally', 'unique-genre-window', 'four-tray-sum',
      'pair-lunchbox-snacks', 'sort-latte-squared', 'shortest-cookie-span',
      'longest-unique-treats'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. majority-boss-vote
((SELECT id FROM problems WHERE slug = 'majority-boss-vote'), 'ko',
 $$대세 픽 고르기$$,
 $$투표 결과 배열 `votes`에는 `n`개의 항목이 있고, 그중 한 선택지가 전체의 절반을 엄격히 초과하는 표를 받았습니다. 즉, `n / 2`번보다 많이 등장하는 값을 찾아 반환하세요.

과반을 차지하는 선택지는 항상 존재한다고 가정합니다.

**예시 1:**
```
입력: votes = [4,7,4]
출력: 4
```

**예시 2:**
```
입력: votes = [5,5,6,6,6,5,6]
출력: 6
설명: 6은 7표 중 4번 등장하며, 이는 절반보다 많습니다.
```

**예시 3:**
```
입력: votes = [9]
출력: 9
```$$,
 $$- `1 <= votes.length <= 2 * 10^5`
- `-10^8 <= votes[i] <= 10^8`
- 과반을 차지하는 선택지가 항상 존재합니다.$$),

-- 2. dedupe-textbook-shelf
((SELECT id FROM problems WHERE slug = 'dedupe-textbook-shelf'), 'ko',
 $$책꽂이 중복 정리$$,
 $$정렬된 정수 배열 `books`는 교실 책꽂이에 꽂힌 교과서를 나타내며, 같은 값(같은 책)은 서로 붙어 있습니다. 고유한 값들을 원래 순서대로 앞쪽으로 옮기고, 고유한 값의 개수 `k`를 반환하세요. 인덱스 `k` 이후의 위치는 검사하지 않습니다.

**예시 1:**
```
입력: books = [2,2,5]
출력: 2, books = [2,5,_]
설명: k = 2를 반환합니다. 앞쪽은 2, 5 순서로 채워집니다.
```

**예시 2:**
```
입력: books = [1,1,2,2,3,4,4,6,6,6]
출력: 5, books = [1,2,3,4,6,_,_,_,_,_]
설명: 다섯 개의 서로 다른 값이 원래 순서대로 앞쪽에 자리잡습니다.
```

**예시 3:**
```
입력: books = [8]
출력: 1, books = [8]
설명: 한 권만 있는 책꽂이는 이미 정리된 상태입니다.
```$$,
 $$- `1 <= books.length <= 2 * 10^5`
- `-100 <= books[i] <= 100`
- `books`는 비내림차순으로 정렬되어 있습니다.$$),

-- 3. repeat-attendance-codes
((SELECT id FROM problems WHERE slug = 'repeat-attendance-codes'), 'ko',
 $$두 번 찍힌 출석 코드$$,
 $$교실 출석부에는 `1..n`으로 번호가 매겨진 `n`명의 학생이 있습니다. 학생 카드 스캔 기록을 담은 길이 `n`의 정수 배열 `codes`가 주어집니다. 일부 학생은 두 번 스캔했고, 나머지는 정확히 한 번씩만 스캔했습니다.

정확히 두 번 스캔된 모든 id를 어떤 순서로든 반환하세요. 출력 리스트 외에는 상수 크기의 추가 메모리만 사용하면서 선형 시간에 처리하는 것을 목표로 합니다.

**예시 1:**
```
입력: codes = [5,2,6,3,2,1,4,6]
출력: [2,6]
설명: 코드 2는 인덱스 1과 4에 등장하고, 코드 6은 인덱스 2와 7에 등장합니다.
```

**예시 2:**
```
입력: codes = [3,3,1,2]
출력: [3]
```$$,
 $$- `n == codes.length`
- `1 <= n <= 2 * 10^5`
- `1 <= codes[i] <= n`
- 각 번호는 한 번 또는 두 번만 등장합니다.$$),

-- 4. battery-window-tally
((SELECT id FROM problems WHERE slug = 'battery-window-tally'), 'ko',
 $$배터리 변동 구간 세기$$,
 $$시간대별 배터리 변동 기록 `readings`가 주어집니다. 양수는 충전, 음수는 방전, 0은 변화 없음을 뜻합니다. 합이 정확히 `k`가 되는 연속 구간이 몇 개인지 세주세요.

`readings`와 정수 `k`가 주어졌을 때, 값의 합이 `k`인 연속 부분배열의 개수를 반환하는 `countWindowTallies`를 구현하세요. 값이 음수일 수 있어 단순한 슬라이딩 윈도우로는 풀 수 없습니다.

**예시 1:**
```
입력: readings = [2,2,2], k = 4
출력: 2
설명: readings[0..1]과 readings[1..2] 두 구간이 각각 합이 4입니다.
```

**예시 2:**
```
입력: readings = [3,1,2,4], k = 6
출력: 2
설명: [3,1,2]와 [2,4] 두 구간이 모두 합이 6입니다.
```

**예시 3:**
```
입력: readings = [4,-4,0], k = 0
출력: 3
설명: [4,-4], [4,-4,0], [0]이 각각 합이 0입니다.
```$$,
 $$- `1 <= readings.length <= 2 * 10^5`
- `-1000 <= readings[i] <= 1000`
- `-10^7 <= k <= 10^7`$$),

-- 5. unique-genre-window
((SELECT id FROM problems WHERE slug = 'unique-genre-window'), 'ko',
 $$장르 제한 몰아보기 구간$$,
 $$재생 큐 문자열 `queue`의 각 글자는 장르 태그입니다. `queue`에서 서로 다른 글자가 최대 `k`개 들어 있는 가장 긴 연속 부분 문자열의 길이를 반환하세요. `k`가 0이면 0을 반환합니다.

**예시 1:**
```
입력: queue = "yyxzxxz", k = 2
출력: 5
설명: "xzxxz"는 x와 z만 사용하며 길이는 5입니다.
```

**예시 2:**
```
입력: queue = "rrrrrr", k = 1
출력: 6
설명: 모든 글자가 같은 장르라서, 문자열 전체가 하나의 장르 안에 들어갑니다.
```$$,
 $$- `1 <= queue.length <= 8 * 10^4`
- `0 <= k <= 50`
- `queue`는 영어 소문자로만 이루어져 있습니다.$$),

-- 6. four-tray-sum
((SELECT id FROM problems WHERE slug = 'four-tray-sum'), 'ko',
 $$네 트레이 합 맞추기$$,
 $$베이크 세일이 끝난 뒤, 각 트레이는 부호가 있는 수량을 가집니다(양수는 잉여, 음수는 부족). 트레이 수량 배열 `trays`와 목표 수요량 `demand`가 주어집니다. 수량 합이 `demand`가 되는 네 트레이의 모든 묶음을 찾으세요.

서로 다른 네 인덱스의 값들이 합쳐 `demand`가 되는 모든 **고유한 4원소 조합** `[trays[a], trays[b], trays[c], trays[d]]`를 반환하세요. 중복된 조합은 결과에 한 번만 포함되어야 하며 순서는 자유입니다.

**예시 1:**
```
입력: trays = [1,-1,2,-2,3,-3], demand = 0
출력: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
설명: 합이 0이 되는 서로 다른 네 트레이 묶음이 세 가지 있습니다.
```

**예시 2:**
```
입력: trays = [3,3,3,3,3], demand = 12
출력: [[3,3,3,3]]
설명: 모든 트레이가 잉여 3이라, 그중 어떤 네 개를 골라도 합은 12입니다.
```$$,
 $$- `1 <= trays.length <= 2 * 10^3`
- `|trays[i]| <= 10^8`
- `|demand| <= 10^8`$$),

-- 7. pair-lunchbox-snacks
((SELECT id FROM problems WHERE slug = 'pair-lunchbox-snacks'), 'ko',
 $$도시락 상자 짝짓기$$,
 $$간식을 도시락에 담는 중입니다. 도시락 한 개에는 **간식이 최대 두 개**까지만 들어가고, 총 무게는 `capacity` 그램을 넘을 수 없습니다. 모든 간식은 반드시 어딘가에 담아야 합니다.

간식 무게 배열 `crates`(여기서 `crates[i]`는 `i`번째 간식의 무게)가 주어질 때, 필요한 **최소 도시락 개수**를 반환하세요.

**예시 1:**
```
입력: crates = [2,4], capacity = 6
출력: 1
설명: 두 간식이 합쳐 6 그램이라 도시락 하나에 같이 들어갑니다.
```

**예시 2:**
```
입력: crates = [4,3,1,2], capacity = 4
출력: 3
설명: 무게 3과 1을 한 도시락에 같이 담고, 2와 4는 각각 따로 담습니다 — 도시락은 모두 세 개입니다.
```$$,
 $$- `1 <= crates.length <= 2 * 10^5`
- `1 <= crates[i] <= capacity <= 2 * 10^3`$$),

-- 8. sort-latte-squared
((SELECT id FROM problems WHERE slug = 'sort-latte-squared'), 'ko',
 $$라떼 온도 편차 정렬$$,
 $$비내림차순으로 정렬된 배열 `drifts`에는 각 라떼의 목표 온도 대비 편차가 들어 있습니다(차가우면 음수, 뜨거우면 양수).

각 편차를 제곱한 값을 비내림차순으로 반환하세요. 일반 정렬 알고리즘을 쓰지 말고 O(n)에 처리하는 것을 목표로 합니다.

**예시 1:**
```
입력: drifts = [-5,-2,0,4,9]
출력: [0,4,16,25,81]
```

**예시 2:**
```
입력: drifts = [-6,-4,1,3,8]
출력: [1,9,16,36,64]
```

**예시 3:**
```
입력: drifts = [2,3,5,7]
출력: [4,9,25,49]
설명: 모든 값이 음이 아니라서, 제곱해도 순서가 그대로 유지됩니다.
```$$,
 $$- `1 <= drifts.length <= 2 * 10^5`
- `-10^4 <= drifts[i] <= 10^4`
- `drifts`는 비내림차순으로 정렬되어 있습니다.$$),

-- 9. shortest-cookie-span
((SELECT id FROM problems WHERE slug = 'shortest-cookie-span'), 'ko',
 $$가장 짧은 쿠키 구간$$,
 $$쿠키 트레이 배열 `trays`는 왼쪽부터 차례로 각 칸에 들어 있는 쿠키 개수입니다. 한 줄로 이어진 칸들에서 합이 `target` 이상인 쿠키를 모아야 합니다.

`shortestBakeSpan`을 구현하여 합이 `target` 이상인 `trays`의 가장 짧은 연속 구간 길이를 반환하세요. `target`을 넘기는 구간이 없으면 `0`을 반환합니다.

**예시 1:**
```
입력: trays = [3,1,4,1,5,9,2,6], target = 15
출력: 3
설명: 구간 [1,5,9]의 합이 15이며, 더 짧은 구간으로는 15에 도달할 수 없습니다.
```

**예시 2:**
```
입력: trays = [2,2,2], target = 10
출력: 0
설명: 트레이 전체를 합쳐도 6이라, 주문량에 한참 못 미칩니다.
```

**예시 3:**
```
입력: trays = [8,3,2], target = 8
출력: 1
설명: 첫 칸 하나만으로 이미 목표를 채웁니다.
```$$,
 $$- `1 <= trays.length <= 2 * 10^5`
- `1 <= trays[i] <= 8000`
- `1 <= target <= 10^8`$$),

-- 10. longest-unique-treats
((SELECT id FROM problems WHERE slug = 'longest-unique-treats'), 'ko',
 $$가장 긴 안 겹치는 간식 구간$$,
 $$뷔페 라인의 `i`번째 조각의 맛 코드를 담은 배열 `treats`가 주어집니다. **서로 다른 맛이 최대 두 가지**만 들어 있는 가장 긴 연속 구간의 길이를 반환하세요.

**예시 1:**
```
입력: treats = [4,4,7,4,7,2,7,2,2]
출력: 5
설명: 끝부분 [7,2,7,2,2]는 맛 7과 2만 사용하며 길이는 5입니다. 앞부분 [4,4,7,4,7]도 맛 4와 7만 써서 같은 길이 5를 가집니다.
```

**예시 2:**
```
입력: treats = [9,9,9]
출력: 3
설명: 모든 조각이 같은 맛이라, 라인 전체가 그대로 한 구간입니다.
```

**예시 3:**
```
입력: treats = [1,5,1,5,1,5]
출력: 6
설명: 라인 전체가 두 가지 맛만 번갈아 등장해서, 가장 긴 구간이 전체를 덮습니다.
```$$,
 $$- `1 <= treats.length <= 2 * 10^5`
- `0 <= treats[i] < treats.length`$$);
