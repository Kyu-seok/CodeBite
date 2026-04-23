-- V136: Rewrite every Korean problem description to sound natural and
-- human-like, per the user's style guide. Identifiers, fenced example
-- blocks (Input/Output/Explanation), numeric values, and string literals
-- are preserved verbatim from the clarified English source. Example headers
-- may be rendered as **예시 N:** instead of **Example N:**.

-- add-score-lists
UPDATE problem_translations SET
    description = $KO$두 플레이어의 점수를 연결 리스트로 저장하는데, **일의 자리가 헤드에 오고** 뒤로 갈수록 자릿수가 커집니다. 두 점수를 더한 값을 같은 방식(자릿수 뒤집힌 배치)의 새 연결 리스트로 반환하세요.

값이 `0`인 한 노드짜리 리스트를 제외하면, 두 입력 모두 선행 0은 없습니다.

**예시 1:**
```
Input: score1 = [3,1,7], score2 = [4,8]
Output: [7,9,7]
Explanation: The inputs spell out 713 and 84. Their sum, 797, is written back ones-digit first.
```

**예시 2:**
```
Input: score1 = [9], score2 = [8]
Output: [7,1]
Explanation: 9 + 8 = 17, so the head node stores 7 and a carry node is appended for the tens digit.
```

**예시 3:**
```
Input: score1 = [1,8,6], score2 = [4,5]
Output: [5,3,7]
Explanation: 681 + 54 = 735.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$add-score-lists$S$);

-- add-without-plus
UPDATE problem_translations SET
    description = $KO$오래된 휴대용 게임기는 두 개의 킬 카운터 레지스터에 대해 비트 연산(AND, OR, XOR, NOT, 시프트)만 지원합니다. `+`나 `-`를 쓰지 않고 두 값을 더해야 합니다.

두 정수 `firstCount`와 `secondCount`가 주어졌을 때, 비트 연산만으로 합을 구하는 `combineCounters`를 구현하세요. XOR는 올림을 무시한 합을, AND 후 왼쪽으로 한 칸 시프트한 값은 올림을 나타내므로, 올림이 0이 될 때까지 반복하면 됩니다.

**예시 1:**
```
Input: firstCount = 12, secondCount = 9
Output: 21
```

**예시 2:**
```
Input: firstCount = -15, secondCount = 4
Output: -11
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$add-without-plus$S$);

-- balance-print-queue
UPDATE problem_translations SET
    description = $KO$인쇄 작업 큐가 문자열로 주어집니다. `(`는 배치 시작, `)`는 배치 종료를 뜻하고, `*`는 `(`, `)`, 또는 빈 칸 중 무엇으로든 쓸 수 있는 유연한 슬롯입니다.

큐 문자열 `tags`가 주어졌을 때, 유연한 슬롯들을 적절히 배정해서 모든 여는 괄호가 뒤쪽의 닫는 괄호와 짝을 이룰 수 있으면 `true`를 반환하세요.

**예시 1:**
```
Input: tags = "((*)"
Output: true
Explanation: Treating the flexible slot as ')' yields "(())", which is balanced.
```

**예시 2:**
```
Input: tags = "())"
Output: false
Explanation: A closing tag has no opener to match, and there's no flexible slot to fix it.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$balance-print-queue$S$);

-- balanced-hamster-tree
UPDATE problem_translations SET
    description = $KO$펫샵 햄스터 가계도가 이진 트리로 저장되어 있습니다. 이 트리가 균형 잡혀 있는지 확인하세요.

`root`가 주어졌을 때, 모든 노드에서 왼쪽 서브트리와 오른쪽 서브트리의 높이 차가 1 이하이면 `true`를 반환하세요. 빈 트리는 균형 잡힌 것으로 간주합니다.

**예시 1:**
```
Input: root = [5,2,8,1,null,null,11]
Output: true
Explanation: Every node's left and right subtree heights differ by at most 1.
```

**예시 2:**
```
Input: root = [1,2,null,3,null,4]
Output: false
Explanation: The tree leans all the way left into 1->2->3->4; the root's left subtree has height 3 while its right has height 0.
```

**예시 3:**
```
Input: root = []
Output: true
Explanation: An empty family is balanced by default.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$balanced-hamster-tree$S$);

-- barista-throughput-share
UPDATE problem_translations SET
    description = $KO$카페 바리스타들이 한 줄로 서서 일하고 있고, `rates[i]`는 바리스타 `i`가 한 사이클에 만드는 음료 수입니다. 각 바리스타의 **지분**은 자기 자신을 제외한 나머지 모든 바리스타 속도의 곱으로 정의합니다.

`rates`가 주어졌을 때, 같은 길이의 배열 `shares`를 반환하세요. `shares[i]`는 모든 `j != i`에 대한 `rates[j]`의 곱입니다. `rates`의 어떤 접두 곱이나 접미 곱도 부호 있는 32비트 정수 범위 안에 들어옵니다. 나눗셈을 쓰지 말고 선형 시간에 풀어야 합니다.

**예시 1:**
```
Input: rates = [2,3,5,4]
Output: [60,40,24,30]
Explanation: For barista 0: 3*5*4 = 60. For barista 1: 2*5*4 = 40. And so on.
```

**예시 2:**
```
Input: rates = [-2,1,0,4,-1]
Output: [0,0,8,0,0]
Explanation: Every share except index 2 multiplies through the zero at barista 2. The share for barista 2 is (-2)*1*4*(-1) = 8.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$barista-throughput-share$S$);

-- battery-drain-power
UPDATE problem_translations SET
    description = $KO$휴대폰 배터리가 매 시간마다 `base` 배율로 줄어듭니다. `step` 시간 후에 얼마나 남는지 구하려면 `base`의 `step` 제곱을 계산하면 됩니다.

`step`이 음수면 `1 / base^|step|`을 의미합니다(예: `2.0^-3 = 0.125`). 결과는 소수점 다섯째 자리까지 반올림해서 반환하세요. `|step|`이 매우 커질 수 있으므로 단순 반복문으로는 시간 초과가 납니다.

**예시 1:**
```
Input: base = 3.00000, step = 4
Output: 81.00000
```

**예시 2:**
```
Input: base = 2.00000, step = -3
Output: 0.12500
Explanation: 2.0^-3 = 1 / (2.0^3) = 1/8 = 0.125.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$battery-drain-power$S$);

-- battery-window-tally
UPDATE problem_translations SET
    description = $KO$배열 `readings`에는 시간대별 배터리 변동이 기록되어 있습니다. 양수는 충전, 음수는 방전, 0은 변화 없음을 뜻합니다. 합이 정확히 `k`가 되는 연속 구간의 개수를 세세요.

`readings`와 정수 `k`가 주어졌을 때, 값의 합이 `k`인 연속 부분 배열의 개수를 반환하는 `countWindowTallies`를 구현하세요. 값이 음수일 수 있기 때문에 단순한 슬라이딩 윈도우로는 풀 수 없습니다.

**예시 1:**
```
Input: readings = [2,2,2], k = 4
Output: 2
Explanation: The windows readings[0..1] and readings[1..2] each sum to 4.
```

**예시 2:**
```
Input: readings = [3,1,2,4], k = 6
Output: 2
Explanation: The windows [3,1,2] and [2,4] both sum to 6.
```

**예시 3:**
```
Input: readings = [4,-4,0], k = 0
Output: 3
Explanation: [4,-4], [4,-4,0], and [0] each sum to 0.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$battery-window-tally$S$);

-- best-balloon-pop-order
UPDATE problem_translations SET
    description = $KO$숫자가 적힌 풍선들이 한 줄로 놓여 있고, 그 값들이 `balloons`에 주어집니다. 점수를 최대로 얻도록 원하는 순서대로 풍선을 하나씩 터뜨리세요.

풍선 `i`를 터뜨리면 `balloons[i - 1] * balloons[i] * balloons[i + 1]` 만큼 점수를 얻습니다. 여기서 이웃은 터뜨리는 시점에 `i` 양옆에 남아 있는 풍선을 뜻하며, 이웃이 없는 경우(배열 바깥이거나 이미 터진 경우)에는 `1`로 취급합니다. 모든 풍선을 터뜨렸을 때 얻을 수 있는 최대 총점을 반환하세요.

**예시 1:**
```
Input: balloons = [2,4,1,6]
Output: 90
Explanation: One good order pops 1, then 4, then 2, then 6: 4*1*6 + 2*4*6 + 1*2*6 + 1*6*1 = 24 + 48 + 12 + 6 = 90.
```

**예시 2:**
```
Input: balloons = [3,5]
Output: 20
Explanation: Pop 3 first (1*3*5 = 15), then 5 (1*5*1 = 5). Total = 20.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$best-balloon-pop-order$S$);

-- best-boba-streak
UPDATE problem_translations SET
    description = $KO$배열 `traffic`은 버블티 가게의 시간대별 방문 인원을 기록한 값입니다. 양수는 들어온 손님, 음수는 나간 손님, 0은 문을 닫았음을 의미합니다. 비어 있지 않은 연속 구간 중 **곱이 가장 큰** 값을 반환하세요.

어떤 부분 배열의 곱이든 부호 있는 32비트 정수 범위 안에 들어옵니다.

**예시 1:**
```
Input: traffic = [3,-1,4,-2,5]
Output: 120
Explanation: The whole slice [3,-1,4,-2,5] multiplies to 120, the best you can get.
```

**예시 2:**
```
Input: traffic = [-3,0,2,-4]
Output: 2
Explanation: Any slice crossing the zero collapses to 0, so the best non-crossing pick is [2].
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$best-boba-streak$S$);

-- best-skill-tree-path
UPDATE problem_translations SET
    description = $KO$협동 파티의 스킬 트리가 이진 트리로 주어지고, 각 노드에는 양수 또는 음수의 점수가 적혀 있습니다. 찍을 만한 최고의 연속된 가지를 찾아보세요.

**가지**는 간선으로 연결된 노드들의 수열로, 같은 노드를 반복하지 않으면 됩니다. 루트를 반드시 포함할 필요는 없습니다. `root`가 주어졌을 때, 비어 있지 않은 가지 중 점수 합이 최대인 값을 반환하세요.

**예시 1:**
```
Input: root = [4,5,6]
Output: 15
Explanation: The best branch is 5 -> 4 -> 6, totaling 5 + 4 + 6 = 15.
```

**예시 2:**
```
Input: root = [-8,11,25,null,null,13,9]
Output: 47
Explanation: The best branch is 13 -> 25 -> 9, totaling 13 + 25 + 9 = 47. Including the root drags things down because of the -8.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$best-skill-tree-path$S$);

-- best-skin-flip-day
UPDATE problem_translations SET
    description = $KO$게임 거래소에서 희귀 스킨을 되팔이하려고 합니다. 스킨 가격은 매일 바뀌고, 하루에 할 수 있는 행동은 다음 셋 중 하나입니다.

- 한 개 사기 (보유 중인 게 없을 때만)
- 들고 있는 걸 팔기
- 아무것도 안 하기

단, 판매한 다음 날은 무조건 쉬어야 하며 그 다음 날부터 다시 살 수 있습니다.

`tierPrices[i]`가 `i`일째 가격을 뜻하는 배열 `tierPrices`가 주어질 때, 얻을 수 있는 최대 총 이익을 반환하세요.

**예시 1:**
```
Input: tierPrices = [3,8,5,1,6]
Output: 10
Explanation: Buy day 0 at 3, sell day 1 at 8 (profit 5). Day 2 is the forced cooldown. Buy day 3 at 1, sell day 4 at 6 (profit 5). Total 10.
```

**예시 2:**
```
Input: tierPrices = [9,2,5]
Output: 3
Explanation: Skip the 9, buy day 1 at 2, sell day 2 at 5 for a profit of 3.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$best-skin-flip-day$S$);

-- biggest-banner-span
UPDATE problem_translations SET
    description = $KO$사물함이 한 줄로 늘어서 있고, 그 위에 직사각형 배너 하나를 연속된 구간에 걸치려고 합니다. 배열 `lockers`는 각 사물함의 높이이고, 배너는 평평하게 얹혀야 하므로 해당 구간에서 가장 낮은 사물함의 높이까지만 올릴 수 있습니다.

배너가 덮을 수 있는 최대 넓이(높이 × 덮는 사물함 개수)를 반환하세요.

**예시 1:**
```
Input: lockers = [3,1,4,5,2,3]
Output: 8
Explanation: The banner covering lockers 2 and 3 uses height 4 and width 2 for area 8.
```

**예시 2:**
```
Input: lockers = [4,2,6,3,7,5,3]
Output: 15
Explanation: The banner covering indices 2 through 6 uses height 3 and width 5 for area 15.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$biggest-banner-span$S$);

-- biggest-clear-floor
UPDATE problem_translations SET
    description = $KO$교실 바닥이 타일 격자로 표현됩니다. `"1"`은 비어 있는 카펫 칸, `"0"`은 책상이 놓여 있는 칸입니다.

격자 `floor`가 주어질 때, 전부 `"1"`로만 이뤄진 가장 큰 축 정렬 정사각형의 넓이를 반환하세요. 비어 있는 칸이 하나도 없다면 `0`을 반환합니다.

**예시 1:**
```
Input: floor = [["1","1","0","1"],["1","1","1","1"],["0","1","1","1"],["1","1","1","1"]]
Output: 9
Explanation: The bottom-right 3x3 block is entirely clear, so the biggest square has side length 3 and area 9.
```

**예시 2:**
```
Input: floor = [["0","0","0"],["0","1","1"],["0","1","1"]]
Output: 4
Explanation: The 2x2 block in the bottom-right corner is all clear, giving area 4.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$biggest-clear-floor$S$);

-- biggest-locker-poster
UPDATE problem_translations SET
    description = $KO$복도에 사물함이 한 줄로 서 있고, 사물함 `i`의 높이는 `lockers[i]`입니다. 사물함 두 개를 골라 그 사이에 직사각형 포스터를 붙이려고 합니다. 포스터의 높이는 두 사물함 중 낮은 쪽에 맞춰지고, 너비는 두 사물함의 인덱스 차이만큼이 됩니다.

길이 `n`인 배열 `lockers`가 주어질 때, 붙일 수 있는 포스터의 최대 넓이를 반환하세요.

**예시 1:**
```
Input: lockers = [2,6,4,1,5,3,6,2,8]
Output: 42
Explanation: Lockers at index 1 (height 6) and index 8 (height 8) frame a poster of width 7 and height 6, giving 42.
```

**예시 2:**
```
Input: lockers = [2,3]
Output: 2
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$biggest-locker-poster$S$);

-- brawler-lane-collision
UPDATE problem_translations SET
    description = $KO$파이터들이 한 줄로 늘어서서 같은 레인을 동시에 움직입니다. 배열 `fighters`의 각 원소는 부호 있는 파워 값으로, 절댓값은 힘이고 부호는 방향입니다(양수면 오른쪽, 음수면 왼쪽).

같은 방향으로 가는 파이터끼리는 만나지 않고, 반대 방향이 부딪히면 약한 쪽만 쓰러집니다. 힘이 똑같으면 둘 다 쓰러집니다.

모든 충돌이 끝난 뒤 살아남은 파이터들을 원래의 왼쪽에서 오른쪽 순서대로 반환하세요.

**예시 1:**
```
Input: fighters = [3,7,-8]
Output: [-8]
Explanation: -8 knocks out 7, then knocks out 3, leaving only -8.
```

**예시 2:**
```
Input: fighters = [-3,4,-4,2]
Output: [-3,2]
Explanation: 4 and -4 cancel out; -3 and 2 never meet an opposite.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$brawler-lane-collision$S$);

-- bump-takeout-number
UPDATE problem_translations SET
    description = $KO$포장 박스에 적힌 번호가 십진수 자리 배열로 저장돼 있고, `digits[0]`이 가장 높은 자리입니다. 이 숫자에 1을 더한 결과를 같은 형태의 자리 배열로 반환하세요. 필요한 경우 자리올림도 처리해야 합니다(예: `9,9`는 `1,0,0`이 됩니다).

입력에는 선행 0이 없습니다. 숫자가 `0`인 경우(`[0]`)만 예외입니다.

**예시 1:**
```
Input: digits = [4,5,6]
Output: [4,5,7]
Explanation: 456 + 1 = 457.
```

**예시 2:**
```
Input: digits = [2,9,9]
Output: [3,0,0]
Explanation: 299 + 1 = 300, which keeps the same length but rewrites the trailing digits.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$bump-takeout-number$S$);

-- cafe-price-ratios
UPDATE problem_translations SET
    description = $KO$카페에 알려진 가격 비율 목록이 있습니다. `ratios[i] = [Ai, Bi]`와 `values[i]`는 `Ai` 하나의 가격이 `Bi` 하나의 가격의 `values[i]`배라는 뜻입니다.

각 `queries[i] = [Ci, Di]`에 대해, 주어진 비율들로부터 유도되는 `Ci / Di` 값을 반환하세요. 두 음료가 비율로 연결되지 않거나 둘 중 하나가 `ratios`에 한 번도 등장하지 않으면 `-1.0`을 반환합니다.

참고: `A / B = k`를 알고 있으면 `B / A = 1 / k`이고, 최소 한 번 이상 등장한 음료에 대해서는 `A / A = 1.0`입니다.

**예시 1:**
```
Input: ratios = [["milk","bread"],["bread","eggs"]], values = [4.0,2.0], queries = [["milk","eggs"],["eggs","bread"],["bread","milk"],["milk","milk"],["soap","milk"]]
Output: [8.00000,0.50000,0.25000,1.00000,-1.00000]
Explanation: milk/eggs = (milk/bread) * (bread/eggs) = 4.0 * 2.0 = 8.0; eggs/bread = 1/2.0 = 0.5; bread/milk = 1/4.0 = 0.25; milk/milk = 1.0; soap never appears so its query is -1.0.
```

**예시 2:**
```
Input: ratios = [["apple","pear"],["pear","plum"],["kiwi","lime"]], values = [3.0,4.0,2.0], queries = [["apple","plum"],["plum","apple"],["kiwi","lime"],["apple","kiwi"]]
Output: [12.00000,0.08333,2.00000,-1.00000]
Explanation: Apple and plum link through pear, giving 3.0 * 4.0 = 12.0 and the reciprocal. Kiwi and lime form a separate component, so kiwi/lime is known but apple/kiwi is not.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$cafe-price-ratios$S$);

-- cafe-stop-orders
UPDATE problem_translations SET
    description = $KO$`stops`는 한 번씩 방문할 서로 다른 카페 ID 목록입니다. `stops`의 가능한 모든 방문 순서를 반환하도록 `listStationOrders`를 구현하세요. 바깥 리스트의 순서는 상관없습니다.

**예시 1:**
```
Input: stops = [4,7,2]
Output: [[4,7,2],[4,2,7],[7,4,2],[7,2,4],[2,4,7],[2,7,4]]
Explanation: Three distinct cafes give 3! = 6 possible visit orders.
```

**예시 2:**
```
Input: stops = [5,9]
Output: [[5,9],[9,5]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$cafe-stop-orders$S$);

-- calm-phone-number
UPDATE problem_translations SET
    description = $KO$양의 정수 `reading`에 대해, 각 자리 숫자를 제곱해서 더한 값으로 수를 계속 바꿔 나갑니다. 이 과정이 결국 `1`에 도달하면 **평온한(calm)** 수, 영원히 순환만 하면 **평온하지 않은** 수라고 부릅니다.

`reading`이 평온한 수라면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: reading = 7
Output: true
Explanation: 7 -> 49 -> 97 -> 130 -> 10 -> 1.
```

**예시 2:**
```
Input: reading = 4
Output: false
Explanation: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4, a cycle that never hits 1.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$calm-phone-number$S$);

-- can-attend-bookings
UPDATE problem_translations SET
    description = $KO$창가 테이블이 하나뿐인 카페에서, `bookings`는 예약 목록을 `[start, end]` 형태로 저장합니다(영업 시작 이후 분 단위).

서로 겹치는 예약이 하나도 없으면 `true`, 하나라도 겹치면 `false`를 반환하세요. 한 예약이 끝나는 시각과 다음 예약이 시작되는 시각이 똑같은 경우는 겹치는 것으로 보지 않습니다.

**예시 1:**
```
Input: bookings = [[18,20],[19,21],[22,23]]
Output: false
Explanation: [18,20] and [19,21] both cover minute 19, so two parties collide.
```

**예시 2:**
```
Input: bookings = [[18,20],[20,22],[22,23]]
Output: true
Explanation: Each booking ends right when the next starts, so the table turns cleanly.
```

**예시 3:**
```
Input: bookings = [[45,90],[30,60]]
Output: false
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$can-attend-bookings$S$);

-- capture-enclosed-tiles
UPDATE problem_translations SET
    description = $KO$격자에서 영토 게임을 하고 있습니다. `'X'`는 내 타일, `'O'`는 적 타일이에요. 적 영역은 상/하/좌/우로 `'O'` 칸을 따라 이동해 테두리까지 닿을 수 있으면 살아남고, 그렇지 못하면 점령됩니다.

`board`를 **그 자리에서** 수정하세요. 완전히 둘러싸인 `'O'`는 모두 `'X'`로 뒤집고, 테두리와 이어진 `'O'`는 그대로 둡니다. 수정된 보드를 반환합니다.

**예시 1:**
```
Input: board = [["X","X","X","X"],["X","O","X","X"],["X","X","O","X"],["X","X","X","O"]]
Output: [["X","X","X","X"],["X","X","X","X"],["X","X","X","X"],["X","X","X","O"]]
Explanation: The `'O'` at (1,1) and (2,2) are boxed in, so they flip. The `'O'` at (3,3) sits on the border and survives.
```

**예시 2:**
```
Input: board = [["O","X"],["O","X"]]
Output: [["O","X"],["O","X"]]
Explanation: Both `'O'` cells are on the first column, already touching the edge, so nothing changes.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$capture-enclosed-tiles$S$);

-- chat-log-codec
UPDATE problem_translations SET
    description = $KO$협동 게임 채팅 로그용 코덱을 설계해 보세요. 보내는 쪽은 메시지 리스트를 가지고 있고, 받는 쪽에는 문자열 하나만 전달할 수 있는데, 그 문자열이 나중에 원래 리스트로 다시 풀려야 합니다.

다음 두 메서드를 가진 `ListCoder` 클래스를 구현하세요.

- `String pack(List<String> messages)` — 리스트를 하나의 문자열로 인코딩합니다. 메시지에는 여러분이 고른 구분자를 포함해 어떤 문자든 들어갈 수 있으므로, 특정 문자로 그냥 이어 붙이는 방식은 통하지 않습니다.
- `List<String> unpack(String blob)` — `pack`이 만든 문자열을 다시 디코딩해 원래 리스트와 순서·길이·내용이 완전히 똑같은 리스트를 반환합니다. 빈 메시지도 그대로 살려야 합니다.

코덱은 상태를 가지면 안 됩니다. `unpack`은 오직 `pack`이 내놓은 문자열만 이용해야 하고, 리스트가 비어 있거나 빈 메시지를 포함하거나 구분자처럼 보이는 문자로만 이루어진 메시지가 섞여 있어도 왕복 변환 결과가 입력과 정확히 같아야 합니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$chat-log-codec$S$);

-- chat-ring-buffer
UPDATE problem_translations SET
    description = $KO$파티 채팅은 고정 크기의 순환 버퍼에 최근 메시지만 남겨둡니다. 이 버퍼를 관리하는 `FixedRing`을 구현하세요.

- `FixedRing(int k)` — 용량이 `k`인 빈 링을 만듭니다.
- `boolean push(int value)` — 뒤쪽에 `value`를 넣습니다. 성공하면 `true`, 꽉 차 있으면 `false`를 반환합니다.
- `boolean pull()` — 앞쪽 메시지를 꺼내 버립니다. 성공하면 `true`, 비어 있으면 `false`를 반환합니다.
- `int front()` — 앞쪽 메시지를 제거하지 않고 반환하고, 비어 있으면 `-1`을 반환합니다.
- `int rear()` — 뒤쪽 메시지를 제거하지 않고 반환하고, 비어 있으면 `-1`을 반환합니다.
- `boolean isEmpty()` — 링에 메시지가 하나도 없을 때 `true`를 반환합니다.
- `boolean isFull()` — `k`개 슬롯이 모두 차 있을 때 `true`를 반환합니다.

**예시:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // all succeed
ring.push(4)                               // false, ring full
ring.rear()                                // 3
ring.pull()                                // true, drops 1
ring.push(4)                               // true, wraps around
ring.rear()                                // 4
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$chat-ring-buffer$S$);

-- cheapest-courier-route
UPDATE problem_translations SET
    description = $KO$어떤 배송 도구가 `0..n-1`로 번호 매겨진 `n`개 카페 사이를 단방향 배달 링크로 이어 주문을 전달합니다. `links[i] = [from, to, minutes]`는 카페 `from`에서 카페 `to`까지 `minutes`분이 걸리는 한 구간을 뜻합니다.

출발지 `src`, 도착지 `dst`, 그리고 중간에 거칠 수 있는 카페 수의 상한 `maxHops`가 주어졌을 때, `src`에서 `dst`까지 배달하는 **최소 총 소요 분**을 반환하세요. 경유 카페 수가 `maxHops` 이하인 경로가 존재하지 않으면 `-1`을 반환합니다.

**예시 1:**
```
Input: n = 5, links = [[0,1,50],[1,2,40],[0,2,200],[2,3,30],[3,4,20],[1,3,150]], src = 0, dst = 4, maxHops = 2
Output: 220
Explanation: The chain 0 -> 1 -> 3 -> 4 (cost 50 + 150 + 20 = 220) uses 2 intermediate cafes. The cheaper chain 0 -> 1 -> 2 -> 3 -> 4 would need 3 intermediates and is rejected.
```

**예시 2:**
```
Input: n = 4, links = [[0,1,80],[1,2,40],[0,2,300],[2,3,90],[0,3,400]], src = 0, dst = 3, maxHops = 0
Output: 400
Explanation: With maxHops = 0 only the direct link 0 -> 3 at 400 minutes qualifies, even though 0 -> 1 -> 2 -> 3 would total 210.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$cheapest-courier-route$S$);

-- check-interleaved-inputs
UPDATE problem_translations SET
    description = $KO$리듬 게임에서 두 컨트롤러가 각각 고정된 버튼 글자 시퀀스를 찍고, 화면에는 모든 입력이 합쳐진 기록이 남습니다. 이 합쳐진 시퀀스가 진짜 인터리브가 되려면 모든 입력이 정확히 한 번씩 등장하고, 각 컨트롤러 내부의 원래 순서가 유지되어야 합니다.

문자열 `controllerA`, `controllerB`, `merged`가 주어졌을 때, `merged`가 `controllerA`와 `controllerB`의 유효한 인터리브이면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: controllerA = "cat", controllerB = "dog", merged = "cdoagt"
Output: true
Explanation: Pull c from A, then d and o from B, then a from A, then g from B, then t from A. Both controller orders are preserved.
```

**예시 2:**
```
Input: controllerA = "abc", controllerB = "xyz", merged = "axbzyc"
Output: false
Explanation: After a then x, the next press from B would have to be y, but the merged stream shows z before y, violating B's order.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$check-interleaved-inputs$S$);

-- click-tally-window
UPDATE problem_translations SET
    description = $KO$버튼이 얼마나 자주 눌리는지 추적하고 싶습니다. `ClickTally`를 만들어 클릭 타임스탬프를 기록하고, 최근 5분(양 끝 포함) 동안 몇 번 클릭되었는지 알려주세요.

- `ClickTally()` — 빈 집계를 만듭니다.
- `void record(int timestamp)` — `timestamp` 초에 클릭 한 번을 기록합니다. 같은 초에 여러 번 찍힐 수도 있습니다.
- `int countSince(int timestamp)` — `[timestamp - 299, timestamp]` 구간 안의 클릭 수를 반환합니다.

호출은 타임스탬프가 감소하지 않는 순서로 들어옵니다.

**예시 1:**
```
Input: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
```
4초 시점에는 1, 2, 3초의 클릭이 모두 구간 안에 있습니다. 300초 시점에도 1초의 클릭이 아직 포함되어 네 번으로 잡히지만, 1초 뒤에는 그 클릭이 구간 밖으로 빠져 세 번으로 줄어듭니다.

**예시 2:**
```
Input: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
```
같은 초에 찍힌 클릭 세 번이 모두 집계됩니다.

**예시 3:**
```
Input: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
```
클릭이 하나도 없는 상태에서 조회하면 0이고, 이후 기록된 클릭은 300초 시점의 구간 안에 들어옵니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$click-tally-window$S$);

-- clone-quest-log
UPDATE problem_translations SET
    description = $KO$길드의 퀘스트 로그는 미션들이 연결 리스트로 이어진 형태입니다. 각 노드에는 다음 미션을 가리키는 `next` 포인터와, 로그 안의 다른 미션(또는 `null`)을 가리키는 `related` 포인터가 있습니다.

노드가 `n`개인 로그의 헤드가 주어졌을 때, 이 로그의 깊은 복사본 헤드를 반환하세요. 사본은 정확히 `n`개의 새로운 노드로 이루어져야 하며, 사본 안의 모든 `next`와 `related` 포인터는 반드시 사본 내부의 노드만 가리켜야 합니다.

표준 입력은 `[val, related_index]` 쌍들의 배열이며, `related_index`는 `related` 포인터가 가리키는 미션의 0부터 시작하는 인덱스이거나 `null`입니다.

**예시 1:**
```
Input: head = [[9,2],[4,null],[6,0],[2,1]]
Output: [[9,2],[4,null],[6,0],[2,1]]
Explanation: Four missions are cloned; each related pointer is rewired to the matching copy.
```

**예시 2:**
```
Input: head = [[5,0]]
Output: [[5,0]]
Explanation: The single node's related pointer loops back to itself in the clone.
```

**예시 3:**
```
Input: head = [[3,null],[7,null]]
Output: [[3,null],[7,null]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$clone-quest-log$S$);

-- compare-loadout-bits
UPDATE problem_translations SET
    description = $KO$두 팀원이 각자 로드아웃 비트마스크를 가지고 있고, 각 비트는 퍽 하나의 on/off를 나타냅니다. 두 사람이 서로 다르게 설정한 퍽 슬롯이 몇 개인지 세어 보세요.

음이 아닌 정수 `leftFlags`와 `rightFlags`가 주어지면, 두 값이 서로 다른 비트 위치의 개수를 반환하세요.

**예시 1:**
```
Input: leftFlags = 10, rightFlags = 5
Output: 4
Explanation: 10 is 1010 and 5 is 0101; all four low bits disagree.
```

**예시 2:**
```
Input: leftFlags = 14, rightFlags = 9
Output: 3
Explanation: 14 is 1110 and 9 is 1001; positions 0, 1, and 2 disagree.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$compare-loadout-bits$S$);

-- connect-water-bowls
UPDATE problem_translations SET
    description = $KO$동네 고양이들을 위한 물그릇을 좌표가 정해진 자리들에 놓고, 호스 길이 총합을 최소로 하여 서로 연결하려고 합니다. `bowls`가 주어지며, `bowls[i] = [xi, yi]`는 물그릇 `i`의 위치입니다. 물그릇 `i`와 `j`를 잇는 호스는 격자를 따라 지나가므로 길이가 `|xi - xj| + |yi - yj|` 미터입니다.

중간 물그릇을 거쳐도 좋으니, 모든 물그릇이 서로 도달 가능하도록 만드는 최소 총 호스 길이를 반환하세요.

**예시 1:**
```
Input: bowls = [[4,4],[4,3],[6,7],[10,2]]
Output: 13
Explanation: Laying hoses [4,4]-[4,3] (length 1), [4,4]-[6,7] (length 5), and [4,3]-[10,2] (length 7) connects every bowl for a total of 13 meters.
```

**예시 2:**
```
Input: bowls = [[0,0],[2,0]]
Output: 2
Explanation: Only one hose of length 2 is needed to join the two bowls.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$connect-water-bowls$S$);

-- count-cipher-decodings
UPDATE problem_translations SET
    description = $KO$레트로 암호 게임에서 글자 `A..Z`는 id `1..26`에 대응합니다. 해독할 숫자 문자열 `scan`이 주어지며, `0`으로 시작하는 묶음은 `05` 같은 id가 존재하지 않으므로 무효입니다.

`scan`을 왼쪽에서 오른쪽으로 `1..26` 범위의 유효한 id들로 쪼개는 서로 다른 방법의 수를 반환하세요. 정답은 32비트 부호 있는 정수 범위에 들어갑니다.

**예시 1:**
```
Input: scan = "1234"
Output: 3
Explanation: Valid splits: (1,2,3,4), (12,3,4), (1,23,4). "1234" as one id is too big, and "12,34" fails because 34 > 26.
```

**예시 2:**
```
Input: scan = "100"
Output: 0
Explanation: The second digit is 0, so it can't start an id, and the trailing 0 has no valid id either.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-cipher-decodings$S$);

-- count-coupon-ways
UPDATE problem_translations SET
    description = $KO$카페에서 고정 액면가의 스토어 크레딧 쿠폰을 여러 장 받았고, 이걸 조합해서 정확히 `amount`원을 쓰려고 합니다. `amount`와 `coupons`가 주어졌을 때, 합이 정확히 `amount`가 되는 서로 다른 조합의 개수를 반환하세요. 같은 쿠폰은 몇 번이든 다시 써도 되고, 순서는 따지지 않습니다. 가능한 조합이 없다면 `0`을 반환합니다.

**예시 1:**
```
Input: amount = 8, coupons = [1,3,4]
Output: 6
Explanation: The six combinations are 1+1+1+1+1+1+1+1, 1+1+1+1+1+3, 1+1+3+3, 1+1+1+1+4, 1+3+4, and 4+4.
```

**예시 2:**
```
Input: amount = 4, coupons = [5]
Output: 0
Explanation: A 5-won coupon alone can never total 4 won.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-coupon-ways$S$);

-- count-desk-clusters
UPDATE problem_translations SET
    description = $KO$교실 좌석표가 `m x n` 격자 `board`로 주어지고, `"1"`은 책상이 있는 칸, `"0"`은 빈 칸입니다. **그룹**은 상하좌우로 이어진 책상들의 최대 묶음을 뜻하며, 대각선은 연결로 치지 않습니다.

격자 안에 존재하는 그룹의 개수를 반환하세요. 격자 바깥쪽은 모두 빈 칸으로 간주합니다.

**예시 1:**
```
Input: board = [["0","1","1","0","0","1"],["1","1","0","0","0","1"],["0","0","0","1","0","0"],["1","0","0","1","1","0"],["1","0","0","0","0","1"]]
Output: 5
Explanation: Five 4-connected clusters — the top-left L, the right column pair, the center patch near (2,3), the left pair at (3,0)/(4,0), and the lone desk at (4,5).
```

**예시 2:**
```
Input: board = [["1","1","0","0"],["0","1","0","1"],["0","0","0","1"]]
Output: 2
Explanation: One cluster in the upper-left, and a two-desk column on the right edge.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-desk-clusters$S$);

-- count-doodle-palindromes
UPDATE problem_translations SET
    description = $KO$공책에 낙서하듯 글자를 이어 적어 문자열 `code`를 만들었습니다. **거울 구간**은 `code`의 연속된 부분 문자열 중 앞뒤로 똑같이 읽히는 조각을 말합니다. 글자 한 개짜리도 포함돼요.

`code`에 들어 있는 거울 구간의 총 개수를 반환하는 `countMirrorSpans(code)`를 구현하세요. 내용이 같아도 위치가 다르면 별개로 셉니다.

**예시 1:**
```
Input: code = "klmn"
Output: 4
Explanation: No two neighboring letters match, so only the 4 single letters qualify.
```

**예시 2:**
```
Input: code = "rrrr"
Output: 10
Explanation: Every contiguous chunk of the run is a mirror span. Length 4 gives 4 + 3 + 2 + 1 = 10.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-doodle-palindromes$S$);

-- count-dungeon-paths
UPDATE problem_translations SET
    description = $KO$`rows`행 `cols`열의 타일 기반 던전이 있습니다. 캐릭터는 좌상단 타일에서 출발하고 보물은 우하단에 있으며, 한 번에 아래쪽으로 한 칸 또는 오른쪽으로 한 칸씩만 움직일 수 있습니다.

출발지에서 보물까지 가는 서로 다른 경로의 수를 반환하는 `countGateRoutes`를 구현하세요.

**예시 1:**
```
Input: rows = 4, cols = 5
Output: 35
Explanation: Every path uses exactly 3 down-steps and 4 right-steps in some order, so the count is the number of ways to arrange those 7 moves.
```

**예시 2:**
```
Input: rows = 2, cols = 6
Output: 6
Explanation: With a single down-step required, the path is fully determined by which of the 6 columns that down-step happens in.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-dungeon-paths$S$);

-- count-flag-bits
UPDATE problem_translations SET
    description = $KO$레트로 게임에서 `0`부터 `upperId`까지의 각 레벨마다 클리어 비트마스크가 붙어 있고, 레벨마다 몇 개의 업적(켜진 비트)을 주는지 한 번에 확인하려고 합니다.

음이 아닌 정수 `upperId`가 주어지면, 길이가 `upperId + 1`인 배열 `flagCounts`를 반환하세요. `flagCounts[i]`는 `i`의 이진 표현에서 켜진 비트의 개수입니다.

**예시 1:**
```
Input: upperId = 4
Output: [0,1,1,2,1]
Explanation: 0=0b0, 1=0b1, 2=0b10, 3=0b11, 4=0b100.
```

**예시 2:**
```
Input: upperId = 7
Output: [0,1,1,2,1,2,2,3]
Explanation: Binary forms through 7 are 0, 1, 10, 11, 100, 101, 110, 111.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-flag-bits$S$);

-- count-hint-matches
UPDATE problem_translations SET
    description = $KO$수업 필기 `notes`와 짧은 힌트 `target`이 주어집니다. `target`이 `notes` 안에 부분수열로 몇 번 등장하는지 세어 보세요. 부분수열은 `notes`에서 원하는 위치를 건너뛰면서 순서만 유지해 글자를 골라낸 결과입니다. 고른 글자들이 겉보기에 같더라도 고른 위치가 다르면 서로 다른 매칭으로 칩니다.

전체 매칭 개수를 반환하는 `countFilterMatches`를 구현하세요. 답은 64비트 부호 있는 정수 범위 안에 들어옵니다.

**예시 1:**
```
Input: notes = "ggrrg", target = "grg"
Output: 4
Explanation: Each match picks a g, then a later r, then a later g. Among the g positions (0, 1, 4) and r positions (2, 3), the valid (i, j, k) triples are (0,2,4), (0,3,4), (1,2,4), (1,3,4).
```

**예시 2:**
```
Input: notes = "uvuvu", target = "uu"
Output: 3
Explanation: The u positions are 0, 2, and 4, and choosing any ordered pair gives a match: (0,2), (0,4), (2,4).
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-hint-matches$S$);

-- count-level-hops
UPDATE problem_translations SET
    description = $KO$플랫포머 게임에서 캐릭터는 레벨 `0`에 서 있고 레벨 `n`까지 가야 합니다. 한 번의 점프로 1레벨 또는 2레벨 앞으로 나아갈 수 있어요.

레벨 `n`에 정확히 도착하는 서로 다른 점프 순서의 개수를 반환하는 `countReservoirPaths(n)`을 구현하세요.

**예시 1:**
```
Input: n = 4
Output: 5
Explanation: The valid sequences are 1+1+1+1, 1+1+2, 1+2+1, 2+1+1, and 2+2.
```

**예시 2:**
```
Input: n = 5
Output: 8
Explanation: There are 8 distinct 1/2 hop sequences that sum to 5.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-level-hops$S$);

-- count-longest-cookie-runs
UPDATE problem_translations SET
    description = $KO$배열 `scores`는 트레이에서 쿠키를 꺼낸 순서대로 각 쿠키의 구운 정도를 담고 있습니다. `scores`에서 엄격하게 증가하는 부분수열 중 가장 긴 것의 길이를 찾고, 그 길이를 달성하는 서로 다른 부분수열이 몇 개인지 반환하세요. (순서는 고정이며, 원소를 건너뛸 수는 있어도 재배열할 수는 없습니다.)

**예시 1:**
```
Input: scores = [2,6,4,5,8]
Output: 1
Explanation: The longest strictly increasing subsequence has length 4: [2,4,5,8]. No other length-4 trail exists.
```

**예시 2:**
```
Input: scores = [3,3,3]
Output: 3
Explanation: No two entries are strictly ordered, so the longest trail has length 1. Each of the three entries alone is a distinct length-1 trail.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-longest-cookie-runs$S$);

-- count-square-candy-bags
UPDATE problem_translations SET
    description = $KO$사탕 가게는 완전제곱 크기(1, 4, 9, 16, 25, ...)의 봉지만 팔고, 같은 크기를 몇 번이든 다시 살 수 있습니다. 봉지 크기들의 합이 정확히 `pages`가 되도록 만드는 데 필요한 최소 봉지 개수를 반환하는 `countExactTargets(pages)`를 구현하세요.

**예시 1:**
```
Input: pages = 7
Output: 4
Explanation: One size-4 bag plus three size-1 bags totals 7. No combo of 1, 2, or 3 square-sized bags hits 7.
```

**예시 2:**
```
Input: pages = 17
Output: 2
Explanation: 17 = 16 + 1.
```

**예시 3:**
```
Input: pages = 5
Output: 2
Explanation: 5 = 4 + 1.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-square-candy-bags$S$);

-- count-task-orderings
UPDATE problem_translations SET
    description = $KO$조별 과제에 `0`부터 `n - 1`까지 번호가 매겨진 `n`개의 세부 과제가 있습니다. 과제 `0`을 제외한 모든 과제는 먼저 끝내야 할 선행 과제를 정확히 하나 갖고 있어, 의존 관계는 `parent[0] = -1`을 루트로 하는 트리 형태가 됩니다.

한 번에 한 사람만 작업할 수 있으므로 과제는 하나씩 순서대로 완료됩니다. `n`개 과제를 모두 끝낼 수 있는 유효한 완료 순서의 개수를 `10^8 + 7`로 나눈 나머지로 반환하세요.

**예시 1:**
```
Input: parent = [-1,0,0,2,2]
Output: 8
Explanation: Task 0 goes first. Below it, task 1 is a leaf and tasks 3, 4 hang off task 2. Interleaving the two branches yields 8 distinct orders.
```

**예시 2:**
```
Input: parent = [-1,0,1,2,3]
Output: 1
Explanation: The chain 0 -> 1 -> 2 -> 3 -> 4 has only one valid order.
```

**예시 3:**
```
Input: parent = [-1,0,0,0,0]
Output: 24
Explanation: After task 0, the four children can go in any order, giving 4! = 24 sequences.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-task-orderings$S$);

-- count-top-heroes
UPDATE problem_translations SET
    description = $KO$던전 크롤러의 파티 트리에서 각 노드는 영웅의 피해량을 저장합니다. 루트에서 어떤 영웅까지 내려가는 경로 위에 그보다 **엄격히** 더 큰 값을 가진 영웅이 없다면, 그 영웅을 **우세하다(dominant)**고 합니다. 루트는 항상 우세한 것으로 칩니다.

파티 트리의 `root`가 주어질 때, 우세한 영웅의 수를 반환하는 `tallyDominantBlocks(root)`를 구현하세요.

**예시 1:**
```
Input: root = [4,2,6,5,1,null,7]
Output: 4
Explanation: Hero 4 (root) is dominant. 5 beats its max ancestor 4. 6 beats its max ancestor 4. 7 beats its max ancestor 6. Hero 2 is overshadowed by 4, and hero 1 is overshadowed by 4.
```

**예시 2:**
```
Input: root = [5,3,5,2,4]
Output: 2
Explanation: The root 5 is dominant. The right child 5 ties with its ancestor 5 and still counts. The left subtree heroes (3, 2, 4) are all overshadowed by the root.
```

**예시 3:**
```
Input: root = [7]
Output: 1
Explanation: A single hero is always dominant.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-top-heroes$S$);

-- count-voice-parties
UPDATE problem_translations SET
    description = $KO$협동 게임에 `0`번부터 `n - 1`번까지 번호가 매겨진 `n`명의 플레이어가 있습니다. `relays[i] = [a, b]`는 플레이어 `a`와 `b`가 서로 직접 들을 수 있다는 뜻이며, 릴레이 체인으로 이어진 두 플레이어는 같은 파티에 속합니다.

서로 다른 파티의 수를 반환하도록 `tallyDeviceMeshes(n, relays)`를 구현하세요. 릴레이가 하나도 없는 플레이어도 혼자서 하나의 파티로 셉니다.

**예시 1:**
```
Input: n = 6, relays = [[0,1],[2,3],[3,4]]
Output: 3
Explanation: Players `{0,1}` share a relay, `{2,3,4}` are chained, and player `5` is alone — three parties total.
```

**예시 2:**
```
Input: n = 7, relays = [[0,1],[1,2],[2,3],[3,4],[4,5],[5,6]]
Output: 1
Explanation: Every player is reachable from every other through the relay chain, so one big party.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$count-voice-parties$S$);

-- cover-aquarium-zones
UPDATE problem_translations SET
    description = $KO$각 물고기 종은 1차원 구간 `[start, end]`(양 끝 포함) 안에서 먹이를 먹습니다. 위치 `x`에 알갱이 하나를 떨어뜨리면 `x`를 포함하는 구간의 모든 종이 먹이를 얻습니다.

구간 목록 `zones`가 주어질 때, 모든 종이 최소 한 번씩 먹이를 받도록 하는 데 필요한 알갱이의 최소 개수를 반환하세요.

**예시 1:**
```
Input: zones = [[5,11],[3,9],[8,14],[12,18],[20,25]]
Output: 3
Explanation: Pellets at 9, 18, and 25 work. Position 9 feeds [3,9], [5,11], and [8,14]; 18 feeds [12,18]; 25 feeds [20,25].
```

**예시 2:**
```
Input: zones = [[1,5],[6,10],[11,15]]
Output: 3
Explanation: No two zones overlap, so each needs its own pellet.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$cover-aquarium-zones$S$);

-- crush-heaviest-blocks
UPDATE problem_translations SET
    description = $KO$아케이드 기계가 가장 무거운 블록 두 개를 계속 부딪쳐 부숩니다. 두 블록의 무게를 `x`, `y` (`x <= y`)라고 할 때,

- `x == y`이면 둘 다 산산조각 납니다.
- `x != y`이면 가벼운 쪽은 파괴되고 무거운 쪽은 `y - x`가 됩니다.

남은 블록이 하나 이하가 될 때까지 이 과정을 반복합니다. 배열 `blocks`가 주어질 때, 마지막까지 남은 블록의 무게를 반환하고, 더미가 비면 `0`을 반환하세요.

**예시 1:**
```
Input: blocks = [3,6,4,9,5,2]
Output: 1
Explanation:
Crush 9 and 6 -> 3; pile becomes [3,4,5,2,3].
Crush 5 and 4 -> 1; pile becomes [3,2,3,1].
Crush 3 and 3 -> both destroyed; pile becomes [2,1].
Crush 2 and 1 -> 1; pile becomes [1].
```

**예시 2:**
```
Input: blocks = [9]
Output: 9
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$crush-heaviest-blocks$S$);

-- days-until-warmer
UPDATE problem_translations SET
    description = $KO$날씨 위젯이 일일 최고기온을 배열 `readings`에 날짜별 인덱스로 기록합니다. 각 날짜에 대해, **엄격히 더 따뜻한** 기온이 나타날 때까지 며칠을 기다려야 하는지 구하세요.

같은 길이의 배열 `wait`를 반환하며, `wait[i]`는 `i`일 이후 엄격히 더 따뜻한 기온이 나올 때까지의 날수입니다. 이후에 더 따뜻한 날이 없다면 `wait[i]`를 `0`으로 둡니다.

**예시 1:**
```
Input: readings = [55,58,52,50,54,60]
Output: [1,4,2,1,1,0]
Explanation: Day 1 (58) is the next warmer day after day 0. Day 5 (60) is the next warmer day after day 1. No day is warmer than day 5.
```

**예시 2:**
```
Input: readings = [45,45,45,50]
Output: [3,2,1,0]
Explanation: Each of the first three days must wait for day 3 (50), the next strictly warmer reading.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$days-until-warmer$S$);

-- decode-roman-floor
UPDATE problem_translations SET
    description = $KO$레트로 RPG는 던전 층을 로마 숫자로 표시합니다. 층 태그를 정수 값으로 변환하세요.

기호 값:

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

기호는 왼쪽에서 오른쪽으로, 큰 값부터 작은 값 순서로 읽습니다. 작은 기호가 더 큰 기호 바로 앞에 오면 그 쌍은 빼기로 처리합니다 (예: `IV` = 4, `IX` = 9). 유효한 빼기 쌍은 `IV`, `IX`, `XL`, `XC`, `CD`, `CM`입니다.

로마 숫자 문자열 `numeral`이 주어질 때, 그 정수 값을 반환하세요.

**예시 1:**
```
Input: numeral = "XIV"
Output: 14
Explanation: X + IV = 10 + 4 = 14.
```

**예시 2:**
```
Input: numeral = "CDXLII"
Output: 442
Explanation: CD + XL + II = 400 + 40 + 2 = 442.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$decode-roman-floor$S$);

-- dedupe-textbook-shelf
UPDATE problem_translations SET
    description = $KO$정렬된 정수 배열 `books`는 교실 책꽂이에 꽂힌 교과서들을 나타내며, 중복된 값들은 서로 붙어 있습니다. 고유한 값들만 원래 순서대로 배열 앞쪽으로 옮기고, 고유한 값의 개수 `k`를 반환하세요. 인덱스 `k` 이후의 값들은 채점에서 확인하지 않습니다.

**예시 1:**
```
Input: books = [2,2,5]
Output: 2, books = [2,5,_]
Explanation: Return k = 2. The front reads 2 then 5.
```

**예시 2:**
```
Input: books = [1,1,2,2,3,4,4,6,6,6]
Output: 5, books = [1,2,3,4,6,_,_,_,_,_]
Explanation: Five distinct values sit at the front in order.
```

**예시 3:**
```
Input: books = [8]
Output: 1, books = [8]
Explanation: A single-copy shelf is already compact.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$dedupe-textbook-shelf$S$);

-- deepest-skill-chain
UPDATE problem_translations SET
    description = $KO$RPG 스킬 트리가 `root`를 시작으로 퍼크를 해금해 나가며 더 깊은 스킬로 뻗어 갑니다. 트리의 **최대 깊이**, 즉 `root`에서 임의의 리프까지 내려가는 가장 긴 경로 위의 노드 수를 반환하세요. 빈 트리의 깊이는 `0`입니다.

**예시 1:**
```
Input: root = [8,5,12,null,null,9,17]
Output: 3
Explanation: The longest chain runs three perks deep: 8 -> 12 -> 9 or 8 -> 12 -> 17.
```

**예시 2:**
```
Input: root = [4,null,2,null,7]
Output: 3
Explanation: The chain 4 -> 2 -> 7 is three perks deep.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$deepest-skill-chain$S$);

-- desk-notes-overlap
UPDATE problem_translations SET
    description = $KO$나와 짝꿍이 각자 수업 필기를 과목 한 글자짜리 코드 문자열로 적었습니다. 두 문자열 모두에 같은 순서로 등장하는 가장 긴 글자 구간의 길이를 구하세요(중간에 다른 글자가 끼어 있어도 괜찮습니다).

**부분 수열(subsequence)**은 순서를 바꾸지 않고 일부 글자를 빼내 얻는 수열을 말합니다. 필기 문자열 `left`와 `right`가 주어질 때, 가장 긴 공통 부분 수열의 길이를 반환하고, 공통된 것이 없으면 `0`을 반환하세요.

**예시 1:**
```
Input: left = "history", right = "mystery"
Output: 4
Explanation: One longest common subsequence is "stry" (length 4).
```

**예시 2:**
```
Input: left = "ocean", right = "canoe"
Output: 3
Explanation: One longest common subsequence is "can": positions 1-3-4 of left and 0-1-2 of right.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$desk-notes-overlap$S$);

-- detect-portal-loop
UPDATE problem_translations SET
    description = $KO$RPG 던전에서 각 방의 `next` 포인터는 다음 방으로 순간이동시킵니다. 어떤 체인은 이전 방으로 되돌아가 무한히 순환하기도 합니다.

`head`부터 `next` 포인터를 따라갔을 때 어떤 방을 다시 방문하게 되면 `true`를, 그렇지 않으면 `false`를 반환하는 `detectTransferLoop(head, pos)`를 구현하세요. `pos`는 꼬리가 연결되는 0부터 시작하는 인덱스이며(`-1`이면 루프가 없음), 테스트 입력을 구성할 때만 사용되고 함수 내부에서는 **사용하지 않습니다**.

**예시 1:**
```
Input: head = [8,5,2,6,9], pos = 2
Output: true
Explanation: The tail's next pointer loops back to the room at index 2.
```

**예시 2:**
```
Input: head = [4,7,3], pos = 0
Output: true
Explanation: The last room teleports to the head, forming a full loop.
```

**예시 3:**
```
Input: head = [6,2], pos = -1
Output: false
Explanation: The chain ends cleanly; there's no loop.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$detect-portal-loop$S$);

-- dog-street-walk
UPDATE problem_translations SET
    description = $KO$강아지가 동네의 모든 길을 딱 한 번씩 밟으면서 산책해야 직성이 풀리고, 출발은 항상 집(구역 `"HUB"`)입니다. 일방통행 구간 목록 `routes`가 `[from, to]` 형태로 주어져요.

`"HUB"`에서 시작해 모든 구간을 정확히 한 번씩 지나는 경로를 반환하세요. 가능한 경로가 여러 개라면, 구역을 앞에서부터 한 칸씩 비교해 사전식으로 가장 작은 것을 골라야 합니다. 유효한 경로는 적어도 하나 존재한다고 보장됩니다.

**예시 1:**
```
Input: routes = [["ELM","HUB"],["HUB","BIR"],["BIR","ELM"],["HUB","CED"]]
Output: ["HUB","BIR","ELM","HUB","CED"]
Explanation: HUB -> BIR -> ELM -> HUB -> CED uses all four segments. Going to CED first would strand the dog before BIR and ELM.
```

**예시 2:**
```
Input: routes = [["HUB","NOR"],["HUB","SOU"],["NOR","SOU"],["SOU","HUB"],["SOU","NOR"]]
Output: ["HUB","NOR","SOU","HUB","SOU","NOR"]
Explanation: Taking NOR before SOU from the hub gives the lex-smallest walk that still finishes every segment.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$dog-street-walk$S$);

-- drop-conflicting-classes
UPDATE problem_translations SET
    description = $KO$다음 학기 수업을 고르고 있는데 몸은 하나라 한 번에 하나씩만 들을 수 있습니다. `classes`의 각 원소는 `[start, end]` 형태의 분 단위 시간대이며, 두 수업의 시간대가 실제로 겹쳐야만 충돌입니다 — 한 수업이 끝나는 순간 다른 수업이 시작되는 식으로 경계에서만 맞닿는 건 괜찮아요.

남은 수업들이 서로 겹치지 않도록 하려면 **최소 몇 개**를 포기해야 하는지 반환하세요.

**예시 1:**
```
Input: classes = [[1,3],[2,4],[3,5],[1,5]]
Output: 2
Explanation: Keep [1,3] and [3,5]; drop [2,4] and [1,5] to clear every overlap.
```

**예시 2:**
```
Input: classes = [[5,6],[5,6]]
Output: 1
Explanation: Two classes in the same slot — one has to go.
```

**예시 3:**
```
Input: classes = [[1,2],[2,3]]
Output: 0
Explanation: They touch but don't overlap, so you can take both.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$drop-conflicting-classes$S$);

-- drop-nth-reservation
UPDATE problem_translations SET
    description = $KO$어느 카페가 오늘의 예약을 들어온 순서대로 연결 리스트에 담아 관리합니다. 리스트의 `head`와 정수 `n`이 주어지면, **뒤에서부터** `n`번째 예약을 취소하고 갱신된 헤드를 반환하세요.

**예시 1:**
```
Input: head = [10,20,30,40,50,60], n = 3
Output: [10,20,30,50,60]
Explanation: Counting from the end, booking 40 is 3rd; after removing it the list is 10 -> 20 -> 30 -> 50 -> 60.
```

**예시 2:**
```
Input: head = [7], n = 1
Output: []
Explanation: The only booking is cancelled, so the schedule is empty.
```

**예시 3:**
```
Input: head = [4,9], n = 2
Output: [9]
Explanation: The 2nd from the end is the very first booking, so it gets dropped.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$drop-nth-reservation$S$);

-- dual-waterbowl-flow
UPDATE problem_translations SET
    description = $KO$햄스터의 경사진 놀이 공간이 `m x n` 격자로 주어지고, `field[r][c]`는 각 칸의 높이입니다. 좌상단 테두리(맨 위 행과 맨 왼쪽 열)에 물그릇 하나, 우하단 테두리(맨 아래 행과 맨 오른쪽 열)에 또 하나가 놓여 있어요. 물은 상하좌우 이웃 칸 중 **높이가 자기 이하인** 곳으로 흘러가고, 테두리 칸의 물은 바로 옆 그릇으로 빠집니다.

물이 **두 그릇 모두**에 닿을 수 있는 모든 좌표 `[r, c]`를 반환하세요. 순서는 상관없습니다.

**예시 1:**
```
Input: field = [[2,1,3,4,5],[3,2,3,5,6],[4,3,5,4,3],[5,6,4,3,2],[6,5,3,2,1]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,1],[4,0]]
Explanation: Tile (2,2) sits on the ridge — water can step down-left to the top-left bowl and down-right to the bottom-right one.
```

**예시 2:**
```
Input: field = [[2,4,6],[5,7,9],[8,10,12]]
Output: [[0,2],[1,2],[2,0],[2,1],[2,2]]
Explanation: The heights rise monotonically toward the bottom-right, so only the right column and bottom row drain into both bowls.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$dual-waterbowl-flow$S$);

-- eval-postfix-tape
UPDATE problem_translations SET
    description = $KO$수학 선생님이 칠판에 적어 놓은 후위 표기식을 계산해야 합니다. 테이프 `baleTape`는 토큰 배열로, 각 토큰은 부호 있는 정수이거나 `+`, `-`, `*`, `/` 중 하나예요. 연산자를 만나면 스택의 위쪽 두 수를 꺼내 계산한 뒤 결과를 다시 스택에 넣습니다.

나눗셈은 0 방향으로 버림합니다. 입력은 항상 올바른 후위 표기 프로그램이라 마지막에 스택에는 정확히 수 하나만 남고, 0으로 나누는 경우도 없습니다. 그 값을 반환하세요.

**예시 1:**
```
Input: baleTape = ["5","3","-","2","*"]
Output: 4
Explanation: (5 - 3) * 2 = 4.
```

**예시 2:**
```
Input: baleTape = ["8","2","/","7","+","3","*"]
Output: 33
Explanation: ((8 / 2) + 7) * 3 = 33.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$eval-postfix-tape$S$);

-- fewest-candy-bags
UPDATE problem_translations SET
    description = $KO$영화의 밤을 준비하며 사탕을 나눠 담으려 합니다. 찬장에는 크기가 정해진 봉지가 몇 종류 있고, 같은 크기의 봉지는 원하는 만큼 꺼내 쓸 수 있어요. 정확히 `quota`개의 사탕을 담되, 봉지를 가장 적게 쓰는 방법을 찾아야 합니다.

`bagSizes`에서 봉지들을 골라 합이 `quota`가 되도록 하는 최소 봉지 수를 반환하는 `fewestBagSizes(bagSizes, quota)`를 구현하세요. 만들 수 없다면 `-1`을 반환합니다.

**예시 1:**
```
Input: bagSizes = [2,4,7], quota = 15
Output: 3
Explanation: Using bags of size 4, 4, and 7 totals 15 pieces with three bags. No pair of bags from the catalog sums to 15, so three is the minimum.
```

**예시 2:**
```
Input: bagSizes = [3,5], quota = 4
Output: -1
Explanation: No combination of bags with capacities 3 and 5 sums to exactly 4 pieces.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$fewest-candy-bags$S$);

-- fewest-tile-jumps
UPDATE problem_translations SET
    description = $KO$`n`개의 타일이 `0`부터 `n - 1`까지 번호 붙은 플랫포머 스테이지를 플레이하고 있고, 시작 위치는 타일 `0`입니다. 배열 `fuel`은 각 타일에서 앞쪽으로 최대 몇 칸까지 점프할 수 있는지를 알려줘요. 즉, 타일 `i`에서는 `[i + 1, i + fuel[i]]` 범위 안의 아무 타일에나 착지할 수 있습니다.

타일 `n - 1`에 도달하는 데 필요한 최소 점프 횟수를 반환하는 `minVanHops(fuel)`을 구현하세요. 스테이지는 항상 클리어 가능하다고 보장됩니다.

**예시 1:**
```
Input: fuel = [1,4,2,1,3,1,2]
Output: 3
Explanation: Jump from tile 0 to tile 1. From tile 1 you can reach tile 5, so jump to tile 4. From tile 4 you can reach tile 6, the goal.
```

**예시 2:**
```
Input: fuel = [3,1,1,4,2,1]
Output: 2
Explanation: Jump from tile 0 straight to tile 3 (within reach 3). From tile 3 you can reach tile 7, which covers tile 5.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$fewest-tile-jumps$S$);

-- find-battery-peak
UPDATE problem_translations SET
    description = $KO$오후 동안 찍힌 휴대폰 배터리 로그가 `readings`에 들어 있고, 잠깐이라도 정점을 찍은 순간을 찾고 싶어요. **정점**이란 양쪽 이웃보다 엄격히 큰 값입니다. 배열 바깥은 `-무한`으로 취급하므로 양 끝 값은 하나뿐인 이웃만 이기면 됩니다.

정점인 인덱스 하나를 반환하세요. 여러 개라면 아무거나 돼요. 로그가 워낙 길기 때문에 `O(log n)` 시간에 동작해야 합니다.

**예시 1:**
```
Input: readings = [11,18,22,19,15]
Output: 2
Explanation: readings[2] = 22 beats both neighbors (18 and 19).
```

**예시 2:**
```
Input: readings = [3,7,12,25,20,14,9]
Output: 3
Explanation: readings[3] = 25 beats readings[2] = 12 and readings[4] = 20.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-battery-peak$S$);

-- find-empty-locker
UPDATE problem_translations SET
    description = $KO$체육 선생님이 `0, 1, 2, ..., n`번 사물함을 나눠 주며 그중 `n`개는 이미 주인이 있다고 알려줍니다. `[0, n]` 중 딱 하나가 비어 있고, 그게 당신 몫이에요.

이미 주인이 정해진 번호들의 리스트 `lockers`가 주어지면, 비어 있는 번호를 반환하세요. 답은 존재하며 유일함이 보장됩니다.

**예시 1:**
```
Input: lockers = [4,2,0,1]
Output: 3
Explanation: The list has length 4, so the full range is [0..4]. Only 3 is missing.
```

**예시 2:**
```
Input: lockers = [5,3,1,0,2]
Output: 4
Explanation: The full range is [0..5]; 4 isn't on the list.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-empty-locker$S$);

-- find-hidden-words
UPDATE problem_translations SET
    description = $KO$`m x n` 글자판 `board` 위에서 단어 찾기 게임을 하고 있고, 찾아야 할 단어 목록이 `targetWords`로 주어집니다. 어떤 단어의 글자들이 가로·세로로 인접한 칸을 잇는 경로로 이어지고, 같은 칸을 두 번 밟지 않는다면 그 단어는 찾은 것으로 칩니다.

`targetWords` 중 보드에서 추적 가능한 단어들을 사전식 오름차순으로 반환하세요. 같은 단어가 여러 경로로 발견되더라도 결과에는 한 번만 포함됩니다.

**예시 1:**
```
Input: board = [["c","o","d","e"],["h","a","t","s"],["i","r","n","m"],["p","u","a","l"]], targetWords = ["code","chat","maze","nail"]
Output: ["chat","code"]
```

**예시 2:**
```
Input: board = [["p","a"],["g","c"]], targetWords = ["pcg"]
Output: []
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-hidden-words$S$);

-- find-locker-number
UPDATE problem_translations SET
    description = $KO$서로 다른 사물함 번호들이 정렬되어 담긴 리스트 `shelf`에서 `query`가 몇 번째 자리에 있는지 찾아야 합니다. `shelf`에서의 0-인덱스 위치를 반환하고, 존재하지 않으면 `-1`을 반환하세요.

`O(log n)` 시간 안에 동작해야 합니다.

**예시 1:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 318
Output: 4
Explanation: Locker 318 sits at position 4 in the row.
```

**예시 2:**
```
Input: shelf = [102,145,201,247,318,402,510,633], query = 200
Output: -1
Explanation: No locker 200 exists in the list.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-locker-number$S$);

-- find-menu-calorie
UPDATE problem_translations SET
    description = $KO$카페의 칼로리 차트가 `m x n` 격자 `menu`로 주어집니다. 각 행은 왼쪽에서 오른쪽으로 오름차순, 각 열은 위에서 아래로 오름차순으로 정렬돼 있습니다. 단, 행끼리 값 범위가 겹칠 수 있어서 어떤 행의 첫 값이 바로 위 행의 마지막 값보다 작을 수도 있습니다.

격자의 어느 칸이든 정확히 `target`과 같은 값이 존재하면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
Output: true
```

**예시 2:**
```
Input: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
Output: false
```

**예시 3:**
```
Input: menu = [[-4,-1],[3,5]], target = -1
Output: true
Explanation: -1 sits in the first row, second column.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-menu-calorie$S$);

-- find-menu-price
UPDATE problem_translations SET
    description = $KO$카페 메뉴판이 `m x n` 격자 `menu`로 주어집니다. 각 행은 왼쪽에서 오른쪽으로 오름차순이고, 각 행의 첫 값은 바로 위 행의 마지막 값보다 큽니다. 즉, 행을 차례로 이어 읽으면 전체가 하나의 정렬된 배열이 됩니다.

격자의 어느 칸이든 `target`과 같은 값이 있으면 `true`, 없으면 `false`를 반환하세요. `O(log(m * n))` 시간에 동작해야 합니다.

**예시 1:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 22
Output: true
Explanation: Row 1, column 2 holds the value 22.
```

**예시 2:**
```
Input: menu = [[2,4,8,13],[15,19,22,28],[31,37,44,52]], target = 9
Output: false
Explanation: No cell shows a price of 9.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-menu-price$S$);

-- find-name-anagram
UPDATE problem_translations SET
    description = $KO$문자열 `log`와 `pattern`이 주어졌을 때, `pattern`의 어떤 순열이 `log`의 연속된 부분 문자열로 등장하면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: pattern = "ab", log = "ccbazz"
Output: true
Explanation: The substring "ba" inside log is a reordering of pattern.
```

**예시 2:**
```
Input: pattern = "rp", log = "mailpirzone"
Output: false
Explanation: No length-two substring of log uses one 'r' and one 'p'.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-name-anagram$S$);

-- find-rotated-low-score
UPDATE problem_translations SET
    description = $KO$서로 다른 값들로 이루어진 리더보드가 원래 오름차순으로 정렬되어 있었는데, `1`번에서 `n`번 사이 횟수만큼 회전된 상태입니다. 회전된 배열 `scores`가 주어질 때, 그 안에서 가장 작은 값을 반환하세요.

`O(log n)` 시간 안에 동작해야 합니다.

**예시 1:**
```
Input: scores = [7,9,12,2,5]
Output: 2
Explanation: The sorted list was [2,5,7,9,12] rotated 3 times, so 2 is the smallest.
```

**예시 2:**
```
Input: scores = [15,20,24,31,3,8,12]
Output: 3
```

**예시 3:**
```
Input: scores = [21,33,45,58]
Output: 21
Explanation: No rotation was applied, so the first entry is the smallest.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-rotated-low-score$S$);

-- find-submap
UPDATE problem_translations SET
    description = $KO$메인 트리 `root`와 서브 트리 `subRoot`가 주어집니다. `root`의 어떤 노드에서 시작한 서브트리가 `subRoot`와 구조와 값 모두 완전히 일치하면 `true`, 그렇지 않으면 `false`를 반환하세요. `root` 트리 자체도 자기 자신의 서브트리로 간주합니다.

**예시 1:**
```
Input: root = [9,6,7,2,4], subRoot = [6,2,4]
Output: true
Explanation: The left child of root is 6, and its subtree [6,2,4] matches subRoot exactly.
```

**예시 2:**
```
Input: root = [1,8,3,null,5], subRoot = [8,5]
Output: false
Explanation: Node 8 appears in root, but its child 5 hangs on the right, while subRoot has 5 on the left, so the shapes don't line up.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$find-submap$S$);

-- finish-the-level
UPDATE problem_translations SET
    description = $KO$`n`개의 타일로 이루어진 플랫포머 레벨에서 타일 `0`에서 출발합니다. `slack[i]`는 타일 `i`에서 뛸 수 있는 최대 점프 길이이고, `0`이면 그 타일은 구덩이라서 점프할 수 없습니다.

마지막 타일 `n - 1`에 도달할 수 있으면 `true`, 아니면 `false`를 반환하는 `canFinishLine(slack)`을 구현하세요.

**예시 1:**
```
Input: slack = [2,1,3,1,1,2]
Output: true
Explanation: Route 0 -> 2 (jump 2), 2 -> 5 (jump 3). Tile 5 is the final tile.
```

**예시 2:**
```
Input: slack = [2,0,0,1,3]
Output: false
Explanation: From tile 0 you can only reach tiles 1 or 2, both pits. Tile 3 is unreachable.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$finish-the-level$S$);

-- flatten-agenda-tree
UPDATE problem_translations SET
    description = $KO$회의 안건이 이진 트리 `root`에 저장되어 있습니다. 이를 **전위 순회** 순서로 오른쪽만 가리키는 하나의 사슬로 제자리에서 펼치세요. 즉, 모든 노드의 `left`는 `null`이 되고, `right`는 전위 순회 순서상 다음 노드를 가리켜야 합니다.

루트는 그대로 유지되며 반환 타입은 `void`입니다. 채점기는 루트에서부터 `right` 포인터를 따라가며 결과를 확인합니다.

**예시 1:**
```
Input: root = [7,3,9,1,4,null,12]
Output: [7,3,1,4,9,12]
Explanation: Preorder of the input is 7, 3, 1, 4, 9, 12. After unrolling, each node links to the next via the right pointer and all left pointers are cleared.
```

**예시 2:**
```
Input: root = []
Output: []
```

**예시 3:**
```
Input: root = [5]
Output: [5]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$flatten-agenda-tree$S$);

-- flip-chunks-of-k
UPDATE problem_translations SET
    description = $KO$연결 리스트가 주어졌을 때, 앞에서부터 `k`개씩 묶어 각 구간을 제자리에서 뒤집으세요. 끝에 `k`보다 짧은 구간이 남으면 그대로 둡니다.

재구성된 리스트의 head를 반환합니다. 노드의 값은 수정하지 말고 `next` 포인터만 다시 이어야 합니다.

**예시 1:**
```
Input: head = [10,20,30,40,50,60,70], k = 3
Output: [30,20,10,60,50,40,70]
Explanation: The first run (10,20,30) flips to (30,20,10); the next run (40,50,60) flips to (60,50,40); the trailing 70 stands alone.
```

**예시 2:**
```
Input: head = [5,15,25,35], k = 4
Output: [35,25,15,5]
Explanation: Exactly one run of length 4 is reversed in full.
```

**예시 3:**
```
Input: head = [2,4,6,8,10], k = 1
Output: [2,4,6,8,10]
Explanation: With k = 1 each run is a single node, so the list is unchanged.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$flip-chunks-of-k$S$);

-- flip-phone-codes
UPDATE problem_translations SET
    description = $KO$옛날 폴더폰 키패드에서는 각 숫자가 여러 글자에 대응됩니다.

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

`2`부터 `9`까지의 숫자로만 이루어진 문자열 `digits`가 주어지면, 이 숫자들로 만들 수 있는 모든 글자 조합을 반환하는 `mapKeypadCodes`를 구현하세요. 순서는 상관없습니다. `digits`가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: digits = "45"
Output: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
Explanation: Digit 4 maps to "ghi" and digit 5 maps to "jkl"; every pairing of one letter from each slot is included.
```

**예시 2:**
```
Input: digits = ""
Output: []
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$flip-phone-codes$S$);

-- four-tray-sum
UPDATE problem_translations SET
    description = $KO$베이크 세일이 끝난 뒤, `trays`의 각 트레이에는 부호 있는 개수가 적혀 있습니다(양수는 여분, 음수는 부족분). 합이 정확히 `demand`가 되는 트레이 네 개짜리 조합을 모두 찾으면 됩니다.

`trays`와 `demand`가 주어질 때, 서로 다른 네 인덱스의 값을 더해 `demand`가 되는 **중복 없는 사중쌍** `[trays[a], trays[b], trays[c], trays[d]]`을 모두 반환하세요. 같은 조합이 중복되어선 안 되며, 반환 순서는 상관없습니다.

**예시 1:**
```
Input: trays = [1,-1,2,-2,3,-3], demand = 0
Output: [[-3,-2,2,3],[-3,-1,1,3],[-2,-1,1,2]]
Explanation: Three different foursomes of trays cancel out to zero.
```

**예시 2:**
```
Input: trays = [3,3,3,3,3], demand = 12
Output: [[3,3,3,3]]
Explanation: Every tray has 3 extras, and any four of them bundle to 12.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$four-tray-sum$S$);

-- grocery-bag-triple
UPDATE problem_translations SET
    description = $KO$각 장바구니에는 `[produce, dairy, frozen]`의 세 가지 수치가 있습니다. 어떤 봉투든 수치 중 하나라도 `target`을 넘으면 쓸 수 없습니다. 사용 가능한 봉투 중 일부를 골라, 채널별 최댓값이 `target`과 정확히 일치하도록 만들 수 있는지 판단하세요.

그런 부분집합이 존재하면 `true`, 아니면 `false`를 반환하는 `canBuildBales(bags, target)`을 작성하세요.

**예시 1:**
```
Input: bags = [[3,2,1],[1,6,4],[3,1,7],[2,5,2]], target = [3,6,7]
Output: true
Explanation: Stack [3,2,1], [1,6,4], and [3,1,7]. The per-channel maxima are [3,6,7].
```

**예시 2:**
```
Input: bags = [[2,3,4],[4,2,1]], target = [2,3,5]
Output: false
Explanation: The second bag overshoots channel 0 (4 > 2) so it's out. The first alone gives [2,3,4], and nothing can lift channel 2 to 5.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$grocery-bag-triple$S$);

-- group-car-packs
UPDATE problem_translations SET
    description = $KO$차들이 1차선 도로를 따라 `target` 킬로미터 지점의 톨게이트를 향해 달립니다. `i`번째 차는 `position[i]`에서 출발하여 `speed[i]`의 속도로 주행하고, 빠른 차는 앞차를 추월할 수 없어서 따라잡는 순간 앞차 속도에 맞춰 함께 움직입니다. 함께 이동하는 차들의 묶음을 **무리(pack)**라고 합니다.

톨게이트에 도착하는 무리의 개수를 반환하세요.

**예시 1:**
```
Input: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
Output: 2
Explanation: The car at km 14 reaches alone (6h). The cars at km 7, 3, and 0 all catch up to the km-7 car before the booth, forming one pack. Two packs total.
```

**예시 2:**
```
Input: target = 15, position = [5], speed = [2]
Output: 1
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$group-car-packs$S$);

-- group-drink-labels
UPDATE problem_translations SET
    description = $KO$소문자로 이루어진 문자열 배열 `labels`가 주어집니다. 서로 애너그램인 문자열끼리 묶어주세요.

`clusterBarrels`를 구현하되, 각 내부 리스트는 사전순으로 정렬하고, 외부 리스트는 각 그룹의 첫 번째 라벨을 기준으로 사전순 정렬해서 반환합니다.

**예시 1:**
```
Input: labels = ["oakvanilla","vanillaoak","plum","lump","berrytannin","tanninberry","oak"]
Output: [["berrytannin","tanninberry"],["lump","plum"],["oak"],["oakvanilla","vanillaoak"]]
```

**예시 2:**
```
Input: labels = ["merlot"]
Output: [["merlot"]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$group-drink-labels$S$);

-- group-study-cards
UPDATE problem_translations SET
    description = $KO$스터디 그룹이 플래시카드를 `groupSize`개씩 연속된 숫자 묶음(예: `groupSize = 3`일 때 `{7,8,9}`)으로 나누려 합니다. 모든 카드는 정확히 하나의 그룹에 속해야 합니다.

정수 배열 `cards`와 정수 `groupSize`가 주어질 때, 이런 방식으로 나눌 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: cards = [2,3,4,5,6,7], groupSize = 3
Output: true
Explanation: Deal the cards as [2,3,4] then [5,6,7].
```

**예시 2:**
```
Input: cards = [1,2,3,5], groupSize = 2
Output: false
Explanation: After [1,2], the leftover cards 3 and 5 aren't consecutive.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$group-study-cards$S$);

-- group-tree-by-level
UPDATE problem_translations SET
    description = $KO$RPG 길드가 이진 트리로 저장되어 있고, 길드 마스터가 루트에 있습니다. 각 계급을 한 줄씩, 최상위 계급부터 출력하세요.

길드 트리의 `root`가 주어질 때, 계급별로 값을 반환하는 `groupByTier`를 구현하세요. 각 내부 리스트는 왼쪽에서 오른쪽 순서로 정렬되어야 하고, 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [10,5,15,null,null,12,20]
Output: [[10],[5,15],[12,20]]
Explanation: Rank 0 has 10. Rank 1 has 5 and 15. Rank 2 has 12 and 20.
```

**예시 2:**
```
Input: root = [42]
Output: [[42]]
Explanation: A lone guildmaster makes a single row.
```

**예시 3:**
```
Input: root = []
Output: []
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$group-tree-by-level$S$);

-- guild-chat-relay
UPDATE problem_translations SET
    description = $KO$`1`번부터 `n`번까지 번호가 매겨진 `n`명의 플레이어가 있는 길드가 있습니다. `links`는 일방향 중계 목록으로, `links[i] = [source, target, minutes]`는 `source`에서 `target`으로 `minutes`분 뒤 핑이 전달된다는 뜻입니다. 각 플레이어는 메시지를 처음 받는 순간 곧바로 재전송합니다.

시작 플레이어 `src`가 주어질 때, 모든 플레이어가 메시지를 받기까지 걸리는 **최소 분**을 반환하세요. 닿지 못하는 플레이어가 있으면 `-1`을 반환합니다.

**예시 1:**
```
Input: links = [[1,2,4],[1,3,2],[3,2,1],[2,4,3],[3,4,7]], n = 4, src = 1
Output: 6
Explanation: Player 3 gets it at minute 2, player 2 at minute 3 (via 1 -> 3 -> 2), player 4 at minute 6 (via 1 -> 3 -> 2 -> 4).
```

**예시 2:**
```
Input: links = [[1,2,5]], n = 3, src = 1
Output: -1
Explanation: No relay reaches player 3, so the broadcast never completes.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$guild-chat-relay$S$);

-- interleave-clip-chain
UPDATE problem_translations SET
    description = $KO$게임 클립들이 가장 이른 것부터 가장 늦은 것 순으로 연결 리스트를 이루고 있습니다. 앞쪽과 뒤쪽 클립이 번갈아 나오도록 리스트를 제자리에서 재배치하세요.

`head`가 주어지면 노드 순서를 `S0 -> Sn -> S1 -> Sn-1 -> S2 -> Sn-2 -> ...`로 바꾸세요. `next` 포인터만 조정하고, 노드 값은 건드리지 않습니다.

**예시 1:**
```
Input: head = [10,20,30,40,50,60]
Output: [10,60,20,50,30,40]
Explanation: Early and late clips are woven together: 10, 60, 20, 50, and so on.
```

**예시 2:**
```
Input: head = [1,3,5,7,9,11,13]
Output: [1,13,3,11,5,9,7]
Explanation: With an odd length the middle clip lands at the end.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$interleave-clip-chain$S$);

-- kth-top-score-stream
UPDATE problem_translations SET
    description = $KO$길드에 레이드 점수가 하나씩 올라오고 있습니다. 새 점수가 들어올 때마다 `k`번째로 높은 점수를 추적하세요. 중복 점수도 각자 고유한 순위를 차지하므로, `k`번째 최대값은 정렬된 리스트에서 `k`번째 위치에 있는 값입니다.

`TopKStream`을 구현하세요.

- `TopKStream(int k, int[] scores)` — 순위 `k`와 초기 레이드 점수 배치를 받아 트래커를 초기화합니다.
- `int record(int val)` — `val`을 스트림에 추가한 뒤, 현재 전체 스트림에서 `k`번째로 큰 점수를 반환합니다.

**예시 1:**
```
Input:
["TopKStream", "record", "record", "record", "record", "record"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
TopKStream tracker = new TopKStream(3, [4, 5, 8, 2]);
tracker.record(3);   // stream becomes [4,5,8,2,3]; 3rd largest is 4
tracker.record(5);   // stream becomes [4,5,8,2,3,5]; 3rd largest is 5
tracker.record(10);  // stream becomes [4,5,8,2,3,5,10]; 3rd largest is 5
tracker.record(9);   // stream becomes [4,5,8,2,3,5,10,9]; 3rd largest is 8
tracker.record(4);   // stream becomes [4,5,8,2,3,5,10,9,4]; 3rd largest is 8
```

리더보드가 계속해서 갱신되므로, 매번 전체를 다시 정렬하는 방식으로는 따라갈 수 없습니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$kth-top-score-stream$S$);

-- link-guild-siblings
UPDATE problem_translations SET
    description = $KO$길드 차트가 **완전 이진 트리(perfect binary tree)**로 되어 있습니다. 리프가 아닌 모든 노드는 자식이 정확히 둘이고, 모든 리프는 같은 층에 있습니다. 각 노드에는 `next` 포인터가 달려 있습니다.

```
class Node {
    int val;
    Node left;
    Node right;
    Node next;
}
```

각 노드의 `next`가 같은 층의 바로 오른쪽 노드를 가리키도록 `wireSiblingHubs`를 구현하세요. 해당 층의 가장 오른쪽 노드는 `next`를 `null`로 둡니다. 갱신된 `root`를 반환하세요.

**예시 1:**
```
Input: root = [10,20,30,40,50,60,70]
Output: [10,#,20,30,#,40,50,60,70,#]
Explanation: Three tiers in the tree.
- Tier 0: 10 -> null
- Tier 1: 20 -> 30 -> null
- Tier 2: 40 -> 50 -> 60 -> 70 -> null
The # marks the end of each tier's chain.
```

**예시 2:**
```
Input: root = [9]
Output: [9,#]
Explanation: A lone member has no right neighbor.
```

**예시 3:**
```
Input: root = [5,6,7]
Output: [5,#,6,7,#]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$link-guild-siblings$S$);

-- list-bracket-pairings
UPDATE problem_translations SET
    description = $KO$정수 `pairCount`가 주어지면, `pairCount`쌍의 괄호로 만들 수 있는 모든 올바른 괄호 문자열을 반환하세요. 올바른 문자열이란 모든 `(`가 뒤에 오는 `)`로 닫히고, 짝이 맞기 전에 `)`가 먼저 나오지 않는 문자열을 말합니다.

순서는 자유입니다 — 채점기가 비교 전에 정렬합니다.

**예시 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: The two valid bracket layouts using two pairs.
```

**예시 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$list-bracket-pairings$S$);

-- list-skill-build-paths
UPDATE problem_translations SET
    description = $KO$각 노드에 XP 값이 들어 있는 RPG 스킬 트리가 `root`를 루트로 주어집니다. 노드 값의 합이 정확히 `target`이 되는 루트에서 리프까지의 모든 경로를 반환하세요.

각 경로는 위에서 아래 순서대로 노드 값을 담은 리스트입니다. **리프**는 자식이 없는 노드를 말하며, 경로는 왼쪽 우선 DFS가 찾는 순서대로 나열합니다.

**예시 1:**
```
Input: root = [10,6,9,3,null,4,5,null,null,8,2], target = 19
Output: [[10,6,3]]
Explanation: The only root-to-leaf branch summing to 19 is 10 -> 6 -> 3.
```

**예시 2:**
```
Input: root = [7,2,4,null,5,1,3], target = 14
Output: [[7,2,5],[7,4,3]]
Explanation: Two branches reach 14: 7 + 2 + 5 and 7 + 4 + 3.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$list-skill-build-paths$S$);

-- list-trail-mix-combos
UPDATE problem_translations SET
    description = $KO$서로 다른 통 ID가 담긴 배열 `barrels`가 주어집니다. 아무것도 담지 않은 빈 조합부터 모든 통을 담은 조합까지, 가능한 모든 부분집합을 반환하세요.

바깥 리스트의 순서는 자유지만, 각 부분집합 내부의 원소는 `barrels`에서의 상대적 순서를 유지해야 합니다.

**예시 1:**
```
Input: barrels = [2,5,8]
Output: [[],[2],[2,5],[2,5,8],[2,8],[5],[5,8],[8]]
Explanation: With 3 bins there are 2^3 = 8 combos.
```

**예시 2:**
```
Input: barrels = [7]
Output: [[],[7]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$list-trail-mix-combos$S$);

-- lonely-candy
UPDATE problem_translations SET
    description = $KO$사탕 한 봉지를 식탁에 쏟아보니, 모든 맛이 두 개씩 있는데 딱 하나만 외톨이입니다. 그 하나를 찾아보세요.

배열 `frames`가 주어지는데, 정확히 하나를 제외한 모든 값이 두 번씩 등장합니다. 한 번만 등장하는 그 값을 반환하세요. 시간 복잡도 O(n), 추가 공간 O(1)로 해결해야 합니다.

**예시 1:**
```
Input: frames = [5,5,3]
Output: 3
Explanation: 5 appears twice; 3 only once.
```

**예시 2:**
```
Input: frames = [8,2,6,2,6]
Output: 8
Explanation: 2 and 6 each appear twice. 8 is the loner.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$lonely-candy$S$);

-- longest-combo-run
UPDATE problem_translations SET
    description = $KO$리듬 게임이 당신이 누른 버튼을 대문자 문자열 `code`로 기록합니다. 그중 최대 `k`개의 글자를 원하는 아무 글자로 덮어쓸 수 있습니다.

최대 `k`번의 덮어쓰기 후 같은 글자로만 이루어지도록 만들 수 있는 가장 긴 연속 부분 문자열의 길이를 반환하세요.

**예시 1:**
```
Input: code = "PQPQ", k = 2
Output: 4
Explanation: Overwrite both P's to Q to get "QQQQ", a run of length 4.
```

**예시 2:**
```
Input: code = "XXYXYYX", k = 1
Output: 4
Explanation: Overwrite the Y at index 2 to X to get the run "XXXX" from indices 0..3.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-combo-run$S$);

-- longest-doodle-palindrome
UPDATE problem_translations SET
    description = $KO$공책에 끄적인 단어 `word`가 주어집니다. 앞에서 읽으나 뒤에서 읽으나 똑같은 가장 긴 연속 부분 문자열을 찾으세요.

그 길이를 반환하는 `buildMirrorLength(word)`를 구현하세요. 글자 하나는 길이 1짜리 팰린드롬으로 간주합니다.

**예시 1:**
```
Input: word = "levelled"
Output: 5
Explanation: The slice "level" is a palindrome of length 5, and nothing longer mirrors itself.
```

**예시 2:**
```
Input: word = "barrel"
Output: 2
Explanation: The slice "rr" is a palindrome of length 2, and no longer mirror exists.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-doodle-palindrome$S$);

-- longest-folder-path
UPDATE problem_translations SET
    description = $KO$학교의 폴더 구조가 `root`를 루트로 하는 트리로 주어집니다. 두 노드 사이의 가장 긴 경로 길이를, 그 경로에 포함된 **간선 수**로 세서 반환하세요.

경로는 중간의 폴더에서 꺾일 수도 있고, 한 가지를 따라 곧장 내려갈 수도 있습니다. 반드시 `root`를 지날 필요는 없습니다.

**예시 1:**
```
Input: root = [7,3,8,1,4,null,9]
Output: 4
Explanation: The walk 1 -> 3 -> 7 -> 8 -> 9 uses 4 edges, which is the widest span.
```

**예시 2:**
```
Input: root = [2,null,5,3]
Output: 2
Explanation: The walk 2 -> 5 -> 3 crosses two edges.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-folder-path$S$);

-- longest-genre-window
UPDATE problem_translations SET
    description = $KO$넷플릭스 시청 대기열이 문자열 `feed`로 주어지고, 각 문자는 장르 태그를 나타냅니다. 모든 문자가 서로 다른 가장 긴 연속 부분 문자열의 길이를 반환하세요.

**예시 1:**
```
Input: feed = "finance"
Output: 4
Explanation: The substring "ance" has four distinct characters; no longer run is unique.
```

**예시 2:**
```
Input: feed = "zzzz"
Output: 1
Explanation: Every tag is the same, so only length-one runs are distinct.
```

**예시 3:**
```
Input: feed = "xxxyz"
Output: 3
Explanation: The tail "xyz" has three distinct characters.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-genre-window$S$);

-- longest-level-up-path
UPDATE problem_translations SET
    description = $KO$퍼즐 게임의 보드가 `m x n` 격자 `scores`로 주어집니다. 아무 타일에서나 시작해서, 점수가 **엄격히 더 높은** 인접 타일(상, 하, 좌, 우)로만 이동할 수 있습니다.

`scores` 위에서 엄격히 증가하는 가장 긴 경로의 길이를 반환하는 `longestVineAscent`를 구현하세요.

**예시 1:**
```
Input: scores = [[2,5,8],[3,4,7],[1,6,9]]
Output: 5
Explanation: Starting from the 1 in the bottom-left, 1 -> 3 -> 4 -> 7 -> 9 visits 5 tiles, each higher than the last.
```

**예시 2:**
```
Input: scores = [[4,2,1],[5,6,3]]
Output: 5
Explanation: The combo 1 -> 2 -> 4 -> 5 -> 6 threads through five adjacent tiles with strictly increasing scores.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-level-up-path$S$);

-- longest-quiz-streak
UPDATE problem_translations SET
    description = $KO$이번 주 퀴즈 점수를 본 순서대로 담은 정수 배열 `scores`가 주어집니다. 가장 긴 엄격 증가 **부분 수열**의 길이를 반환하세요. 퀴즈는 건너뛸 수 있지만 시간 순서는 유지해야 하며, 연달아 고른 두 원소는 `scores[i] < scores[j]`를 만족해야 합니다.

**예시 1:**
```
Input: scores = [4,10,2,6,3,5,8,11]
Output: 5
Explanation: The subsequence [2,3,5,8,11] (from indices 2,4,5,6,7) is strictly increasing and has length 5.
```

**예시 2:**
```
Input: scores = [9,2,7,4,6,8]
Output: 4
Explanation: The subsequence [2,4,6,8] has length 4; no strictly increasing subsequence of length 5 exists.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-quiz-streak$S$);

-- longest-seat-run
UPDATE problem_translations SET
    description = $KO$배열 `seatIds`에는 로비의 비어 있는 슬롯 번호가 순서 없이 나열되어 있습니다. `seatIds`에 있는 값들로 만들 수 있는 **연속된 정수로 이루어진 가장 긴 구간**의 길이를 반환하세요.

중복은 무시하며, 풀이는 O(n) 시간에 동작해야 합니다.

**예시 1:**
```
Input: seatIds = [42,7,41,40,9,8,43]
Output: 4
Explanation: The consecutive block 40, 41, 42, 43 has length 4.
```

**예시 2:**
```
Input: seatIds = [11,13,12,15,16,14,20,19,18]
Output: 6
Explanation: The block 11, 12, 13, 14, 15, 16 has length 6.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-seat-run$S$);

-- longest-unique-treats
UPDATE problem_translations SET
    description = $KO$배열 `treats[i]`는 뷔페 라인의 `i`번째 조각의 맛 코드입니다. **서로 다른 맛이 최대 두 종류**인 `treats`의 연속 구간 중 가장 긴 것의 길이를 반환하세요.

**예시 1:**
```
Input: treats = [4,4,7,4,7,2,7,2,2]
Output: 5
Explanation: The stretch [7,2,7,2,2] at the end uses only flavors 7 and 2 and has length 5. The opening stretch [4,4,7,4,7] also has length 5 using flavors 4 and 7.
```

**예시 2:**
```
Input: treats = [9,9,9]
Output: 3
Explanation: Every piece shares one flavor, so the entire run is clean.
```

**예시 3:**
```
Input: treats = [1,5,1,5,1,5]
Output: 6
Explanation: The whole row alternates between only two flavors, so the longest clean run spans everything.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$longest-unique-treats$S$);

-- low-score-stack
UPDATE problem_translations SET
    description = $KO$스피드런 시도 점수를 담는 스택을 설계하세요. 이 스택은 현재 담겨 있는 점수 중 가장 낮은 값도 함께 알려줘야 하며, 모든 연산은 `O(1)`에 동작해야 합니다.

`LowTrackStack`을 구현하세요.

- `LowTrackStack()` — 빈 스택으로 시작합니다.
- `void push(int val)` — 시도 점수 `val`을 맨 위에 올립니다.
- `void pop()` — 맨 위 점수를 제거합니다.
- `int top()` — 맨 위 점수를 제거하지 않고 반환합니다.
- `int getMin()` — 현재 스택에 있는 점수 중 가장 작은 값을 반환합니다.

`pop`, `top`, `getMin`은 최소 한 번 `push`가 이루어진 뒤에만 호출됩니다.

**예시 1:**
```
Input:
["LowTrackStack","push","push","push","getMin","pop","top","getMin"]
[[],[12],[6],[-2],[],[],[],[]]
Output: [null,null,null,null,-2,null,6,6]
```
세 점수 (12, 6, -2)를 차례로 push하면 `getMin`은 `-2`를 반환합니다. `pop` 한 번 후 스택은 `[12, 6]`이 되고, `top`은 `6`, 직전 최솟값이 빠졌으므로 `getMin`도 `6`을 반환합니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$low-score-stack$S$);

-- majority-boss-vote
UPDATE problem_translations SET
    description = $KO$배열 `votes`에는 `n`개의 항목이 있으며, 한 선택지가 전체의 절반을 엄격히 초과하는 표를 받았습니다. 즉, `n / 2`번보다 많이 등장하는 값을 찾아 반환하세요.

과반을 차지하는 선택지는 반드시 존재한다고 가정합니다.

**예시 1:**
```
Input: votes = [4,7,4]
Output: 4
```

**예시 2:**
```
Input: votes = [5,5,6,6,6,5,6]
Output: 6
Explanation: 6 shows up 4 times out of 7, which is more than half.
```

**예시 3:**
```
Input: votes = [9]
Output: 9
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$majority-boss-vote$S$);

-- menu-combos-tab
UPDATE problem_translations SET
    description = $KO$배열 `pastries`에는 카페 페이스트리들의 가격이 들어 있습니다(같은 값이 반복될 수 있음). 합이 정확히 `tab`이 되는 서로 다른 모든 조합을 찾으세요. 진열대의 각 페이스트리는 한 조합 안에서 최대 한 번만 쓸 수 있고, 가격 중복집합이 같은 두 조합은 하나로 취급합니다.

`listQuotaBatches`를 구현해 서로 다른 모든 중복집합을 반환하세요. 반환 순서는 자유입니다.

**예시 1:**
```
Input: pastries = [2,3,6,1,3,4], tab = 7
Output: [[1,2,4],[1,3,3],[1,6],[3,4]]
```

**예시 2:**
```
Input: pastries = [4,2,1,2,3], tab = 5
Output: [[1,2,2],[1,4],[2,3]]
```

**예시 3:**
```
Input: pastries = [8,8,8], tab = 16
Output: [[8,8]]
Explanation: 8 appears three times, but only a pair of 8s adds to 16.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$menu-combos-tab$S$);

-- merge-cafe-queues
UPDATE problem_translations SET
    description = $KO$`queues`에는 이미 픽업 시간 순으로 정렬된 `k`개의 연결 리스트 헤드가 들어 있습니다. 기존 노드들을 다시 이어 붙여 하나의 정렬된 리스트로 합치고, 그 헤드를 반환하세요.

**예시 1:**
```
Input: queues = [[2,5,8],[1,3,7],[4,6]]
Output: [1,2,3,4,5,6,7,8]
Explanation: Three pre-sorted queues weave into one.
```

**예시 2:**
```
Input: queues = []
Output: []
Explanation: No queues, nothing to merge.
```

**예시 3:**
```
Input: queues = [[]]
Output: []
Explanation: One empty queue merges to empty.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$merge-cafe-queues$S$);

-- merge-duplicate-contacts
UPDATE problem_translations SET
    description = $KO$공용 사무실 연락처 목록에 중복된 항목들이 섞여 있습니다. 각 항목은 이름으로 시작하고 그 뒤에 이메일 주소들이 이어집니다. 두 항목이 이메일을 하나라도 공유하면(추이적으로) 같은 사람으로 간주합니다. 단, 서로 다른 두 사람이 같은 이름을 쓸 수도 있습니다.

`unifyContactIdentities(accounts)`를 구현하세요. 이메일을 공유하는 항목들을 하나로 합치고, 합쳐진 각 항목은 이름 뒤에 그 사람의 중복 없는 이메일들이 **사전순으로 정렬된** 형태로 반환하세요. 전체 항목들의 순서는 자유입니다.

**예시 1:**
```
Input: accounts = [["Maya","maya.dp@set.film","mayalens@set.film"],["Maya","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Output: [["Maya","maya.dp@set.film","mayalens@set.film","mk.camera@set.film"],["Leo","leo.grip@set.film"],["Maya","maya.solo@set.film"]]
Explanation: The first two Maya entries share `mayalens@set.film` and collapse into one. The third Maya shares nothing and stays separate.
```

**예시 2:**
```
Input: accounts = [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Output: [["Ash","ash1@set.film","ash2@set.film"],["Bea","bea1@set.film","bea2@set.film"],["Cal","cal1@set.film","cal2@set.film"]]
Explanation: No shared emails, so every entry stays as-is with its emails sorted.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$merge-duplicate-contacts$S$);

-- merge-leaderboard-runs
UPDATE problem_translations SET
    description = $KO$랩 타임을 담은 두 연결 리스트 `runA`와 `runB`가 각각 오름차순(비감소)으로 정렬되어 있습니다. `combineOvenRotations(runA, runB)`를 구현해서 기존 노드들을 이어 붙여 정렬된 하나의 리스트로 만들고, 그 헤드를 반환하세요.

**예시 1:**
```
Input: runA = [2,5,9], runB = [3,4,7]
Output: [2,3,4,5,7,9]
Explanation: The times interleave into one sorted leaderboard.
```

**예시 2:**
```
Input: runA = [], runB = []
Output: []
Explanation: Neither friend has a run recorded.
```

**예시 3:**
```
Input: runA = [], runB = [3]
Output: [3]
Explanation: Only the second friend has a time.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$merge-leaderboard-runs$S$);

-- merge-reservation-slots
UPDATE problem_translations SET
    description = $KO$브런치 예약 시간이 `seatings[i] = [start_i, end_i]` 형태의 `[start, end]` 쌍들로 `seatings`에 주어집니다. 겹치는 두 예약은 하나로 합치세요 — 한 끝점에서만 닿아도 겹치는 것으로 봅니다. 원래의 모든 예약을 덮으면서 서로 겹치지 않는 가장 짧은 창 목록을 시작 시각 순으로 정렬해 반환하세요.

**예시 1:**
```
Input: seatings = [[2,5],[4,7],[9,11],[14,16]]
Output: [[2,7],[9,11],[14,16]]
Explanation: [2,5] and [4,7] share minutes 4 and 5, so they merge into [2,7]. The other two stay separate.
```

**예시 2:**
```
Input: seatings = [[1,3],[3,8],[10,12]]
Output: [[1,8],[10,12]]
Explanation: [1,3] and [3,8] touch at minute 3, which still counts as overlap, so they fuse into [1,8].
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$merge-reservation-slots$S$);

-- merged-price-median
UPDATE problem_translations SET
    description = $KO$오늘 판매된 음료 가격을 두 바리스타가 각각 정렬된 리스트 `zonesA`, `zonesB`로 관리하고 있습니다. 두 리스트를 합친 전체의 중앙값을 반환하세요. 즉, 전체 개수가 홀수면 가운데 값, 짝수면 가운데 두 값의 평균을 반환합니다.

풀이는 `O(log(m + n))` 시간에 동작해야 하며, 여기서 `m = zonesA.length`, `n = zonesB.length`입니다.

**예시 1:**
```
Input: zonesA = [2,5], zonesB = [4]
Output: 4.0
Explanation: The merged list is [2,4,5]; the middle value is 4.
```

**예시 2:**
```
Input: zonesA = [3,8], zonesB = [5,11]
Output: 6.5
Explanation: The merged list is [3,5,8,11]; the median is (5 + 8) / 2 = 6.5.
```

**예시 3:**
```
Input: zonesA = [], zonesB = [12]
Output: 12.0
Explanation: Only one value, so the median is that value.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$merged-price-median$S$);

-- micro-feed
UPDATE problem_translations SET
    description = $KO$게임 친목 보드용 `MicroFeed` 클래스를 만들어 보세요. 플레이어들은 짧은 상태 글을 올리고, 서로 팔로우하고, 최신순 피드를 확인할 수 있어야 합니다.

- `MicroFeed()` — 빈 보드로 시작합니다.
- `publishPost(int userId, int messageId)` — 플레이어 `userId`가 `messageId` 글을 올립니다. `messageId`는 전역에서 유일하며, 호출된 순서대로 들어옵니다.
- `List<Integer> latestFeed(int userId)` — `userId` 본인과 현재 팔로우 중인 플레이어들의 글 중 가장 최근 메시지 id를 최대 10개까지 최신순으로 반환합니다.
- `subscribe(int followerId, int followeeId)` — `followerId`가 `followeeId`를 팔로우합니다. 두 id가 같으면 아무것도 하지 않습니다.
- `unsubscribe(int followerId, int followeeId)` — `followerId`가 `followeeId` 팔로우를 끊습니다. 두 id가 같거나 팔로우 중이 아니면 아무것도 하지 않습니다.

**예시 1:**
```
Input: ["MicroFeed","publishPost","publishPost","latestFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
```
플레이어 1이 두 번 글을 올리고, 자기 글을 최신순으로 확인합니다.

**예시 2:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
```
플레이어 1이 2를 팔로우한 뒤부터는 2의 글도 피드에 보입니다.

**예시 3:**
```
Input: ["MicroFeed","publishPost","publishPost","subscribe","latestFeed","unsubscribe","latestFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
```
언팔하는 즉시 플레이어 2의 글은 1의 피드에서 사라집니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$micro-feed$S$);

-- min-cheat-code-edits
UPDATE problem_translations SET
    description = $KO$게임 위키에 새로 올라온 버전에 맞추려고 소문자 치트 코드를 다시 입력하고 있습니다. 키 한 번으로 글자를 하나 끼워 넣거나, 지우거나, 다른 글자로 바꿀 수 있습니다.

`source`와 `target`이 주어질 때, `source`를 `target`으로 바꾸는 데 필요한 최소 키 입력 횟수를 반환하세요.

**예시 1:**
```
Input: source = "coral", target = "carol"
Output: 2
Explanation: Replace the 'o' at index 1 with 'a', then replace the 'a' at index 3 with 'o'.
```

**예시 2:**
```
Input: source = "sunset", target = "sunrise"
Output: 3
Explanation: Delete the trailing 't' (sunset -> sunse), insert 'r' after the 'n' (sunse -> sunrse), then insert 'i' after that 'r' (sunrse -> sunrise).
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$min-cheat-code-edits$S$);

-- min-daily-brew
UPDATE problem_translations SET
    description = $KO$카페에서 대기열 `volumes`에 있는 모든 음료를 주어진 왼쪽-오른쪽 순서 그대로 `days`일 안에 제조해야 합니다. 바리스타는 매일 정수 용량 하나를 정하고, 그날은 다음 음료를 더 담았을 때 용량을 넘기 직전까지 연속으로 채운 뒤 마감합니다.

모든 음료를 `days`일 안에 출고할 수 있는 가장 작은 하루 용량을 반환하세요.

**예시 1:**
```
Input: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
Output: 27
Explanation: Capacity 27 ships in 5 days: [2,4,5,7,9], [11,13], [16], [18], [20].
```

**예시 2:**
```
Input: volumes = [4,3,3,5,2,5], days = 3
Output: 8
Explanation: Capacity 8 ships in 3 days: [4,3], [3,5], [2,5].
```

**예시 3:**
```
Input: volumes = [2,3,4,2,2], days = 4
Output: 4
Explanation: Capacity 4 ships in 4 days: [2], [3], [4], [2,2].
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$min-daily-brew$S$);

-- min-stamina-checkpoints
UPDATE problem_translations SET
    description = $KO$플랫포머 스테이지에 `0`부터 `n-1`까지 번호가 매겨진 `n`개의 체크포인트가 있습니다. 체크포인트 `i`에 착지하면 `effort[i]`만큼 체력을 소모합니다. 시작은 체크포인트 `0` 또는 `1`에서 할 수 있고, 어느 체크포인트에서든 한 칸 또는 두 칸 앞으로 뛸 수 있습니다(착지한 체크포인트의 비용을 냅니다).

마지막 체크포인트를 지나 위치 `n`에 도달하는 데 필요한 최소 총 체력을 반환하세요.

**예시 1:**
```
Input: effort = [4,2,8,3,5,6]
Output: 10
Explanation: Start at checkpoint 1 (pay 2), hop to checkpoint 3 (pay 3), then to checkpoint 5 (pay 5) and step off. Total 2 + 3 + 5 = 10.
```

**예시 2:**
```
Input: effort = [7,1,7,1,7]
Output: 2
Explanation: Start at checkpoint 1 (pay 1), hop two to checkpoint 3 (pay 1), then hop two more to finish. Total 2.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$min-stamina-checkpoints$S$);

-- min-wait-drive
UPDATE problem_translations SET
    description = $KO$지도 앱이 격자 위 모든 교차로의 대기 시간(분)을 표시해 줍니다. 좌상단에서 우하단까지 운전해 가야 하는데, 매 단계에서 동쪽 한 블록 또는 남쪽 한 블록으로만 이동할 수 있습니다.

`grid`가 주어졌을 때, 시작점과 끝점을 포함해 지나는 모든 교차로의 대기 시간을 더한 값 중 가장 작은 합을 반환하세요.

**예시 1:**
```
Input: grid = [[2,1,4],[5,3,2],[1,2,1]]
Output: 9
Explanation: The route 2 -> 1 -> 3 -> 2 -> 1 sums to 9 minutes, the best achievable.
```

**예시 2:**
```
Input: grid = [[3,1],[2,4],[1,5]]
Output: 11
Explanation: The route 3 -> 2 -> 1 -> 5 sums to 11 minutes; the alternative 3 -> 1 -> 4 -> 5 totals 13.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$min-wait-drive$S$);

-- mirror-menu-tree
UPDATE problem_translations SET
    description = $KO$카페 메뉴가 이진 트리 형태로 구성되어 있고, 왼쪽 자식은 순한 옵션, 오른쪽 자식은 진한 옵션입니다. 모든 계층에서 왼쪽과 오른쪽을 맞바꿔 메뉴판을 통째로 뒤집어 보세요.

메뉴 트리의 `root`가 주어졌을 때, 각 노드의 왼쪽과 오른쪽 자식을 재귀적으로 교환하고 뒤집힌 루트를 반환하도록 `reflectBlend`를 구현하세요.

**예시 1:**
```
Input: root = [5,3,8,2,4,7,9]
Output: [5,8,3,9,7,4,2]
Explanation: Every left/right pair is swapped at every level.
```

**예시 2:**
```
Input: root = [6,4,11]
Output: [6,11,4]
```

**예시 3:**
```
Input: root = []
Output: []
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$mirror-menu-tree$S$);

-- missing-sock-number
UPDATE problem_translations SET
    description = $KO$빨래 바구니에 번호가 적힌 양말들이 뒤섞여 있고, 그 번호 목록이 `socks`에 담겨 있습니다. 이 더미에서 빠져 있는 가장 작은 양의 정수를 찾으세요. 0이나 음수는 그냥 먼지 같은 거라 무시하면 됩니다.

`socks`에 없는 가장 작은 양의 정수를 반환하도록 `lowestMissingTarget`을 구현하세요. 배열은 정렬되어 있지 않고 중복이 있을 수 있습니다. 시간 복잡도 O(n), 추가 공간 O(1)을 목표로 하세요.

**예시 1:**
```
Input: socks = [2,3,1,5]
Output: 4
Explanation: 1, 2, 3 are all there. 4 is the smallest positive number missing.
```

**예시 2:**
```
Input: socks = [6,-2,8,10]
Output: 1
Explanation: No sock numbered 1 appears, so 1 is the first missing one.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$missing-sock-number$S$);

-- move-voided-scans
UPDATE problem_translations SET
    description = $KO$카페 포스기는 주문이 결제된 순서대로 가격을 `scans`에 저장하는데, 취소된 주문은 `0`으로 기록됩니다. 마감 영수증을 깔끔하게 하려고, 실제 가격들은 원래 순서를 유지한 채 모든 `0`을 뒤로 밀어 넣으세요.

`scans`를 **제자리에서** 변경해야 하며, 새 배열을 할당하면 안 됩니다. 메서드가 반환된 뒤 드라이버가 배열을 출력합니다.

**예시 1:**
```
Input: scans = [4,0,0,2,9,0,7]
Output: [4,2,9,7,0,0,0]
Explanation: The four real prices keep their order, and the three voids slide to the end.
```

**예시 2:**
```
Input: scans = [0,0,5]
Output: [5,0,0]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$move-voided-scans$S$);

-- multiply-as-text
UPDATE problem_translations SET
    description = $KO$음이 아닌 아주 큰 두 수가 숫자 문자열 `left`와 `right`로 주어집니다. 일반 `int`에는 담을 수 없을 정도로 길어요. 두 수의 곱을 십진 문자열로 반환하세요.

입력을 숫자 타입으로 변환하거나, 빅 정수 라이브러리를 쓰거나, 임의 길이 곱셈을 해주는 내장 헬퍼를 호출하면 안 됩니다. 자리별로 직접 긴 곱셈을 시뮬레이션해야 합니다.

**예시 1:**
```
Input: left = "12", right = "34"
Output: "408"
```

**예시 2:**
```
Input: left = "25", right = "13"
Output: "325"
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$multiply-as-text$S$);

-- nearest-cafe-stops
UPDATE problem_translations SET
    description = $KO$아침 배달을 준비하는 바리스타입니다. 납품처들은 각각 `[x, y]` 좌표에 있고, 카페는 원점에 있습니다. 카페에서 가장 가까운 `k`개의 납품처를 반환하세요.

거리는 유클리드 거리 `sqrt(x^2 + y^2)`로 계산합니다. 가장 가까운 `k`개를 순서에 상관없이 반환하면 되며, 순서를 제외하면 답은 유일합니다.

**예시 1:**
```
Input: stops = [[2,4],[7,7]], k = 1
Output: [[2,4]]
Explanation: sqrt(2^2 + 4^2) ≈ 4.47 is less than sqrt(7^2 + 7^2) ≈ 9.90, so (2, 4) is the nearest stop.
```

**예시 2:**
```
Input: stops = [[5,5],[1,2],[-3,1],[4,-4]], k = 2
Output: [[-3,1],[1,2]]
Explanation: The closest two stops are (-3, 1) at sqrt(10) and (1, 2) at sqrt(5).
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$nearest-cafe-stops$S$);

-- nearest-cat-feeder
UPDATE problem_translations SET
    description = $KO$`m x n` 격자 `grid`가 아파트 단지의 방들을 나타냅니다. 각 칸의 값은 다음 중 하나입니다.

- `-1` — **잠긴 방** (고양이가 지나갈 수 없음)
- `0` — **급식대 방** (먹이가 놓인 곳)
- `2147483647` — 거리를 아직 계산하지 않은 **열린 방**

열린 방 각각의 값을, 가장 가까운 급식대까지 상하좌우 네 방향으로 이동한 걸음 수로 바꾸세요. 이동은 열린 방을 통해서만 가능하며, 어떤 급식대에도 도달할 수 없는 열린 방은 `2147483647` 그대로 둡니다. `grid`를 제자리에서 갱신한 뒤 반환하면 됩니다.

**예시 1:**
```
Input: grid = [[2147483647,0,-1,2147483647],[2147483647,2147483647,2147483647,2147483647],[-1,2147483647,0,2147483647],[2147483647,2147483647,2147483647,-1]]
Output: [[1,0,-1,3],[2,1,1,2],[-1,2,0,1],[3,2,1,-1]]
Explanation: Feeders sit at (0,1) and (2,2). Each open room gets its step count to the closer feeder; (0,3) is three steps from (0,1) because (0,2) is locked.
```

**예시 2:**
```
Input: grid = [[0,2147483647,2147483647],[-1,2147483647,-1],[2147483647,2147483647,0]]
Output: [[0,1,2],[-1,2,-1],[2,1,0]]
Explanation: The locked rooms in the middle row force a detour, but every open room still reaches a feeder.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$nearest-cat-feeder$S$);

-- next-speaker-order
UPDATE problem_translations SET
    description = $KO$스탠드업 발표 순서가 정수 id 배열 `shotOrder`에 저장돼 있습니다. 매일 아침 이 순서는 같은 id들로 만들 수 있는 **사전식으로 바로 다음 순열**로 바뀌고, 현재 순서가 이미 가장 큰 순열이라면 가장 작은 순열로 리셋됩니다.

`shotOrder`를 **제자리에서** 다음으로 큰 순열로 재배치하고, 그런 순열이 없으면 가장 작은 순열로 바꾸는 `advanceShotOrder`를 구현하세요. 추가 메모리는 상수만 사용해야 합니다.

**예시 1:**
```
Input: shotOrder = [2,3,4]
Output: [2,4,3]
Explanation: The next arrangement after [2,3,4] is [2,4,3].
```

**예시 2:**
```
Input: shotOrder = [5,4,3,2]
Output: [2,3,4,5]
Explanation: [5,4,3,2] is the largest arrangement, so the lineup resets to ascending order.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$next-speaker-order$S$);

-- nth-lowest-score
UPDATE problem_translations SET
    description = $KO$점수들이 점수를 키로 하는 이진 탐색 트리에 저장되어 있어서, 중위 순회를 하면 낮은 점수부터 높은 점수 순으로 방문하게 됩니다.

트리의 `root`와 1부터 세는 위치 `k`가 주어질 때, `k`번째로 낮은 점수를 반환하는 `pickNthTarget`을 구현하세요. `k`는 `1` 이상이고 트리에 있는 점수 개수 이하라고 가정해도 됩니다.

**예시 1:**
```
Input: root = [8,4,12,2,6,10,14], k = 4
Output: 8
Explanation: In-order traversal yields [2,4,6,8,10,12,14]. The 4th entry is 8.
```

**예시 2:**
```
Input: root = [20,10,30,5,15,25,35,null,7], k = 2
Output: 7
Explanation: In-order traversal yields [5,7,10,15,20,25,30,35]. The 2nd entry is 7.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$nth-lowest-score$S$);

-- nth-unlockable-level
UPDATE problem_translations SET
    description = $KO$레벨 번호의 **소인수가 모두 `{2, 3, 5}`** 안에 포함되면 해당 레벨은 **해금 가능**합니다. 관례상 `1`도 해금 가능한 레벨로 칩니다. 해금 가능한 레벨을 작은 순서대로 나열하면 `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, ...`이 되고, `7`은 건너뜁니다.

`n`번째(1부터 세기) 해금 가능한 레벨을 반환하세요.

**예시 1:**
```
Input: n = 7
Output: 8
Explanation: The first seven unlockable levels are 1, 2, 3, 4, 5, 6, 8, so the 7th is 8.
```

**예시 2:**
```
Input: n = 12
Output: 16
Explanation: The first twelve unlockable levels are 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, so the 12th is 16.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$nth-unlockable-level$S$);

-- online-friend-mask
UPDATE problem_translations SET
    description = $KO$정수 `sensorMask`가 접속 중인 팀원을 비트 단위로 담고 있습니다. 켜져 있는 비트 하나가 온라인 상태인 친구 한 명을 의미합니다.

`sensorMask`를 부호 없는 정수로 보고 `1` 비트의 개수를 반환하는 `countActiveSensors(sensorMask)`를 구현하세요.

**예시 1:**
```
Input: sensorMask = 29
Output: 4
Explanation: 29 is 11101 in binary, which has four set bits.
```

**예시 2:**
```
Input: sensorMask = 256
Output: 1
Explanation: 256 is 100000000 in binary; only one friend is online.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$online-friend-mask$S$);

-- open-all-rooms
UPDATE problem_translations SET
    description = $KO$`0..n-1`로 번호가 붙은 방이 `n`개 있습니다. 처음에는 방 `0`만 열려 있고 나머지는 모두 잠겨 있습니다. 각 방 안에는 **다른 방**을 여는 열쇠들이 놓여 있는데, `rooms[i]`는 방 `i`에서 얻을 수 있는 열쇠 id 목록입니다.

어떤 방에 들어가면 그 방의 모든 열쇠를 수집하고, 수집한 열쇠로 대응되는 방을 언제든 열 수 있습니다. 모든 방을 방문할 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: rooms = [[2,1],[4],[3],[],[3,0]]
Output: true
Explanation: Start in room 0 and grab keys 2 and 1. Room 1 gives key 4; room 2 gives key 3. Visiting 3 and 4 covers all five rooms.
```

**예시 2:**
```
Input: rooms = [[2],[3],[],[4],[1]]
Output: false
Explanation: Room 0 only yields key 2, and room 2 is empty. The keys for rooms 1, 3, and 4 are trapped inside those rooms.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$open-all-rooms$S$);

-- order-group-tasks
UPDATE problem_translations SET
    description = $KO$`0`부터 `numSteps - 1`까지 번호가 붙은 `numSteps`개의 과제가 있습니다. `prereqs[i] = [a, b]`는 과제 `b`가 끝나야 과제 `a`를 시작할 수 있다는 의미입니다.

선행 관계를 모두 지키면서 모든 과제를 수행할 수 있는 순서를 하나 반환하세요. 여러 답이 존재하면 아무거나 괜찮고, 순환이 있어 어떤 순서도 불가능하면 빈 배열을 반환합니다.

**예시 1:**
```
Input: numSteps = 3, prereqs = [[2,0],[1,0]]
Output: [0,1,2]
Explanation: Task 0 has no prereqs so it runs first. Tasks 1 and 2 can then run in any order; [0,1,2] works.
```

**예시 2:**
```
Input: numSteps = 5, prereqs = [[1,0],[2,1],[3,1],[4,2],[4,3]]
Output: [0,1,2,3,4]
Explanation: 0 must come before 1, which must come before 2 and 3, which both must come before 4. [0,1,2,3,4] respects every edge.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$order-group-tasks$S$);

-- pair-lunchbox-snacks
UPDATE problem_translations SET
    description = $KO$도시락 상자에 간식을 나눠 담으려고 합니다. 도시락 하나에는 **간식을 최대 두 개**까지 담을 수 있고, 합친 무게가 `capacity` 그램을 넘어서는 안 됩니다. 모든 간식은 빠짐없이 담아야 합니다.

`crates[i]`가 간식 `i`의 무게일 때, 필요한 **도시락의 최소 개수**를 반환하세요.

**예시 1:**
```
Input: crates = [2,4], capacity = 6
Output: 1
Explanation: Both snacks weigh 6 grams together, which fits one lunchbox.
```

**예시 2:**
```
Input: crates = [4,3,1,2], capacity = 4
Output: 3
Explanation: Pair the 3 with the 1 in one lunchbox. The 2 goes alone, the 4 goes alone — three lunchboxes.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$pair-lunchbox-snacks$S$);

-- palindrome-episode-number
UPDATE problem_translations SET
    description = $KO$정수 `code`가 주어졌을 때, 앞에서 읽으나 뒤에서 읽으나 똑같으면 `true`, 아니면 `false`를 반환하세요. 음수 `code`는 팰린드롬이 될 수 없습니다. 왼쪽의 마이너스 기호에 대응하는 문자가 오른쪽에는 없기 때문입니다.

**예시 1:**
```
Input: code = 929
Output: true
Explanation: 929 reversed is still 929.
```

**예시 2:**
```
Input: code = 20
Output: false
Explanation: 20 reversed reads 02, which does not match 20.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$palindrome-episode-number$S$);

-- palindrome-menu-splits
UPDATE problem_translations SET
    description = $KO$소문자로 이루어진 문자열 `menu`가 주어집니다. `menu`를 왼쪽부터 오른쪽까지 전부 덮도록 조각으로 나누되, **각 조각이 팰린드롬**이 되는 모든 분할을 반환하는 `splitMirrorPhrases`를 구현하세요. 글자 하나짜리도 팰린드롬으로 칩니다. 바깥 리스트의 순서는 상관없습니다.

**예시 1:**
```
Input: menu = "dbbc"
Output: [["d","b","b","c"],["d","bb","c"]]
Explanation: 두 가지 분할이 유효합니다. "d", "b", "bb", "c" 모두 팰린드롬입니다.
```

**예시 2:**
```
Input: menu = "ef"
Output: [["e","f"]]
Explanation: "ef"가 팰린드롬이 아니므로 글자별로 쪼개는 것만 가능합니다.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$palindrome-menu-splits$S$);

-- peak-combo-window
UPDATE problem_translations SET
    description = $KO$리듬 게임 리플레이를 분석 중입니다. `combo[i]`는 `i`번째 비트에서의 콤보 수이고, `k`는 하이라이트 영상에 쓰이는 창 크기입니다.

`peakFlowPerStretch`를 구현해, 창을 처음부터 끝까지 한 칸씩 밀면서 `i`번째 출력이 `combo[i..i+k-1]`의 최댓값이 되도록 하세요.

**예시 1:**
```
Input: combo = [4,2,8,5,1,7,9,3], k = 4
Output: [8,8,8,9,9]
Explanation:
Window                         Peak
[4  2  8  5]  1  7  9  3        8
 4 [2  8  5  1] 7  9  3         8
 4  2 [8  5  1  7] 9  3         8
 4  2  8 [5  1  7  9] 3         9
 4  2  8  5 [1  7  9  3]        9
```

**예시 2:**
```
Input: combo = [6,6,6], k = 2
Output: [6,6]
Explanation: Every two-beat window has the same peak combo.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$peak-combo-window$S$);

-- peak-score-streak
UPDATE problem_translations SET
    description = $KO$`scores`의 각 항목은 리듬 게임에서 노트 하나로 얻거나 잃은 점수입니다. 합이 가장 큰, 연속된 비어 있지 않은 노트 구간을 찾아 그 합을 반환하세요.

**예시 1:**
```
Input: scores = [3,-2,5,-1,2,-8,4,3]
Output: 7
Explanation: The window [3,-2,5,-1,2] sums to 7, the max.
```

**예시 2:**
```
Input: scores = [2,1,-3,6,4]
Output: 10
Explanation: The window [6,4] sums to 10. The whole array also sums to 10.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$peak-score-streak$S$);

-- peak-table-demand
UPDATE problem_translations SET
    description = $KO$카페에서 피크 타임에 테이블이 몇 개 필요한지 알아보려 합니다. `visits[i] = [arrive, leave]`는 어떤 팀이 자리에 앉은 시각과 일어선 시각(분 단위)입니다. 한 팀은 반열린 구간 `[arrive, leave)` 동안 테이블을 점유하므로, 앞 팀이 떠나는 바로 그 분에 다음 팀이 같은 테이블에 바로 앉을 수 있습니다.

모든 팀이 머무는 동안 자리에 앉을 수 있도록 하는 데 필요한 **최소** 테이블 수를 반환하세요.

**예시 1:**
```
Input: visits = [[60,180],[90,150],[120,240],[200,300]]
Output: 3
Explanation: Between minute 120 and 150, three groups are seated at once, so three tables are required.
```

**예시 2:**
```
Input: visits = [[500,600],[100,200]]
Output: 1
Explanation: The two groups never overlap, so one table is enough.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$peak-table-demand$S$);

-- peak-temp-jump
UPDATE problem_translations SET
    description = $KO$`readings`에는 아파트 온도계의 시간별 측정값이 들어 있습니다. `i < j`인 `readings[j] - readings[i]` 중 가장 큰 값을 반환하세요.

온도가 계속 내려가기만 했다면 `0`을 반환합니다.

**예시 1:**
```
Input: readings = [14,9,11,8,12,15,10]
Output: 7
Explanation: Index 3 dips to 8, then index 5 climbs to 15 — a swing of 7.
```

**예시 2:**
```
Input: readings = [20,18,15,11]
Output: 0
Explanation: Only going down, so no positive swing.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$peak-temp-jump$S$);

-- pick-charging-start
UPDATE problem_translations SET
    description = $KO$순환 루프에 `n`개의 휴게소가 있습니다. 휴게소 `i`에서는 휴대폰이 `energy[i]`만큼 충전되고, 다음 휴게소까지 가는 동안 `drain[i]`만큼 소모됩니다. 휴대폰은 처음에 완전히 비어 있고, 시계 방향으로 한 바퀴를 도는 내내 배터리가 0 아래로 내려가면 안 됩니다.

한 바퀴를 완주할 수 있는 출발 휴게소의 인덱스를 반환하세요. 완주 가능한 출발점이 없다면 `-1`을 반환합니다. 가능한 출발점이 있다면 그 값은 유일합니다.

**예시 1:**
```
Input: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
Output: 0
```

**예시 2:**
```
Input: energy = [5,2,8], drain = [6,4,7]
Output: -1
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$pick-charging-start$S$);

-- pick-circular-donuts
UPDATE problem_translations SET
    description = $KO$원형 쟁반 위에 `n`개의 도넛이 놓여 있습니다. `yields[i]`는 도넛 `i`의 맛 점수입니다. 바로 옆에 붙어 있는 두 도넛은 같이 집을 수 없고, 쟁반이 원형이기 때문에 첫 번째 도넛과 마지막 도넛도 이웃으로 칩니다.

이웃 금지 규칙을 지키면서 얻을 수 있는 맛 점수의 최대 합을 반환하세요.

**예시 1:**
```
Input: yields = [4,1,5,6,2]
Output: 10
Explanation: Take yields[0]=4 and yields[3]=6 for a total of 10. You can't also take yields[4]=2 because it sits next to yields[0].
```

**예시 2:**
```
Input: yields = [3,8,2,7,1,9]
Output: 24
Explanation: Taking yields[1]=8, yields[3]=7, yields[5]=9 totals 24. That only works because you skipped yields[0], which is a neighbor of yields[5].
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$pick-circular-donuts$S$);

-- pick-snack-haul
UPDATE problem_translations SET
    description = $KO$복도에 자판기들이 한 줄로 늘어서 있습니다. `snacks[i]`는 자판기 `i`에서 얻을 수 있는 간식의 양입니다. 전선이 오래돼서, 한 번의 순회에서 이웃한 두 자판기를 연달아 털면 퓨즈가 나갑니다.

이웃한 자판기는 같이 고르지 않는다는 조건 아래, 얻을 수 있는 간식의 최대 합을 반환하세요.

**예시 1:**
```
Input: snacks = [4,1,1,9,1,3]
Output: 16
Explanation: Hitting machines 0, 3, and 5 yields 4 + 9 + 3 = 16. No other no-adjacent selection scores higher.
```

**예시 2:**
```
Input: snacks = [5,5,10,100,10,5]
Output: 110
Explanation: Hitting machines 1, 3, and 5 yields 5 + 100 + 5 = 110. Taking machine 3 alone scores 100, and any selection that skips machine 3 cannot catch up.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$pick-snack-haul$S$);

-- place-n-scouts
UPDATE problem_translations SET
    description = $KO$`n x n` 보드 위에 `n`명의 정찰병을 한 행에 한 명씩 배치하되, 어떤 둘도 서로 시야에 걸리지 않도록 해야 합니다. 두 정찰병이 같은 열, 같은 NW-SE 대각선, 또는 같은 NE-SW 대각선에 있으면 충돌로 간주합니다.

충돌 없는 서로 다른 모든 배치를 반환하세요. 각 배치는 길이 `n`인 문자열 `n`개의 리스트이고, `'Q'`는 정찰병, `'.'`는 빈 칸을 나타냅니다. 가능한 배치가 없으면 빈 리스트를 반환합니다. 반환 순서는 상관없습니다.

**예시 1:**
```
Input: n = 5
Output: [["Q....","..Q..","....Q",".Q...","...Q."],["Q....","...Q.",".Q...","....Q","..Q.."],[".Q...","...Q.","Q....","..Q..","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],["..Q..","Q....","...Q.",".Q...","....Q"],["..Q..","....Q",".Q...","...Q.","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["...Q.",".Q...","....Q","..Q..","Q...."],["....Q",".Q...","...Q.","Q....","..Q.."],["....Q","..Q..","Q....","...Q.",".Q..."]]
Explanation: Ten non-conflicting layouts exist on a 5 x 5 board.
```

**예시 2:**
```
Input: n = 3
Output: []
Explanation: No conflict-free layout exists on a 3 x 3 board.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$place-n-scouts$S$);

-- power-of-two-tank
UPDATE problem_translations SET
    description = $KO$어떤 열대어 가게에서는 물고기 수가 2의 거듭제곱(`1`, `2`, `4`, `8`, `16`, ...)일 때만 수조를 유지합니다. 알이 그렇게 분열하며 번식하기 때문이죠. 그 외의 수라면 수조가 섞였다고 봅니다.

어떤 음이 아닌 정수 `k`에 대해 `specimenCount == 2^k`이면 `true`, 아니면 `false`를 반환하는 `isSoloSpecies(specimenCount)`를 구현하세요.

**예시 1:**
```
Input: specimenCount = 32
Output: true
Explanation: 32 = 2^5.
```

**예시 2:**
```
Input: specimenCount = 12
Output: false
Explanation: 12 sits between 2^3 = 8 and 2^4 = 16, so it's not a power of two.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$power-of-two-tank$S$);

-- puddle-between-fences
UPDATE problem_translations SET
    description = $KO$햄스터 케이지 울타리가 한 줄로 나란히 서 있고, 각 칸의 폭은 1미터입니다. `wallHeight[i]`는 위치 `i`의 울타리 높이입니다. 물이 쏟아지면, 골짜기마다 양옆을 막고 있는 더 높은 울타리들 중 낮은 쪽 높이까지 물이 고입니다.

물이 모두 가라앉은 뒤 갇힌 물의 총 부피(단위 칸)를 반환하세요.

**예시 1:**
```
Input: wallHeight = [0,2,0,3,1,0,2,4,1,2,0,1]
Output: 10
Explanation: The tallest flanking fences cap each dip. Summing trapped depth above every plot gives 10 unit cells.
```

**예시 2:**
```
Input: wallHeight = [3,1,0,2,1,4]
Output: 8
Explanation: Water pools between the leftmost fence of height 3 and the rightmost of height 4, trapping 8 unit cells in the dip.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$puddle-between-fences$S$);

-- queue-from-stacks
UPDATE problem_translations SET
    description = $KO$카페 음료 픽업대에서는 주문 순서대로 손님에게 내드려야 하는데, 쓸 수 있는 도구라곤 맨 위 컵만 건드릴 수 있는 푸시다운 스택 두 개뿐입니다. 오직 이 스택 두 개만 사용해서(배열, 리스트, 덱은 금지) FIFO 큐처럼 동작하는 `QueueFromStacks`를 만들어 주세요. 내부 스택에 대해서는 push, pop, peek, 비어 있는지 확인하는 연산만 쓸 수 있습니다.

- `QueueFromStacks()` — 빈 큐를 만듭니다.
- `void push(int x)` — 주문 `x`를 줄 맨 뒤에 추가합니다.
- `int pop()` — 맨 앞 주문을 제거하고 반환합니다.
- `int peek()` — 제거하지 않고 맨 앞 주문을 반환합니다.
- `boolean empty()` — 큐가 비어 있으면 `true`를 반환합니다.

큐가 비어 있을 때 `pop`이나 `peek`이 호출되는 경우는 없다고 가정해도 좋습니다.

**예시:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1  -- front of the line
q.pop()    // 1  -- front is served
q.empty()  // false -- 2 still waiting
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$queue-from-stacks$S$);

-- random-pick-bag
UPDATE problem_translations SET
    description = $KO$게임 모임에서 서로 다른 카드 번호가 담긴 뽑기 가방을 하나 두고, 필요할 때마다 무작위로 카드 한 장을 뽑고 싶습니다. 지금 가방에 들어 있는 카드라면 모두 같은 확률로 뽑혀야 하고, 삽입·삭제·뽑기 모두 평균 상수 시간에 동작하도록 `RandomBag`을 설계하세요.

- `RandomBag()` — 빈 가방으로 시작합니다.
- `boolean insert(int val)` — 카드 `val`을 추가합니다. 원래 없었다면 `true`, 이미 있었다면 `false`를 반환합니다.
- `boolean remove(int val)` — 카드 `val`을 제거합니다. 있었다면 `true`, 없었다면 `false`를 반환합니다.
- `int drawRandom()` — 현재 가방에서 균등 확률로 카드 한 장을 반환합니다. 가방이 비어 있지 않을 때만 호출됩니다.

**예시:**
```
Calls:  ["RandomBag","insert","insert","remove","drawRandom"]
Args:   [[],[1],[2],[1],[]]
Result: [null,true,true,true,2]
```
카드 `1`과 `2`를 넣고 `1`을 다시 꺼내면 `2`만 남으므로, 뽑기는 `2`를 반환합니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$random-pick-bag$S$);

-- rebuild-boss-tree
UPDATE problem_translations SET
    description = $KO$비디오 게임 세이브 파일이 손상돼 보스전 트리가 깨졌지만, 다행히 두 개의 로그 파일이 살아남았습니다. 하나는 **전위 순회**(노드, 왼쪽, 오른쪽) 기록이고, 다른 하나는 **중위 순회**(왼쪽, 노드, 오른쪽) 기록입니다. 이 두 로그만 가지고 원래 트리를 복원해 주세요.

같은 노드 id들이 각 순회 순서대로 담긴 정수 배열 `preorder`와 `inorder`가 주어지면, `assembleBreakdown(preorder, inorder)`를 구현해 복원된 트리를 반환하세요. 모든 id는 서로 다릅니다.

**예시 1:**
```
Input: preorder = [10,5,3,7,20,15], inorder = [3,5,7,10,15,20]
Output: [10,5,20,3,7,15]
Explanation: 10 is the root. Inorder splits into [3,5,7] (left) and [15,20] (right), giving left = (5, left 3, right 7) and right = (20, left 15).
```

**예시 2:**
```
Input: preorder = [42], inorder = [42]
Output: [42]
Explanation: A single node is the whole tree.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$rebuild-boss-tree$S$);

-- rebuild-tournament-line
UPDATE problem_translations SET
    description = $KO$게임 토너먼트 대기줄을 다시 정렬하는 중입니다. 각 참가자는 `[h, k]` 쌍으로 표현되는데, `h`는 키이고 `k`는 자기 **앞**에 서 있는 사람 중 키가 `h` 이상인 사람의 수입니다. 지금 줄은 뒤죽박죽 상태입니다.

`players`가 주어지면, 맨 앞부터 맨 뒤까지 올바르게 정렬된 `[h, k]` 쌍의 리스트를 반환하세요. 유효한 배치가 항상 존재한다고 보장됩니다.

**예시 1:**
```
Input: players = [[8,0],[6,0],[8,1],[4,2],[6,2]]
Output: [[6,0],[8,0],[4,2],[6,2],[8,1]]
```

**예시 2:**
```
Input: players = [[5,0],[4,1],[5,1],[3,2]]
Output: [[5,0],[4,1],[3,2],[5,1]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$rebuild-tournament-line$S$);

-- recent-save-slots
UPDATE problem_translations SET
    description = $KO$휴대용 게임기의 퀵 세이브 슬롯 수는 정해져 있어서, 새 세이브가 들어오면 오래된 세이브가 밀려나게 됩니다. 키로 세이브를 관리하고, 가장 오래 사용되지 않은 슬롯부터 교체하는 `RecentRegistry`를 구현하세요.

- `RecentRegistry(int capacity)` — 최대 `capacity`개의 슬롯을 담을 수 있는 빈 테이블을 만듭니다.
- `int lookup(int key)` — `key`에 저장된 값을 반환합니다. 없으면 `-1`. 조회에 성공하면 해당 슬롯을 가장 최근에 사용한 것으로 표시합니다.
- `void store(int key, int value)` — `key`에 `value`를 저장합니다. 이미 `key`가 있다면 값만 덮어쓰고 최근 사용으로 갱신합니다. `key`가 새것이고 테이블이 꽉 차 있다면, 먼저 가장 오래 사용되지 않은 슬롯을 비워냅니다.

`lookup`과 `store` 모두 평균 `O(1)` 시간에 동작해야 합니다.

**예시:**
```
registry = new RecentRegistry(2)
registry.store(1, 10)   // {1=10}
registry.store(2, 20)   // {1=10, 2=20}
registry.lookup(1)      // returns 10; 1 is now most recent
registry.store(3, 30)   // evicts key 2 -> {1=10, 3=30}
registry.lookup(2)      // returns -1
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$recent-save-slots$S$);

-- recover-tier-order
UPDATE problem_translations SET
    description = $KO$친구가 소문자 영웅 태그 목록을 자기만의 티어 순서(알파벳 26글자의 어떤 순열)로 정렬해 두었습니다. 이미 정렬된 리스트 `tags`가 주어지면, 이 티어 순서를 문자열 하나로 복원하세요.

인접한 두 태그가 어떤 순서로도 설명이 안 되는 경우(예: 더 긴 태그가 자기를 접두사로 갖는 짧은 태그보다 먼저 나오는 경우)에는 `""`를 반환하세요. 유효한 순서가 존재한다면, `tags`에 등장하는 글자들에 대해 유일한 순서만 성립하도록 입력이 주어집니다.

**예시 1:**
```
Input: tags = ["ab","ba","bc","cb","cd","dc"]
Output: "abcd"
Explanation: The adjacent pairs force a before b, b before c, and c before d, giving a -> b -> c -> d.
```

**예시 2:**
```
Input: tags = ["studio","stud"]
Output: ""
Explanation: "stud" is a prefix of "studio" but comes after it, which no ordering can justify.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$recover-tier-order$S$);

-- redundant-friendship
UPDATE problem_translations SET
    description = $KO$`1`부터 `n`까지 번호가 매겨진 학생 `n`명의 친구 관계도는 원래 트리여야 했는데, 누군가 간선을 하나 더 추가하는 바람에 지금은 정확히 하나의 순환이 생겼습니다. 간선은 `links`로 주어지고, 각 `links[i] = [a, b]`는 방향이 없는 친구 관계를 뜻합니다.

다시 트리가 되도록 제거해야 할 간선을 반환하세요. 순환을 끊을 수 있는 후보가 여러 개라면, `links`에서 **가장 나중에** 등장하는 간선을 반환합니다.

**예시 1:**
```
Input: links = [[1,2],[2,3],[1,3]]
Output: [1,3]
Explanation: Students 1, 2, and 3 form the cycle 1 - 2 - 3 - 1. Dropping [1,3] leaves the tree 1 - 2 - 3.
```

**예시 2:**
```
Input: links = [[1,2],[2,3],[3,4],[4,5],[2,5],[1,6]]
Output: [2,5]
Explanation: The cycle is 2 - 3 - 4 - 5 - 2. Both [3,4] and [2,5] belong to it, but [2,5] appears later, so it's the one to drop.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$redundant-friendship$S$);

-- repeat-attendance-codes
UPDATE problem_translations SET
    description = $KO$반 출석부에는 `1..n`으로 번호가 매겨진 학생이 `n`명 있고, 길이 `n`의 정수 배열 `codes`에 학생증 스캔 기록이 담겨 있습니다. 일부 학생은 실수로 카드를 두 번 찍었고, 나머지는 정확히 한 번만 찍었습니다.

정확히 두 번 찍힌 번호를 모두 반환하세요. 순서는 상관없습니다. 가능하다면 선형 시간과, 출력 리스트를 제외하고 상수 크기의 추가 메모리만 사용해 풀어보세요.

**예시 1:**
```
Input: codes = [5,2,6,3,2,1,4,6]
Output: [2,6]
Explanation: Code 2 appears at indices 1 and 4; code 6 appears at indices 2 and 7.
```

**예시 2:**
```
Input: codes = [3,3,1,2]
Output: [3]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$repeat-attendance-codes$S$);

-- restore-wifi-ip
UPDATE problem_translations SET
    description = $KO$룸메이트가 Wi-Fi IP를 숫자만 쭉 이어서 적어 놨습니다. 이 숫자열로부터 만들 수 있는 모든 유효한 주소를 복원하세요. 유효한 주소는 점으로 구분된 정확히 네 조각으로 이루어지며, 각 조각은 `0` 이상 `255` 이하의 값이고, 조각이 `"0"` 자체가 아니라면 선행 0을 가질 수 없습니다.

문자열 `digits`가 주어지면, 점 세 개를 끼워 넣어 만들 수 있는 유효한 주소를 모두 반환하세요. 결과는 사전식 오름차순으로 정렬하며, 유효한 주소가 하나도 없으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: digits = "19216811"
Output: ["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]
```

**예시 2:**
```
Input: digits = "0202"
Output: ["0.2.0.2"]
Explanation: Single `"0"` is fine, but a two-digit segment can't start with `0`.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$restore-wifi-ip$S$);

-- reverse-playlist
UPDATE problem_translations SET
    description = $KO$음악 플레이리스트가 연결 리스트로 저장돼 있는데, 오늘은 역순으로 재생해 보고 싶습니다. 기존 노드를 그대로 재사용해 제자리에서 리스트를 뒤집어, 마지막 곡이 맨 앞으로 오도록 만드세요.

`next` 포인터를 다시 연결해 리스트를 뒤집고 새 헤드를 반환하는 `rewindConveyorChain(head)`를 구현하세요.

**예시 1:**
```
Input: head = [8,3,12,5,9]
Output: [9,5,12,3,8]
Explanation: Song 9 is now first and song 8 is last.
```

**예시 2:**
```
Input: head = [4,7]
Output: [7,4]
Explanation: A two-song playlist swaps order.
```

**예시 3:**
```
Input: head = []
Output: []
Explanation: Empty playlist, nothing to flip.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$reverse-playlist$S$);

-- reverse-savefile-flags
UPDATE problem_translations SET
    description = $KO$휴대용 콘솔은 세이브 파일의 플래그를 PC 에뮬레이터와 반대 순서로 읽습니다. 그래서 값을 비교하기 전에 32비트 상태 워드를 거울처럼 뒤집어 줘야 합니다.

32비트 부호 없는 정수 `statusWord`가 주어지면, 32개 비트를 모두 뒤집은 값을 반환하는 `reversePrinterFlags(statusWord)`를 구현하세요. 비트 0은 31번 자리로, 비트 1은 30번 자리로 옮겨가는 식입니다. 결과는 `[0, 2^32 - 1]` 범위의 `long` 값으로 반환합니다.

**예시 1:**
```
Input: statusWord = 8
Output: 268435456
Explanation: 8 has bit 3 set. After reversing, that bit lands at position 28, giving 2^28 = 268435456.
```

**예시 2:**
```
Input: statusWord = 6
Output: 1610612736
Explanation: 6 has bits 1 and 2 set. Reversed, they become bits 30 and 29, giving 2^30 + 2^29 = 1610612736.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$reverse-savefile-flags$S$);

-- right-side-skill-view
UPDATE problem_translations SET
    description = $KO$화면 오른쪽 끝에서 스킬 트리를 바라보면, 각 층(tier)에서 가장 오른쪽에 있는 노드만 눈에 들어오고 그 뒤에 가려진 노드들은 보이지 않습니다.

스킬 트리의 `root`가 주어질 때, 위에서 아래로 각 층의 가장 오른쪽 노드 값을 반환하세요. 트리가 비어 있다면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [7,8,9,null,6,null,3]
Output: [7,9,3]
Explanation: Tier 0 shows 7. Tier 1 shows 8 and 9, with 9 on the right. Tier 2 shows 6 and 3, with 3 on the right.
```

**예시 2:**
```
Input: root = [2,null,5]
Output: [2,5]
```

**예시 3:**
```
Input: root = []
Output: []
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$right-side-skill-view$S$);

-- rising-water-path
UPDATE problem_translations SET
    description = $KO$수위가 점점 올라가는 `n x n` 격자를 가로질러 건너가야 합니다. `elevation[r][c]`는 행 `r`, 열 `c`에 있는 타일의 높이입니다. 시각 `t`에는 높이가 `<= t`인 타일만 밟을 수 있고, 그보다 높은 타일은 아직 물 위로 드러나지 않은 상태입니다(※ 원문 상 물에 잠긴 상태로 간주).

`(0, 0)`에서 출발해 상하좌우로 인접한 밟을 수 있는 타일들만 이동해서 `(n - 1, n - 1)`까지 도달해야 합니다. 유효한 경로가 처음 생기는 최소 시각 `t`를 반환하세요.

**예시 1:**
```
Input: elevation = [[1,0],[2,3]]
Output: 3
Explanation: The destination itself has height 3, so no route can exist before t = 3. At t = 3 every tile is walkable.
```

**예시 2:**
```
Input: elevation = [[0,3,1,2],[7,4,5,8],[11,13,15,12],[6,9,10,14]]
Output: 14
Explanation: The lowest peak along the best route (0,0) -> (1,0) -> (2,0) -> (3,0) -> (3,1) -> (3,2) -> (3,3) is 14, the destination's height.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$rising-water-path$S$);

-- rotate-pet-cafe-map
UPDATE problem_translations SET
    description = $KO$펫 카페의 좌석 배치도가 하필 옆으로 눕혀져 저장되었고, 태블릿 용량이 빠듯해서 복사본을 따로 둘 여유가 없습니다. 제자리에서 시계 방향으로 90도 돌려야 합니다.

`n x n` 정수 격자 `cafeMap`이 주어지면, 제자리(in-place)에서 시계 방향으로 90도 회전시키는 `rotateParkMap`을 구현하세요. `cafeMap`을 직접 수정해야 하며, 별도의 `n x n` 격자를 새로 할당하면 안 됩니다.

**예시 1:**
```
Input: cafeMap = [[2,4,6],[8,1,3],[5,7,9]]
Output: [[5,8,2],[7,1,4],[9,3,6]]
```

**예시 2:**
```
Input: cafeMap = [[5,7,2,9],[1,3,4,6],[8,12,10,11],[14,13,15,16]]
Output: [[14,8,1,5],[13,12,3,7],[15,10,4,2],[16,11,6,9]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$rotate-pet-cafe-map$S$);

-- rotting-donuts
UPDATE problem_translations SET
    description = $KO$`m x n` 크기의 쟁반 위에 도넛이 놓여 있습니다. 각 칸은 다음 세 상태 중 하나입니다.

- `0` — **빈 자리** (도넛 없음)
- `1` — **신선한 도넛**
- `2` — **상한 도넛**

매 분마다, 상한 도넛과 상하좌우로 맞닿은 신선한 도넛도 상해버립니다. 신선한 도넛이 전부 사라질 때까지 걸리는 최소 시간(분)을 반환하고, 끝까지 닿지 못하는 신선한 도넛이 있다면 `-1`을 반환하세요.

**예시 1:**
```
Input: ward = [[2,1,1],[1,0,1],[1,1,1]]
Output: 4
Explanation: Starting from the single stale donut at (0,0), the last fresh one at (2,2) goes stale after four minutes.
```

**예시 2:**
```
Input: ward = [[2,0,1],[0,0,1],[1,1,1]]
Output: -1
Explanation: The stale donut at (0,0) is walled off by empty slots, so the fresh ones never get reached.
```

**예시 3:**
```
Input: ward = [[0,0,2],[0,0,0]]
Output: 0
Explanation: There are no fresh donuts, so zero minutes pass.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$rotting-donuts$S$);

-- round-nicknames
UPDATE problem_translations SET
    description = $KO$엉뚱한 파티 게임의 라운드에 이름표를 붙이고 있습니다. 양의 정수 `n`이 주어지면, `1`부터 `n`까지의 라운드에 대한 라벨 리스트를 다음 규칙으로 만들어 반환하세요.

- 라운드 번호가 3과 5의 공배수면 `"FizzBuzz"`
- 3의 배수이기만 하면 `"Fizz"`
- 5의 배수이기만 하면 `"Buzz"`
- 그 외에는 라운드 번호 자체를 십진수 문자열로

라벨은 순서대로 담아서 돌려주면 됩니다.

**예시 1:**
```
Input: n = 4
Output: ["1","2","Fizz","4"]
```

**예시 2:**
```
Input: n = 6
Output: ["1","2","Fizz","4","Buzz","Fizz"]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$round-nicknames$S$);

-- running-median-timer
UPDATE problem_translations SET
    description = $KO$스피드런 타이머는 시도할 때마다 완주한 초를 기록합니다. 새로운 시도가 실시간으로 쌓이는 상황에서도, 원할 때마다 지금까지의 완주 시간 중앙값을 바로 얻고 싶습니다. 기록을 추적하면서 누적 중앙값을 알려주는 `StreamMedian`을 만드세요. 기록 개수가 짝수면 중앙값은 가운데 두 값의 평균이고, 홀수면 가운데 한 값입니다. 두 경우 모두 `double`로 반환합니다.

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
collector.median()    // middle of [1, 2, 3] = 2.0
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$running-median-timer$S$);

-- same-skill-trees
UPDATE problem_translations SET
    description = $KO$두 플레이어가 각자 캐릭터의 스킬 트리를 이진 트리 형태로 내보냈습니다. 두 내보낸 결과가 완전히 같은지 — 즉 모양이 같고 모든 노드의 값도 같은지 — 확인해야 합니다.

두 스킬 트리의 루트 `p`와 `q`가 주어졌을 때, 모든 노드에서 일치하면 `true`, 그렇지 않으면 `false`를 반환하세요. 둘 중 어느 한 쪽이 비어 있을 수도 있습니다.

**예시 1:**
```
Input: p = [8,4,12], q = [8,4,12]
Output: true
Explanation: Same shape and same values at every node.
```

**예시 2:**
```
Input: p = [3,5], q = [3,null,5]
Output: false
Explanation: In p, 5 is a left child; in q, it's a right child. Shapes differ.
```

**예시 3:**
```
Input: p = [6,2,9], q = [6,9,2]
Output: false
Explanation: The left and right children are swapped, so the trees don't match.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$same-skill-trees$S$);

-- same-snack-mix
UPDATE problem_translations SET
    description = $KO$두 봉지의 트레일 믹스가 같은 글자들을 같은 개수만큼 포함하고 있다면, 순서와 상관없이 같은 믹스라고 봅니다. 글자 하나가 재료 하나를 의미합니다.

소문자로 된 재료 문자열 `mixA`와 `mixB`가 주어지면, 두 믹스가 재료의 다중집합으로 볼 때 동일하면 `true`, 그렇지 않으면 `false`를 반환하는 `matchRecipe`를 구현하세요. 길이가 다르다면 바로 `false`입니다.

**예시 1:**
```
Input: mixA = "butter", mixB = "bruett"
Output: true
Explanation: Both bags use one 'b', one 'u', one 'e', one 'r', and two 't'.
```

**예시 2:**
```
Input: mixA = "yeast", mixB = "toast"
Output: false
Explanation: `mixA` has 'y' and 'e' that `mixB` doesn't, so the mixes differ.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$same-snack-mix$S$);

-- search-rotated-catalog
UPDATE problem_translations SET
    description = $KO$RPG의 아이템 카탈로그는 원래 ID 순으로 정렬되어 있지만, 오늘은 어떤 축을 기준으로 회전된 상태로 열렸습니다. 예를 들어 `[10,14,18,22,25,28,33]`이 `[25,28,33,10,14,18,22]`처럼 보일 수 있습니다.

회전된 `catalog`와 찾고 싶은 ID `target`이 주어지면, `catalog`에서 `target`의 인덱스를 반환하고, 없다면 `-1`을 반환하세요. 실행 시간은 `O(log n)`이어야 합니다.

**예시 1:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 3
Output: 4
Explanation: The catalog stores 3 at index 4 after the rotation.
```

**예시 2:**
```
Input: catalog = [12,18,24,31,3,7,9], target = 15
Output: -1
Explanation: No entry matches 15.
```

**예시 3:**
```
Input: catalog = [8], target = 3
Output: -1
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$search-rotated-catalog$S$);

-- shared-guild-ancestor
UPDATE problem_translations SET
    description = $KO$MMO 길드의 계층은 트리로 표현됩니다. 루트는 길드 마스터, 자식 노드는 간부, 더 깊은 노드는 분대장부터 일반 멤버까지 내려갑니다. `root`와 두 멤버 `p`, `q`가 주어질 때, 두 노드를 모두 포함하는 서브트리를 가진 가장 깊은 노드, 즉 **최소 공통 조상**을 반환하세요.

노드는 자기 자신의 조상으로도 간주합니다. 따라서 `p`가 `q`의 상위에 있거나 그 반대라면, 상위에 있는 쪽을 그대로 반환합니다. 모든 값은 서로 다르며 `p`와 `q`는 반드시 트리에 존재합니다.

**예시 1:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 4, q = 11
Output: 7
Explanation: Member 4 sits under officer 7, and member 11 sits under squad leader 9 which sits under officer 7, so 7 is the deepest shared captain.
```

**예시 2:**
```
Input: root = [12,7,20,4,9,16,25,null,null,8,11], p = 9, q = 7
Output: 7
Explanation: Node 9 is already under node 7, so 7 is its own lowest common ancestor with 9.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$shared-guild-ancestor$S$);

-- shortest-book-span
UPDATE problem_translations SET
    description = $KO$책장 문자열 `shelf`에는 책이 꽂힌 순서대로 권당 한 글자짜리 태그가 나열되어 있습니다. 요구사항 문자열 `needed`에는 반드시 챙겨야 하는 태그가 개수까지 반영되어 있습니다. 예를 들어 `needed`에 `'O'`가 두 개라면 `'O'` 태그 책이 최소 두 권 필요하다는 뜻입니다.

`needed`의 모든 글자를 요구 개수만큼 포함하는 `shelf`의 가장 짧은 연속 부분 문자열을 반환하고, 그런 구간이 없다면 `""`를 반환하세요. 길이가 같은 후보가 여러 개라면 가장 앞에 있는 것을 반환합니다.

**예시 1:**
```
Input: shelf = "FINDTHEBOOKSNOW", needed = "BOK"
Output: "BOOK"
Explanation: The span "BOOK" contains a 'B', an 'O', and a 'K', and no shorter span covers all three tags.
```

**예시 2:**
```
Input: shelf = "XY", needed = "Y"
Output: "Y"
Explanation: The single volume tagged 'Y' already covers the requirement.
```

**예시 3:**
```
Input: shelf = "Q", needed = "QQ"
Output: ""
Explanation: The requirement asks for two 'Q'-tagged volumes, but the shelf only holds one.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$shortest-book-span$S$);

-- shortest-cookie-span
UPDATE problem_translations SET
    description = $KO$`trays`에는 왼쪽부터 오른쪽 순서로 각 칸에 담긴 쿠키 개수가 들어 있습니다. 연속된 한 구간을 그대로 쓸어 담아 총 `target`개 이상의 쿠키가 필요합니다.

`shortestBakeSpan`을 구현해, 합이 `target` 이상인 `trays`의 연속 구간 중 가장 짧은 길이를 반환하세요. 어떤 구간도 `target`에 도달하지 못하면 `0`을 반환합니다.

**예시 1:**
```
Input: trays = [3,1,4,1,5,9,2,6], target = 15
Output: 3
Explanation: The span [1,5,9] sums to 15, and no shorter span reaches 15.
```

**예시 2:**
```
Input: trays = [2,2,2], target = 10
Output: 0
Explanation: The whole tray only gives 6 cookies, short of the order.
```

**예시 3:**
```
Input: trays = [8,3,2], target = 8
Output: 1
Explanation: The first slot already meets the target by itself.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$shortest-cookie-span$S$);

-- shortest-dungeon-path
UPDATE problem_translations SET
    description = $KO$`board`는 `n x n` 격자이며 각 칸은 `0`(통과 가능) 또는 `1`(막힘)입니다. 어떤 칸에서든 주변 8방향 칸으로 이동할 수 있습니다. `(0, 0)`에서 `(n - 1, n - 1)`까지 가는 가장 짧은 통과 가능 경로를 찾으세요.

그 경로가 지나는 칸의 개수를 양 끝 포함으로 반환합니다. 경로 위 모든 칸은 `0`이어야 하며, 양 끝 중 하나가 막혀 있거나 경로가 존재하지 않으면 `-1`을 반환합니다.

**예시 1:**
```
Input: board = [[0,0],[0,0]]
Output: 2
Explanation: One diagonal step from (0,0) to (1,1) covers 2 walkable tiles.
```

**예시 2:**
```
Input: board = [[0,1,0],[0,0,0],[1,0,0]]
Output: 3
Explanation: The path (0,0) -> (1,1) -> (2,2) visits 3 walkable tiles.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$shortest-dungeon-path$S$);

-- shortest-table-booking
UPDATE problem_translations SET
    description = $KO$카페의 예약 목록 `bookings[i] = [start, end]`는 공통 타임라인 위에서 각 테이블 예약을 포함 구간(분 단위)으로 나타냅니다. 예약 하나의 길이는 `end - start + 1`입니다.

`probes`의 각 분에 대해, 그 시각을 덮는 예약들 중 **가장 짧은** 예약의 길이를 구하고, 덮는 예약이 하나도 없다면 `-1`을 반환합니다. 결과는 `probes`와 같은 순서의 배열로 반환하세요.

**예시 1:**
```
Input: bookings = [[2,5],[4,7],[1,9],[6,10]], probes = [3,6,9,11]
Output: [4,4,5,-1]
Explanation: Minute 3 sits in [2,5] (length 4) and [1,9] (length 9); tightest is 4. Minute 11 isn't in any booking.
```

**예시 2:**
```
Input: bookings = [[10,12],[8,20]], probes = [9,11,25]
Output: [13,3,-1]
Explanation: Minute 9 is only inside [8,20] (length 13). Minute 11 is in [10,12] (length 3) and [8,20] (length 13); tightest is 3. Minute 25 isn't covered.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$shortest-table-booking$S$);

-- skill-tree-codec
UPDATE problem_translations SET
    description = $KO$비디오 게임 스킬 트리를 평문 문자열로 저장해, 나중에 친구가 동일한 빌드를 그대로 불러올 수 있도록 만들려고 합니다. 정보를 잃지 않고 트리를 문자열로 싸고 다시 복원해야 합니다.

다음 두 메서드를 가진 `TreeSerializer` 클래스를 구현하세요.

- `String pack(TreeNode root)` — `root`를 루트로 하는 트리를 하나의 문자열로 인코딩합니다. `root`는 `null`일 수 있으며, 이 경우 "빈 트리"를 뜻하는 잘 정의된 문자열을 반환해야 합니다.
- `TreeNode unpack(String data)` — `pack`이 만든 문자열로부터 트리를 다시 만들어 반환합니다. 빈 트리를 나타내는 문자열이면 `null`을 반환합니다.

형식은 자유롭게 정해도 되지만, `unpack(pack(t))`은 항상 `t`와 동일한 트리를 돌려줘야 하며, 두 메서드 모두 상태를 가져서는 안 됩니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$skill-tree-codec$S$);

-- slot-a-meeting
UPDATE problem_translations SET
    description = $KO$팀 캘린더 `slots`는 회의 목록이며, 각 항목은 `[start, end]` 형식으로 `start` 기준 오름차순 정렬되어 있고 서로 겹치지 않습니다. 여기에 새 회의 `newSlot = [start, end]`을 끼워 넣어야 합니다.

`newSlot`을 `slots`에 추가한 뒤, 여전히 정렬되어 있고 서로 겹치지 않는 목록을 반환하세요. `newSlot`과 맞닿거나 겹치는 기존 항목은 모두 하나로 병합해야 합니다.

**예시 1:**
```
Input: slots = [[1,4],[7,10]], newSlot = [3,6]
Output: [[1,6],[7,10]]
Explanation: newSlot overlaps [1,4], merging into [1,6]. [7,10] is untouched.
```

**예시 2:**
```
Input: slots = [[2,4],[6,8],[10,12],[14,18]], newSlot = [5,11]
Output: [[2,4],[5,12],[14,18]]
Explanation: newSlot swallows [6,8] and [10,12] to form [5,12].
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$slot-a-meeting$S$);

-- slowest-snack-rate
UPDATE problem_translations SET
    description = $KO$`piles[i]`는 `i`번째 사탕 더미의 개수이고, `hours`시간 안에 모든 더미를 비워야 합니다. 매 시간마다 한 더미를 골라 최대 `k`개까지 먹으며, 남은 개수가 `k`보다 적다면 그 더미를 다 비우고 남는 시간은 그냥 쉬면 됩니다.

`hours`시간 안에 모든 더미를 다 먹을 수 있는 가장 작은 정수 속도 `k`를 반환하세요.

**예시 1:**
```
Input: piles = [5,8,12,20], hours = 9
Output: 6
Explanation: At rate 6 the hours per pile are ceil(5/6)=1, ceil(8/6)=2, ceil(12/6)=2, ceil(20/6)=4, totaling 9.
```

**예시 2:**
```
Input: piles = [40,25,18,33,12], hours = 5
Output: 40
Explanation: With 5 piles and only 5 hours, every pile must clear in a single hour.
```

**예시 3:**
```
Input: piles = [40,25,18,33,12], hours = 7
Output: 25
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$slowest-snack-rate$S$);

-- snack-combo-picks
UPDATE problem_translations SET
    description = $KO$간식팩 티켓이 담긴 배열 `snacks`가 있고, 각 티켓에는 맛 코드가 적혀 있으며 같은 맛이 중복해서 나올 수 있습니다. 여기서 만들 수 있는 서로 다른 조합을 모두 나열해야 합니다.

정수 배열 `snacks`가 주어질 때, 티켓으로 만들 수 있는 모든 서로 다른 중복집합(multiset)을 리스트의 리스트로 반환하는 `listMontageScenes`를 구현하세요. 빈 조합도 포함해야 하며, 결과의 순서는 상관없습니다.

**예시 1:**
```
Input: snacks = [2,5,5]
Output: [[],[2],[2,5],[2,5,5],[5],[5,5]]
```

**예시 2:**
```
Input: snacks = [5]
Output: [[],[5]]
```

**예시 3:**
```
Input: snacks = [2,2,2,1,2]
Output: [[],[1],[1,2],[1,2,2],[1,2,2,2],[1,2,2,2,2],[2],[2,2],[2,2,2],[2,2,2,2]]
Explanation: The flavor 2 appears four times and 1 appears once; each distinct multiset shows up exactly once.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$snack-combo-picks$S$);

-- snack-drawer-pair
UPDATE problem_translations SET
    description = $KO$배열 `snacks`에는 공용 서랍에 있는 각 간식의 칼로리가 들어 있습니다. 친구와 둘이서 정확히 `target` 칼로리만큼 먹으려고 합니다.

칼로리의 합이 `target`이 되는 서로 다른 두 간식을 골라 그 인덱스를 반환하세요. 정답이 되는 짝은 정확히 하나뿐이고, 인덱스를 반환하는 순서는 상관없습니다.

**예시 1:**
```
Input: snacks = [4, 11, 19, 23], target = 30
Output: [1, 2]
Explanation: snacks[1] + snacks[2] = 11 + 19 = 30.
```

**예시 2:**
```
Input: snacks = [8, 14, 6], target = 14
Output: [0, 2]
Explanation: snacks[0] + snacks[2] = 8 + 6 = 14.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$snack-drawer-pair$S$);

-- snack-stock-map
UPDATE problem_translations SET
    description = $KO$자판기의 간식별 재고 개수를 저장할 조회 테이블을 만들어야 합니다. 단, 언어에서 기본으로 제공하는 딕셔너리 라이브러리는 사용할 수 없습니다.

`ChainedMap` 클래스를 구현하세요.

- `ChainedMap()` — 빈 맵을 생성합니다.
- `void set(int key, int value)` — 간식 `key`의 수량을 `value`로 설정하며, 이미 값이 있으면 덮어씁니다.
- `int lookup(int key)` — 간식 `key`의 수량을 반환하고, 추적 중이 아니라면 `-1`을 반환합니다.
- `void erase(int key)` — 간식 `key`를 제거합니다. 없으면 아무 일도 하지 않습니다.

**예시 1:**
```
Input: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
```
`(1,10)`과 `(2,20)`을 기록한 뒤, 간식 1은 수량을, 간식 3은 `-1`을 반환합니다. 간식 2를 30으로 덮어쓰면 다음 조회에 반영되고, 삭제하면 다시 `-1`이 반환됩니다.

**예시 2:**
```
Input: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```
서로 다른 세 간식을 저장하면 각각 자신의 수량을 그대로 돌려줍니다.

**예시 3:**
```
Input: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
```
추가된 적 없는 간식에 대한 조회와 삭제는 아무 문제 없이 처리되어야 합니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$snack-stock-map$S$);

-- snapshot-town-map
UPDATE problem_translations SET
    description = $KO$연결된 무방향 그래프에서 마을의 한 장소를 가리키는 `node` 하나가 주어집니다. 각 장소에는 정수 `val`과 이웃 노드들의 리스트 `neighbors`가 있습니다.

주어진 노드에서 도달할 수 있는 연결된 그래프 전체를 **깊은 복사(deep copy)**해서 반환하세요. 복사본의 모든 노드는 같은 `val`과 같은 이웃 구조를 가진, 새로 할당된 객체여야 합니다. 어떤 노드도 원본과 공유해서는 안 됩니다.

그래프는 인접 리스트 형태로 전달됩니다. 인덱스 `i` (0부터 시작)에는 `val = i + 1`인 노드의 이웃들이 담겨 있습니다. 그래프가 비어 있지 않다면 진입점 노드의 `val`은 항상 `1`입니다.

**예시 1:**
```
Input: adjList = [[2,3],[1,4],[1,5],[2,5],[3,4]]
Output: [[2,3],[1,4],[1,5],[2,5],[3,4]]
Explanation: Spot 1 connects to 2 and 3; spot 2 connects to 1 and 4. The copy mirrors every edge with new node objects.
```

**예시 2:**
```
Input: adjList = [[2],[1,3],[2]]
Output: [[2],[1,3],[2]]
Explanation: A three-spot line is cloned edge-for-edge.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$snapshot-town-map$S$);

-- sort-latte-squared
UPDATE problem_translations SET
    description = $KO$`drifts`는 비감소 순으로 정렬되어 있으며, 각 라떼의 목표 온도로부터의 편차를 담고 있습니다(차가우면 음수, 뜨거우면 양수).

편차를 제곱한 값들을 비감소 순으로 반환하세요. 범용 정렬 함수는 쓰지 말고 O(n)을 목표로 풀어 보세요.

**예시 1:**
```
Input: drifts = [-5,-2,0,4,9]
Output: [0,4,16,25,81]
```

**예시 2:**
```
Input: drifts = [-6,-4,1,3,8]
Output: [1,9,16,36,64]
```

**예시 3:**
```
Input: drifts = [2,3,5,7]
Output: [4,9,25,49]
Explanation: Every value is non-negative, so squaring keeps the order.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$sort-latte-squared$S$);

-- sort-recycle-bins
UPDATE problem_translations SET
    description = $KO$`supplies`는 `0`(종이), `1`(플라스틱), `2`(금속)만 들어 있는 정수 배열입니다. 모든 `0`이 앞쪽에, 그 다음 `1`, 마지막에 `2`가 오도록 **제자리에서** 재배치하세요.

라이브러리 정렬 함수는 사용하지 않습니다. 반환값은 없으며, 호출한 쪽에서 이후에 `supplies`를 직접 확인합니다.

**예시 1:**
```
Input: supplies = [1,2,0,2,1,0,1]
Output: [0,0,1,1,1,2,2]
Explanation: Two paper codes, three plastic codes, then two metal codes.
```

**예시 2:**
```
Input: supplies = [2,1,0]
Output: [0,1,2]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$sort-recycle-bins$S$);

-- space-cookie-bakes
UPDATE problem_translations SET
    description = $KO$문자열 `cookies`가 주어졌을 때, 인접한 두 글자가 서로 같지 않도록 글자를 재배열하세요. 가능한 배열 중 아무거나 하나를 반환하고, 그런 배열이 불가능하면 `""`를 반환합니다.

**예시 1:**
```
Input: cookies = "bread"
Output: "brade"
Explanation: Any arrangement with no two equal adjacent letters is accepted — e.g. "brade" or "dabre".
```

**예시 2:**
```
Input: cookies = "aaaab"
Output: ""
Explanation: The letter 'a' appears 4 times in a length-5 string, so any arrangement must place two 'a's next to each other.
```

**예시 3:**
```
Input: cookies = "flour"
Output: "flour"
Explanation: All letters are distinct, so the input itself is valid.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$space-cookie-bakes$S$);

-- spawn-code-ladder
UPDATE problem_translations SET
    description = $KO$소문자로 이루어진 스폰 태그를 한 번에 한 글자씩 바꿔 나갑니다. 중간 단계의 모든 태그는 `codeBank` 안에 있어야 합니다.

길이가 같은 `startCode`와 `targetCode`가 주어졌을 때, `startCode`에서 `targetCode`까지 이어지는 가장 짧은 연쇄에 포함된 태그의 개수를 반환하세요. 각 단계에서는 정확히 한 글자만 바꿀 수 있으며, 첫 태그를 제외한 이후의 모든 태그는 `codeBank`에 있어야 합니다. `startCode`는 `codeBank`에 없어도 되지만, `targetCode`는 반드시 포함되어 있어야 합니다. 가능한 연쇄가 없으면 `0`을 반환합니다.

**예시 1:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pot","pat"]
Output: 3
Explanation: pet -> pit -> pot changes one letter per step and every stop is in codeBank.
```

**예시 2:**
```
Input: startCode = "pet", targetCode = "pot", codeBank = ["pit","pat"]
Output: 0
Explanation: "pot" isn't in codeBank, so no chain can end there.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$spawn-code-ladder$S$);

-- spiral-shelf-walk
UPDATE problem_translations SET
    description = $KO$`m x n` 격자 `board`가 주어졌을 때, 값들을 나선 순서대로 반환하세요. 맨 윗줄을 가로질러 이동한 뒤 오른쪽 끝 열을 따라 내려가고, 다시 맨 아랫줄을 되짚어 왼쪽 끝 열을 타고 올라온 다음, 안쪽으로 한 칸 들어가 같은 패턴을 반복합니다. 모든 칸은 정확히 한 번씩 방문합니다.

**예시 1:**
```
Input: board = [[1,2],[3,4]]
Output: [1,2,4,3]
```

**예시 2:**
```
Input: board = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
Output: [5,6,7,10,13,16,15,14,11,8,9,12]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$spiral-shelf-walk$S$);

-- split-candy-bar
UPDATE problem_translations SET
    description = $KO$길이가 `span`인 캔디 바를, 각 조각의 길이가 양의 정수인 둘 이상의 연속 조각으로 쪼개려 합니다. 분할의 점수는 각 조각 길이들의 곱입니다.

가능한 모든 분할 중 최대 곱을 반환하는 `splitProductMax(span)`을 구현하세요.

**예시 1:**
```
Input: span = 5
Output: 6
Explanation: The best split is 5 = 2 + 3, giving 2 * 3 = 6. All other splits (1+4, 1+1+3, 1+2+2, 1+1+1+2, 1+1+1+1+1) score lower.
```

**예시 2:**
```
Input: span = 11
Output: 54
Explanation: The best split is 11 = 3 + 3 + 3 + 2, giving 3 * 3 * 3 * 2 = 54. Splits like 3+4+4 yield 48 and 3+3+5 yield 45.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$split-candy-bar$S$);

-- split-sticker-runs
UPDATE problem_translations SET
    description = $KO$문자열 `stickers`를 가능한 한 적은 수의 연속된 조각으로 나누되, 서로 다른 글자는 반드시 하나의 조각 안에만 등장해야 합니다. 나눈 조각들을 이어 붙이면 원래 `stickers`와 같아야 합니다.

각 조각의 길이를 순서대로 반환하세요.

**예시 1:**
```
Input: stickers = "mnopmpoqrqrts"
Output: [7,4,1,1]
Explanation: 'm', 'n', 'o', 'p' all live inside the first 7 characters. 'q' and 'r' fill positions 7..10. 't' and 's' each appear once.
```

**예시 2:**
```
Input: stickers = "xyzzyx"
Output: [6]
Explanation: 'x' bookends the strip, pulling 'y' and 'z' into the same chunk, so it's all one piece.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$split-sticker-runs$S$);

-- split-ticket-pile
UPDATE problem_translations SET
    description = $KO$`tickets[i]`의 각 티켓에는 정수형 작업량 점수가 매겨져 있습니다. 이 티켓 더미를 합계가 같은 두 개의 서로 겹치지 않는 그룹으로 나눌 수 있는지 판단하세요.

그렇게 나눌 수 있으면 `true`, 아니면 `false`를 반환하는 `canSplitLoads(tickets)`를 구현합니다.

**예시 1:**
```
Input: tickets = [3,1,1,2,2,1]
Output: true
Explanation: Total is 10, so each person needs 5. One split: {3, 2} for Alice and {1, 1, 2, 1} for Bob.
```

**예시 2:**
```
Input: tickets = [2,2,3,5]
Output: false
Explanation: Total is 12, so each would need 6, but no subset of {2, 2, 3, 5} sums to 6.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$split-ticket-pile$S$);

-- spot-duplicate-locker
UPDATE problem_translations SET
    description = $KO$담임 반 학생들에게 사물함 번호를 나눠주려 하는데, 혹시라도 같은 번호가 두 번 배정됐는지 먼저 확인하고 싶습니다. 배정된 번호가 담긴 정수 배열 `lockers`가 주어졌을 때, 반복되는 번호가 하나라도 있으면 `true`, 모두 다르면 `false`를 반환하도록 `detectClash`를 구현하세요.

**예시 1:**
```
Input: lockers = [7,2,9,7]
Output: true
Explanation: The number 7 shows up at index 0 and index 3.
```

**예시 2:**
```
Input: lockers = [11,22,33,44]
Output: false
Explanation: Every locker number is distinct.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$spot-duplicate-locker$S$);

-- sum-skill-tree-codes
UPDATE problem_translations SET
    description = $KO$어떤 RPG는 캐릭터의 스킬 트리를 한 자리 숫자(`0`~`9`)가 담긴 이진 트리로 저장합니다. 루트에서 리프까지 내려가는 각 경로의 숫자들을 순서대로 이어 붙이면 하나의 정수(빌드 코드)가 됩니다.

`root`가 주어졌을 때, 루트에서 리프까지의 모든 경로가 만드는 빌드 코드들의 합을 반환하는 `totalZoneCodes`를 구현하세요.

**예시 1:**
```
Input: root = [2,5,8]
Output: 53
Explanation: Path 2 -> 5 spells 25 and path 2 -> 8 spells 28. Total = 25 + 28 = 53.
```

**예시 2:**
```
Input: root = [3,6,1,4,0]
Output: 755
Explanation: 3 -> 6 -> 4 = 364, 3 -> 6 -> 0 = 360, 3 -> 1 = 31. Total = 364 + 360 + 31 = 755.
```

**예시 3:**
```
Input: root = [9]
Output: 9
Explanation: A single node is both root and leaf, giving one code of 9.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$sum-skill-tree-codes$S$);

-- swap-print-pairs
UPDATE problem_translations SET
    description = $KO$사무실 인쇄 대기열은 작업 id를 담은 연결 리스트입니다. 대기열에서 인접한 두 작업끼리 짝을 지어 자리를 바꾸되, 작업 개수가 홀수라면 마지막 하나는 그대로 둡니다.

`swapQueuePartners(head)`를 구현해 `next` 포인터만 다시 연결하는 방식으로 인접한 짝끼리 자리를 바꾸고, 새 헤드를 반환하세요. 노드에 들어 있는 값 자체는 바꾸지 말고 링크만 수정해야 합니다.

**예시 1:**
```
Input: head = [11,22,33,44]
Output: [22,11,44,33]
Explanation: Pairs (11,22) and (33,44) trade places.
```

**예시 2:**
```
Input: head = [8,3]
Output: [3,8]
Explanation: The single pair is swapped.
```

**예시 3:**
```
Input: head = [6,9,15]
Output: [9,6,15]
Explanation: The first pair swaps; job 15 has no partner and keeps its spot.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$swap-print-pairs$S$);

-- task-cooldown-planner
UPDATE problem_translations SET
    description = $KO$사무실 공용 프린터는 한 슬롯에 작업을 하나씩만 처리하고, 각 작업에는 보낸 사람의 라벨이 붙어 있습니다. 같은 라벨의 작업은 `n` 슬롯 이내에 다시 돌릴 수 없으며, 각 슬롯은 작업을 하나 인쇄하거나 그냥 비워 둘 수 있고 작업 순서는 자유롭게 정할 수 있습니다.

`jobs`와 `n`이 주어졌을 때, 쿨다운 규칙을 지키면서 모든 작업을 인쇄하는 데 필요한 최소 슬롯 수를 반환하세요.

**예시 1:**
```
Input: jobs = ["P","P","P","P","Q","Q"], n = 3
Output: 13
Explanation: One valid schedule is P -> Q -> idle -> idle -> P -> Q -> idle -> idle -> P -> idle -> idle -> idle -> P, using 13 slots.
```

**예시 2:**
```
Input: jobs = ["A","B","C","A","B","D"], n = 1
Output: 6
Explanation: The order A -> B -> C -> A -> B -> D already separates identical labels by at least 1 slot, so no idle slots are needed.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$task-cooldown-planner$S$);

-- ticket-plus-or-minus
UPDATE problem_translations SET
    description = $KO$팀이 백로그의 티켓들을 하나씩 처리하고 있고, 각 티켓에는 포인트 값이 매겨져 있습니다. 각 티켓의 포인트를 팀 점수에 **더하거나** **빼서** 반영합니다. 배열 `tickets`와 정수 `target`이 주어졌을 때, 순점수가 정확히 `target`이 되도록 +/− 부호를 배정하는 경우의 수를 세어 반환하세요.

이 개수를 반환하도록 `partitionTankDoses`를 구현하세요.

**예시 1:**
```
Input: tickets = [2,2,2,2], target = 4
Output: 4
Explanation: Net +4 means 3 tickets added and 1 subtracted; 4 choices for which is subtracted.
```

**예시 2:**
```
Input: tickets = [4,6,8], target = 10
Output: 1
Explanation: The only net +10 assignment is -4 + 6 + 8 = 10.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$ticket-plus-or-minus$S$);

-- timestamp-value-store
UPDATE problem_translations SET
    description = $KO$길드 협동 게임은 플레이어의 상태 태그를 타임스탬프가 찍힌 체크포인트마다 자동 저장합니다. 특정 시점에 플레이어의 태그가 무엇이었는지 조회할 수 있도록, 태그 스냅샷을 저장하고 시점 질의에 답하는 `TimestampedStore`를 구현하세요.

- `TimestampedStore()` — 빈 저장소를 생성합니다.
- `void write(String key, String value, int timestamp)` — `timestamp` 시점에 `key`의 값으로 `value`를 기록합니다. 동일한 `key`에 대한 연속된 `write` 호출의 `timestamp`는 항상 엄격히 증가한다고 보장됩니다.
- `String readAt(String key, int timestamp)` — `key`에 대해 기록된 값 중 타임스탬프가 `timestamp` 이하인 가장 최근 값을 반환하고, 해당하는 기록이 없으면 `""`을 반환합니다.

조회 시점이 두 기록 사이에 있다면 바로 직전 기록의 값을 반환하면 됩니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$timestamp-value-store$S$);

-- top-espresso-machines
UPDATE problem_translations SET
    description = $KO$한 카페가 아침 러시 동안 사용된 에스프레소 머신을 모두 `checkIns`에 기록합니다. 배열 속 숫자는 각각 머신 id입니다. 매니저는 가장 많이 사용된 머신 `k`대를 휴게실 화이트보드에 붙이고 싶어 합니다.

`checkIns`에서 가장 자주 등장하는 머신 id `k`개를 반환하는 `busiestMachines`를 구현하세요. 반환 순서는 자유이고, 상위 `k`개는 유일하게 결정된다고 보장됩니다.

**예시 1:**
```
Input: checkIns = [4,4,4,7,7,5], k = 2
Output: [4,7]
Explanation: Machine 4 was used 3 times, machine 7 twice, machine 5 once. The top 2 are 4 and 7.
```

**예시 2:**
```
Input: checkIns = [9], k = 1
Output: [9]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$top-espresso-machines$S$);

-- top-raid-score
UPDATE problem_translations SET
    description = $KO$길드가 레이드를 막 끝내서 모두의 데미지 수치가 `scores`에 담겨 있습니다. 동점도 각 자리를 차지하는 것으로 보고, `k`번째로 높은 점수를 반환하세요. 예를 들어 `[8, 3, 5, 5]`에서 1등은 `8`, 2등은 `5`입니다.

`scores`를 내림차순으로 정렬했을 때 `k`번째 위치의 값을 반환하도록 `findBrightestTargets(scores, k)`를 구현하세요.

**예시 1:**
```
Input: scores = [7,2,9,4,9,6,3], k = 3
Output: 7
Explanation: Sorted descending: [9,9,7,6,4,3,2]. The 3rd entry is 7.
```

**예시 2:**
```
Input: scores = [12,5,8,5,8,15,3,11], k = 4
Output: 8
Explanation: Sorted descending: [15,12,11,8,8,5,5,3]. The 4th entry is 8.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$top-raid-score$S$);

-- topic-catalog-lca
UPDATE problem_translations SET
    description = $KO$학교 도서관의 주제 카탈로그는 **이진 탐색 트리**로 관리됩니다. 각 노드는 주제 ID를 담고 있고, ID가 작으면 왼쪽, 크면 오른쪽 서브트리에 위치합니다. `root`와 두 주제 `p`, `q`가 주어졌을 때, 두 주제를 모두 서브트리에 포함하는 가장 깊은 주제를 반환하세요.

한 노드는 자기 자신의 자손으로도 간주하므로, 한 주제가 다른 주제의 조상이라면 그 조상을 그대로 반환하면 됩니다. `p`와 `q`는 모두 트리에 존재하며 서로 다른 노드임이 보장됩니다.

**예시 1:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 8, q = 12
Output: 10
Explanation: 8 sits under the left side of 10 (via 5), and 12 sits under the right side of 10 (via 15). 10 is the deepest topic containing both.
```

**예시 2:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 25, q = 40
Output: 30
Explanation: Both topics sit in the right subtree of 20. Their lowest shared ancestor is 30.
```

**예시 3:**
```
Input: root = [20,10,30,5,15,25,40,null,8,12,18], p = 10, q = 15
Output: 10
Explanation: 15 lives beneath 10, so 10 is itself the shared ancestor.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$topic-catalog-lca$S$);

-- trending-chat-topics
UPDATE problem_translations SET
    description = $KO$반 단톡방이 쉴 새 없이 울리는 와중에 오늘 메시지에서 가장 많이 언급된 주제 태그 `k`개를 뽑아 보려 합니다. 등장 횟수가 같다면 알파벳 오름차순으로 우선순위를 정합니다.

등장 횟수 내림차순, 동점 시 라벨 오름차순으로 정렬된 상위 `k`개의 태그를 반환하도록 `rankTrendingTopics(topics, k)`를 구현하세요.

**예시 1:**
```
Input: topics = ["climate","climate","market","sports","market","climate","weather"], k = 2
Output: ["climate","market"]
Explanation: "climate" appears 3 times and "market" appears 2 times — the two loudest tags.
```

**예시 2:**
```
Input: topics = ["tech","tech","film","film","music","books","music"], k = 3
Output: ["film","music","tech"]
Explanation: "film", "music", and "tech" all appear twice, so they're returned in alphabetical order.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$trending-chat-topics$S$);

-- two-menu-sum
UPDATE problem_translations SET
    description = $KO$비내림차순으로 정렬된 **1-인덱스** 메뉴판 `menuPrice`가 있고, 지갑에는 정확히 `budget`만큼이 있습니다. 가격의 합이 `budget`과 같아지는 서로 다른 두 메뉴를 찾아 그 번호를 `[item1, item2]` 형태로 반환하세요. 이때 `1 <= item1 < item2 <= menuPrice.length`를 만족해야 합니다.

조건을 만족하는 쌍은 정확히 하나뿐이며, 입력 외에는 상수 크기의 추가 공간만 사용해야 합니다.

**예시 1:**
```
Input: menuPrice = [12,30,45,58,70,85], budget = 100
Output: [2,5]
Explanation: Item 2 costs 30 and item 5 costs 70, which together match the 100 budget.
```

**예시 2:**
```
Input: menuPrice = [5,14,22,40], budget = 54
Output: [2,4]
Explanation: Item 2 is 14 and item 4 is 40; 14 + 40 = 54.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$two-menu-sum$S$);

-- two-shift-baristas
UPDATE problem_translations SET
    description = $KO$`0`부터 `n - 1`까지 번호가 매겨진 `n`명의 바리스타를 정확히 두 교대로 나누되, 충돌 관계인 쌍이 같은 교대에 묶이지 않도록 해야 합니다. `conflicts[i]`에는 바리스타 `i`와 같이 일할 수 없는 동료들의 번호가 들어 있으며, 이 관계는 대칭이고 그래프가 여러 덩어리로 분리돼 있을 수도 있습니다.

이러한 분할이 가능하면 `true`, 불가능하면 `false`를 반환하는 `splitIntoTwoShifts(conflicts)`를 구현하세요.

**예시 1:**
```
Input: conflicts = [[1],[0,2],[1,3],[2]]
Output: true
Explanation: Put baristas 0 and 2 on morning and 1 and 3 on evening; every conflict crosses shifts.
```

**예시 2:**
```
Input: conflicts = [[1,2],[0,2],[0,1]]
Output: false
Explanation: Baristas 0, 1, and 2 all conflict, so any two-shift split forces two of them together.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$two-shift-baristas$S$);

-- unique-genre-window
UPDATE problem_translations SET
    description = $KO$문자열 `queue`의 각 글자는 장르 태그를 나타냅니다. 서로 다른 문자가 최대 `k`개만 포함되는 가장 긴 연속 부분 문자열의 길이를 반환하세요. `k`가 0이면 0을 반환합니다.

**예시 1:**
```
Input: queue = "yyxzxxz", k = 2
Output: 5
Explanation: "xzxxz" only uses x and z and has length 5.
```

**예시 2:**
```
Input: queue = "rrrrrr", k = 1
Output: 6
Explanation: Every tag is the same genre, so the whole string fits inside one distinct tag.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$unique-genre-window$S$);

-- username-trie
UPDATE problem_translations SET
    description = $KO$비디오 게임 유저명 등록부를 위한 자동완성 색인을 만들려고 합니다. 이 색인은 두 가지 질문에 빠르게 답해야 합니다. 주어진 이름이 완전한 유저명으로 등록돼 있는지, 그리고 주어진 접두어로 시작하는 유저명이 하나라도 존재하는지입니다.

`PrefixIndex`를 구현하세요.

- `PrefixIndex()` — 빈 색인을 생성합니다.
- `void insert(String word)` — `word`를 완전한 유저명으로 등록합니다. 중복 등록해도 문제없습니다.
- `boolean search(String word)` — `word`가 완전한 유저명으로 등록된 경우에만 `true`를 반환합니다.
- `boolean startsWith(String prefix)` — 등록된 유저명 중 `prefix`로 시작하는 것이 있으면 `true`를 반환합니다.

**예시 1:**
```
Input:
["PrefixIndex", "insert", "search", "search", "startsWith", "insert", "search"]
[[], ["apple"], ["apple"], ["app"], ["app"], ["app"], ["app"]]
Output: [null, null, true, false, true, null, true]
```

`"apple"`을 등록하면 `search("apple")`은 `true`가 되지만, `"app"`은 아직 접두어일 뿐이라 `search("app")`은 `false`입니다. 반면 `startsWith("app")`은 `true`입니다. 이후 `"app"` 자체를 등록하면 `search("app")`도 `true`가 됩니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$username-trie$S$);

-- valid-brackets
UPDATE problem_translations SET
    description = $KO$문자열 `tape`은 `(`, `)`, `[`, `]`, `{`, `}` 여섯 가지 괄호 문자로만 이루어져 있습니다. 괄호들이 올바르게 중첩돼 있으면 `true`, 아니면 `false`를 반환하세요. 올바른 중첩이란 모든 여는 괄호가 같은 종류의 닫는 괄호로 닫히고, 바깥 괄호가 안쪽 괄호보다 먼저 닫히지 않는 경우를 말합니다.

**예시 1:**
```
Input: tape = "{[()]}"
Output: true
Explanation: Each opener is closed by the matching type in the correct nested order.
```

**예시 2:**
```
Input: tape = "{[(])}"
Output: false
Explanation: The `(` is closed by `]` before its matching `)`, breaking the nesting.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$valid-brackets$S$);

-- valid-number-puzzle
UPDATE problem_translations SET
    description = $KO$반 친구의 9x9 숫자 퍼즐을 검토하고 있습니다. `grid`는 9개의 3x3 박스로 나뉘며, 각 칸에는 `1`부터 `9`까지의 숫자 또는 빈 칸을 뜻하는 `.`이 들어 있습니다. 규칙은 하나입니다. 같은 숫자가 같은 행, 같은 열, 같은 3x3 박스 안에서 두 번 이상 나오면 안 됩니다. 빈 칸은 검사 대상에서 제외합니다.

채워진 모든 칸이 세 가지 규칙을 전부 만족하면 `true`, 아니면 `false`를 반환하세요. 퍼즐이 풀 수 있는지 여부는 상관없고, 이미 채워진 칸들만 검사합니다.

**예시 1:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","3","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: true
Explanation: Every row, column, and box holds at most one of each digit, so the grid is valid.
```

**예시 2:**
```
Input: grid =
[[".",".",".",".",".",".",".",".","."]
,[".","1",".",".","2",".",".","1","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","4",".",".","5",".",".","6","."]
,[".",".",".",".",".",".",".",".","."]
,[".",".",".",".",".",".",".",".","."]
,[".","7",".",".","8",".",".","9","."]
,[".",".",".",".",".",".",".",".","."]]
Output: false
Explanation: Row 1 has `1` in two columns, which breaks the uniqueness rule.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$valid-number-puzzle$S$);

-- valid-pet-tree
UPDATE problem_translations SET
    description = $KO$펫 카페 지도에 `0`부터 `n - 1`까지 번호가 매겨진 `n`개의 카페가 있습니다. `lanes`의 각 항목 `[u, v]`는 카페 `u`와 카페 `v`를 잇는 양방향 산책로를 의미합니다. `n`과 `lanes`가 완전히 연결되어 있으면서 사이클이 없는 구조를 이루면 — 즉 모든 카페가 서로 도달 가능하고 어디에도 순환 경로가 없다면 — `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: n = 6, lanes = [[0,1],[0,2],[1,3],[1,4],[2,5]]
Output: true
Explanation: All 6 cafes are reachable from cafe 0, and the 5 paths never form a loop.
```

**예시 2:**
```
Input: n = 4, lanes = [[0,1],[1,2],[2,0],[0,3]]
Output: false
Explanation: Cafes 0, 1, and 2 form a loop, so the map isn't loop-free.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$valid-pet-tree$S$);

-- valid-score-bst
UPDATE problem_translations SET
    description = $KO$오락실의 플레이어 점수를 이진 트리에 저장해 두었습니다. 이 트리는 BST여야 합니다. 즉, 왼쪽 서브트리의 모든 노드는 조상 노드보다 **엄격히 작고**, 오른쪽 서브트리의 모든 노드는 조상 노드보다 **엄격히 커야** 합니다. 모든 점수는 서로 다릅니다.

트리의 `root`가 주어졌을 때, 직계 자식뿐 아니라 서브트리 전체에 걸쳐 BST 규칙이 지켜지면 `true`, 그렇지 않으면 `false`를 반환하는 `verifyWardOrder(root)`를 구현하세요.

**예시 1:**
```
Input: root = [50,30,70,20,40,60,80]
Output: true
Explanation: Every left subtree stays below its ancestor and every right subtree stays above.
```

**예시 2:**
```
Input: root = [10,5,15,null,null,6,20]
Output: false
Explanation: 6 lives in the right subtree of root 10, but 6 < 10, so the rule breaks.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$valid-score-bst$S$);

-- valid-slogan-palindrome
UPDATE problem_translations SET
    description = $KO$범퍼 스티커 슬로건 `phrase`가 주어집니다. 알파벳을 모두 소문자로 바꾸고 알파벳·숫자가 아닌 문자를 전부 제거했을 때, 남은 문자열이 앞에서 읽어도 뒤에서 읽어도 똑같으면 `true`, 아니면 `false`를 반환하세요. 빈 문자열도 회문으로 간주합니다.

**예시 1:**
```
Input: phrase = "Stacks: Level 2 level stack S"
Output: true
Explanation: After filtering, the phrase becomes "stackslevel2levelstacks", which mirrors itself.
```

**예시 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**예시 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$valid-slogan-palindrome$S$);

-- validate-homework-id
UPDATE problem_translations SET
    description = $KO$과제에서 쓰이는 작은 패턴 언어에서 `.`은 아무 문자 하나와 매치되고, `*`는 바로 앞 문자가 0번 이상 반복됨을 뜻합니다. 패턴은 ID의 앞부분이나 일부가 아니라 전체를 처음부터 끝까지 완전히 덮어야 합니다.

ID 문자열 `s`와 패턴 `p`가 주어졌을 때, `p`가 `s` 전체와 매치되면 `true`, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: s = "bbbc", p = "b*c"
Output: true
Explanation: `b*` consumes the three b's at the start, then `c` matches the trailing c, covering the full ID.
```

**예시 2:**
```
Input: s = "xyzw", p = "x.y"
Output: false
Explanation: The pattern describes only three characters and contains no `*` to stretch, so it cannot cover the four-character ID.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$validate-homework-id$S$);

-- verify-pizza-rotation
UPDATE problem_translations SET
    description = $KO$컨베이어 오븐의 슬롯마다 피자가 놓여 있고, 각 슬롯의 개수는 `trays`에 담겨 있습니다. 이 수열을 비내림차순(non-decreasing)으로 만들고 싶습니다.

**슬롯 하나를 임의의 정수로 바꾸는 연산을 최대 한 번**만 사용해서 `trays`를 비내림차순으로 만들 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: trays = [3,1,4,5]
Output: true
Explanation: Lowering the first slot to 1 gives [1,1,4,5], which is non-decreasing.
```

**예시 2:**
```
Input: trays = [6,4,2,3]
Output: false
Explanation: Two separate slots are out of order, so one tweak can't fix it.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$verify-pizza-rotation$S$);

-- verify-task-order
UPDATE problem_translations SET
    description = $KO$조별 과제에는 `0`부터 `numScenes - 1`까지 번호가 매겨진 `numScenes`개의 작업이 있습니다. `prereqs[i] = [a, b]`는 작업 `a`를 시작하려면 먼저 작업 `b`가 끝나 있어야 한다는 뜻입니다.

모든 작업을 완료할 수 있는 순서가 하나라도 존재하면 `true`, 의존 관계에 순환이 있어 불가능하면 `false`를 반환하세요.

**예시 1:**
```
Input: numScenes = 4, prereqs = [[1,0],[2,0],[3,1]]
Output: true
Explanation: Task `0` can go first, then `1` and `2` (which both only need `0`), and finally `3`. No circular dependency exists.
```

**예시 2:**
```
Input: numScenes = 3, prereqs = [[0,2],[2,1],[1,0]]
Output: false
Explanation: Task `0` needs `2`, `2` needs `1`, and `1` needs `0`. The three-way loop means no task can ever start first.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$verify-task-order$S$);

-- versioned-cells
UPDATE problem_translations SET
    description = $KO$샌드박스 게임용 세이브파일 기능을 구현하고 있습니다. 세상은 숫자 셀이 한 줄로 늘어선 형태로, 라이브 줄의 값을 수정할 수 있고, 언제든 스냅샷으로 얼려 두었다가 나중에 다시 볼 수 있습니다. 모든 셀의 초기값은 `0`이고, 스냅샷 id는 `0`부터 올라갑니다.

`VersionedCells` 클래스를 구현하세요.

- `VersionedCells(int length)` — 모든 셀을 `0`으로 초기화한 길이 `length`의 줄을 만들고, 스냅샷은 아직 없는 상태로 시작합니다.
- `void set(int index, int val)` — 라이브 줄의 `index` 위치 값을 `val`로 바꿉니다. 이미 저장된 스냅샷은 영향을 받지 않습니다.
- `int commit()` — 현재 라이브 줄을 새 스냅샷으로 얼리고 그 id를 반환합니다. 첫 호출은 `0`, 두 번째는 `1`과 같은 식으로 증가합니다.
- `int readAt(int index, int snapId)` — 스냅샷 `snapId`에서 셀 `index`가 가지고 있던 값을 반환합니다.

**예시:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // returns 0; snapshot 0 is [5, 0, 0]
cells.set(0, 6)       // live row is now [6, 0, 0]
cells.readAt(0, 0)    // 5 -- value of cell 0 in snapshot 0
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$versioned-cells$S$);

-- voucher-price-combos
UPDATE problem_translations SET
    description = $KO$카페 쿠폰으로 가격 합이 정확히 `voucher`와 같아지도록 항목들을 자유롭게 골라 담을 수 있습니다. `prices`는 서로 다른 양의 정수 가격들의 목록이고, 각 항목은 원하는 만큼 몇 번이든 담을 수 있습니다.

가격 합이 `voucher`와 같아지는 모든 서로 다른 장바구니를 반환하세요. 장바구니는 가격들의 리스트(같은 값 중복 가능)이며, 어느 한 가격이라도 등장 횟수가 다르면 서로 다른 장바구니로 봅니다. 반환 순서는 상관없습니다.

**예시 1:**
```
Input: prices = [2,4,5], voucher = 9
Output: [[2,2,5],[4,5]]
Explanation: 2 + 2 + 5 = 9 and 4 + 5 = 9 are the only two matching baskets.
```

**예시 2:**
```
Input: prices = [3,4,7], voucher = 10
Output: [[3,3,4],[3,7]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$voucher-price-combos$S$);

-- wildcard-lexicon
UPDATE problem_translations SET
    description = $KO$단어 타일 게임용 치트 단어 검사기를 만듭니다. 플레이어가 즐겨 쓰는 단어들을 저장해 두고, 나중에 추측 단어를 검사합니다. 추측에서 `.`은 알파벳 한 글자 아무거나 매칭되며, 저장된 단어 중 길이가 같고 위치별로 전부 맞아떨어지는 것이 하나라도 있으면 추측이 통과합니다.

`WildcardLexicon` 클래스를 구현하세요.

- `WildcardLexicon()` — 저장된 단어가 하나도 없는 상태로 시작합니다.
- `void enroll(String word)` — `word`를 저장합니다(영어 소문자만). 같은 단어를 여러 번 저장해도 괜찮습니다.
- `boolean match(String word)` — 와일드카드 규칙에 따라 저장된 단어 중 하나라도 `word`와 매칭되면 `true`, 아니면 `false`를 반환합니다. 저장된 단어가 없으면 `false`입니다.

`match`에 들어오는 입력은 영어 소문자와 `.`이 섞일 수 있고, `enroll`에는 `.`이 포함되지 않습니다. 두 메서드는 어떤 순서로든 호출될 수 있으며, `match` 호출은 저장된 단어 집합을 변경하지 않습니다.$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$wildcard-lexicon$S$);

-- word-break-chat
UPDATE problem_translations SET
    description = $KO$채팅 메시지 `headline`에서 공백이 전부 빠져 있고, `topics`에는 알려진 은어 목록이 들어 있습니다.

`headline`을 `topics`에 있는 단어(같은 단어를 여러 번 사용 가능)를 하나 이상 이어붙여서 만들 수 있으면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
Input: headline = "morningwire", topics = ["morning","wire"]
Output: true
Explanation: "morningwire" splits into "morning wire".
```

**예시 2:**
```
Input: headline = "topstoryalert", topics = ["top","story","alert"]
Output: true
Explanation: "topstoryalert" splits into "top story alert".
```

**예시 3:**
```
Input: headline = "breakingnews", topics = ["break","breaking","new","ing"]
Output: false
Explanation: Every prefix match leaves a suffix that can't be fully covered — "news" never appears as a prefix of any word, and neither does a trailing "s".
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$word-break-chat$S$);

-- word-hunt-board
UPDATE problem_translations SET
    description = $KO$단어 찾기 게임에서는 `m x n` 글자판 위에서 상하좌우로 인접한 칸들을 따라가며 단어를 그립니다. 같은 경로 안에서 동일한 칸을 두 번 사용할 수는 없습니다.

글자판 `board`와 목표 단어 `word`가 주어질 때, 각 칸을 최대 한 번만 사용하는 인접 칸들의 경로로 `word`를 정확히 만들 수 있으면 `true`, 아니면 `false`를 반환하는 `traceZonePath`를 구현하세요.

**예시 1:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PEAK"
Output: true
```

**예시 2:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "NOID"
Output: true
```

**예시 3:**
```
Input: board = [["P","R","B","A"],["E","N","O","L"],["A","T","I","D"],["K","R","M","U"]], word = "PARK"
Output: false
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$word-hunt-board$S$);

-- zero-out-rows-cols
UPDATE problem_translations SET
    description = $KO$퍼즐 게임에서 `0`이 적힌 타일이 있으면 그 타일이 속한 행과 열 전체가 지워집니다. `m x n` 격자 `board`가 주어지면, 원래 0이 있던 칸과 같은 행 또는 같은 열에 있는 모든 칸을 `0`으로 바꾸도록 **제자리에서(in-place)** 수정하세요.

같은 행과 열에 원래 0이 없었던 칸은 원래 값을 그대로 유지합니다.

**예시 1:**
```
Input: board = [[2,3],[4,5]]
Output: [[2,3],[4,5]]
Explanation: No zero tiles, so the board is unchanged.
```

**예시 2:**
```
Input: board = [[4,6,8],[2,0,5],[7,9,3]]
Output: [[4,0,8],[0,0,0],[7,0,3]]
Explanation: The zero is at row 1, column 1, so row 1 and column 1 are wiped.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$zero-out-rows-cols$S$);

-- zero-sum-trio
UPDATE problem_translations SET
    description = $KO$협동 게임에서는 각 플레이어의 점수 차이를 부호 있는 정수로 `deltas`에 기록합니다(음수는 뒤처짐, 양수는 앞섬).

서로 다른 세 플레이어의 `deltas` 값을 합해 정확히 0이 되는 모든 고유한 삼인방을 `[deltas[i], deltas[j], deltas[k]]` 형태로 반환하세요. 같은 값 조합은 가능한 인덱스가 여러 개여도 한 번만 포함되며, 반환 순서는 상관없습니다.

**예시 1:**
```
Input: deltas = [-3,1,2,-2,0,-1,1]
Output: [[-3,1,2],[-2,0,2],[-2,1,1],[-1,0,1]]
Explanation: Four distinct balanced trios exist; each sums to zero.
```

**예시 2:**
```
Input: deltas = [2,3,4]
Output: []
Explanation: Every delta is positive, so no trio sums to zero.
```

**예시 3:**
```
Input: deltas = [0,0,0,0]
Output: [[0,0,0]]
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$zero-sum-trio$S$);

-- zigzag-yearbook-order
UPDATE problem_translations SET
    description = $KO$졸업 앨범 사진을 찍으려고 반 친구들이 이진 트리 모양으로 줄을 섰습니다. 사진사는 이름을 한 줄씩 읽는데, 줄마다 방향을 번갈아 뒤집어서 부릅니다.

`root`가 주어지면, 각 레벨의 노드 값을 지그재그 순서로 묶어 반환하세요. 맨 윗줄은 왼쪽에서 오른쪽으로, 그 다음 줄은 오른쪽에서 왼쪽으로, 또 그 다음 줄은 다시 왼쪽에서 오른쪽으로 진행합니다. 각 레벨은 내부 리스트이고 바깥 리스트는 위에서 아래 순서이며, 트리가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
Input: root = [5,3,7,2,9,6,8]
Output: [[5],[7,3],[2,9,6,8]]
Explanation: Row 0 left-to-right gives [5]; row 1 right-to-left gives [7,3]; row 2 left-to-right gives [2,9,6,8].
```

**예시 2:**
```
Input: root = [4]
Output: [[4]]
Explanation: A single student gets their own row.
```$KO$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $S$zigzag-yearbook-order$S$);

