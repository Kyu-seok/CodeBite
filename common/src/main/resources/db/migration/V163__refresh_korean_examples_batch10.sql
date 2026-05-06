-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 10 (problems #91-#100)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (source, target, fuel, energy,
-- drain, slots, newSlot, classes, visits, blocks, stops, k, board,
-- sensorMask, start, end, arrive, leave) stay verbatim. First mention of
-- each variable in Korean prose is paired with a Korean noun phrase
-- describing its role. Constraint identifiers are aligned with the
-- canonical English parameter names from V135 / V137 / V133 source
-- descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'min-cheat-code-edits', 'fewest-tile-jumps', 'pick-charging-start', 'slot-a-meeting',
      'drop-conflicting-classes', 'peak-table-demand', 'crush-heaviest-blocks', 'nearest-cafe-stops',
      'spiral-shelf-walk', 'online-friend-mask'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. min-cheat-code-edits
((SELECT id FROM problems WHERE slug = 'min-cheat-code-edits'), 'ko',
 $$치트 코드 최소 편집$$,
 $$게임 위키에 새로 올라온 버전에 맞춰 소문자 치트 코드를 다시 입력하고 있습니다. 키 한 번에 글자 하나를 끼워 넣거나, 지우거나, 다른 글자로 바꿀 수 있습니다.

이전 코드 `source`와 새 코드 `target`이 주어질 때, `source`를 `target`으로 바꾸는 데 필요한 최소 키 입력 횟수를 반환하세요.

**예시 1:**
```
입력: source = "coral", target = "carol"
출력: 2
설명: 인덱스 1의 `'o'`를 `'a'`로 바꾸고, 인덱스 3의 `'a'`를 `'o'`로 바꾸면 됩니다.
```

**예시 2:**
```
입력: source = "sunset", target = "sunrise"
출력: 3
설명: 끝의 `'t'`를 지우고(sunset -> sunse), `'n'` 뒤에 `'r'`을 끼워 넣고(sunse -> sunrse), 그 `'r'` 뒤에 `'i'`를 끼워 넣으면(sunrse -> sunrise) 됩니다.
```$$,
 $$- `0 <= source.length, target.length <= 500`
- `source`와 `target`은 영어 소문자로만 이루어져 있습니다.$$),

-- 2. fewest-tile-jumps
((SELECT id FROM problems WHERE slug = 'fewest-tile-jumps'), 'ko',
 $$타일 최소 점프$$,
 $$`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 타일이 있는 플랫포머에서 시작 타일은 `0`번입니다. 배열 `fuel`은 각 타일에서 한 번에 앞으로 뛸 수 있는 최대 거리를 나타냅니다. 즉, 타일 `i`에서는 `[i + 1, i + fuel[i]]` 범위의 어떤 타일로든 한 번에 갈 수 있습니다.

`minVanHops(fuel)`을 구현해, 마지막 타일 `n - 1`에 도달하기 위해 필요한 최소 점프 횟수를 반환하세요. 레벨은 항상 클리어 가능합니다.

**예시 1:**
```
입력: fuel = [1,4,2,1,3,1,2]
출력: 3
설명: 타일 0에서 타일 1로 점프합니다. 타일 1에서는 타일 5까지 갈 수 있으니 타일 4로 점프합니다. 타일 4에서 타일 6, 즉 목적지에 닿습니다.
```

**예시 2:**
```
입력: fuel = [3,1,1,4,2,1]
출력: 2
설명: 타일 0에서 곧장 타일 3으로 점프합니다(사거리 3 안). 타일 3에서는 타일 7까지 닿을 수 있어 타일 5를 포함합니다.
```$$,
 $$- `1 <= fuel.length <= 2 * 10^3`
- `0 <= fuel[i] <= 1000`
- 마지막 타일은 타일 `0`에서 반드시 도달 가능합니다.$$),

-- 3. pick-charging-start
((SELECT id FROM problems WHERE slug = 'pick-charging-start'), 'ko',
 $$출발 충전소 고르기$$,
 $$`n`개의 휴게소가 한 바퀴를 이루는 순환 도로가 있습니다. 휴게소 `i`에서는 `energy[i]` 단위만큼 휴대폰을 충전할 수 있고, 다음 휴게소까지 운전하는 데 `drain[i]` 단위가 소모됩니다. 휴대폰은 빈 상태로 출발하며, 시계 방향으로 한 바퀴를 도는 동안 배터리가 0 미만으로 떨어져서는 안 됩니다.

유효한 출발 휴게소의 인덱스를 반환하고, 한 바퀴를 완주할 수 없으면 `-1`을 반환하세요. 유효한 출발점이 존재한다면 그 값은 유일합니다.

**예시 1:**
```
입력: energy = [4,6,1,3,5], drain = [3,5,2,2,6]
출력: 0
```

**예시 2:**
```
입력: energy = [5,2,8], drain = [6,4,7]
출력: -1
```$$,
 $$- `n == energy.length == drain.length`
- `1 <= n <= 2 * 10^5`
- `0 <= energy[i], drain[i] <= 8000`$$),

-- 4. slot-a-meeting
((SELECT id FROM problems WHERE slug = 'slot-a-meeting'), 'ko',
 $$회의 일정 끼워 넣기$$,
 $$팀 캘린더의 회의 목록 `slots`는 `[start, end]` 항목들로 이루어져 있고, `start` 기준으로 정렬되어 있으며 서로 겹치지 않습니다. 새로운 회의 `newSlot = [start, end]`이 들어와서 이를 끼워 넣어야 합니다.

`newSlot`을 `slots`에 추가해 결과가 여전히 정렬되어 있고 서로 겹치지 않도록 만드세요. `newSlot`과 맞닿거나 겹치는 항목은 하나의 항목으로 병합한 뒤 갱신된 목록을 반환합니다.

**예시 1:**
```
입력: slots = [[1,4],[7,10]], newSlot = [3,6]
출력: [[1,6],[7,10]]
설명: newSlot이 [1,4]와 겹치므로 [1,6]으로 병합됩니다. [7,10]은 그대로입니다.
```

**예시 2:**
```
입력: slots = [[2,4],[6,8],[10,12],[14,18]], newSlot = [5,11]
출력: [[2,4],[5,12],[14,18]]
설명: newSlot이 [6,8]과 [10,12]를 모두 흡수해 [5,12]가 됩니다.
```$$,
 $$- `0 <= slots.length <= 8000`
- `slots[i].length == 2`
- `0 <= start <= end <= 8 * 10^4`
- `slots`는 `start` 오름차순으로 정렬되어 있으며 서로 겹치지 않습니다.
- `newSlot.length == 2`$$),

-- 5. drop-conflicting-classes
((SELECT id FROM problems WHERE slug = 'drop-conflicting-classes'), 'ko',
 $$충돌 수업 빼기$$,
 $$다음 학기 수업을 고르고 있는데, 한 번에 한 수업만 들을 수 있습니다. `classes`의 각 수업은 `[start, end]` 형태로 분 단위로 표현됩니다. 두 수업은 시간대가 실제로 겹칠 때만 충돌하며, 한 수업이 끝나는 바로 그 시각에 다음 수업이 시작되는 것은 괜찮습니다.

남은 수업들이 서로 겹치지 않도록 빼야 하는 수업의 **최소** 개수를 반환하세요.

**예시 1:**
```
입력: classes = [[10,20],[12,18],[22,30]]
출력: 1
설명: [10,20]과 [22,30]을 남기고, 첫 번째 시간 안에 들어가는 [12,18]을 뺍니다.
```

**예시 2:**
```
입력: classes = [[1,4],[1,4],[1,4],[1,4]]
출력: 3
설명: 같은 시간대에 네 수업이 몰려 있으니, 하나만 남기고 셋을 빼야 합니다.
```

**예시 3:**
```
입력: classes = [[1,5],[6,10]]
출력: 0
설명: 두 수업은 서로 떨어져 있어서 뺄 필요가 없습니다.
```$$,
 $$- `1 <= classes.length <= 2 * 10^5`
- `classes[i].length == 2`
- `-8 * 10^4 <= start < end <= 8 * 10^4`$$),

-- 6. peak-table-demand
((SELECT id FROM problems WHERE slug = 'peak-table-demand'), 'ko',
 $$피크 시간 테이블 수요$$,
 $$카페에서 가장 붐빌 때 테이블이 몇 개 필요한지 알고 싶습니다. `visits[i] = [arrive, leave]`는 어떤 팀이 자리에 앉은 시각과 일어선 시각(분)을 뜻합니다. 한 팀은 테이블을 반열린 구간 `[arrive, leave)` 동안 점유하므로, 이전 팀이 떠난 바로 그 분에 새 팀이 같은 테이블을 바로 쓸 수 있습니다.

모든 팀이 머무는 동안 각자 자리를 차지할 수 있도록, 카페에 필요한 테이블의 **최소** 개수를 반환하세요.

**예시 1:**
```
입력: visits = [[60,180],[90,150],[120,240],[200,300]]
출력: 3
설명: 120분과 150분 사이에는 세 팀이 동시에 앉아 있으므로 테이블이 세 개 필요합니다.
```

**예시 2:**
```
입력: visits = [[500,600],[100,200]]
출력: 1
설명: 두 팀의 시간대가 전혀 겹치지 않으므로 테이블 한 개면 충분합니다.
```$$,
 $$- `1 <= visits.length <= 8000`
- `0 <= arrive < leave <= 2 * 10^5`$$),

-- 7. crush-heaviest-blocks
((SELECT id FROM problems WHERE slug = 'crush-heaviest-blocks'), 'ko',
 $$가장 무거운 블록 부수기$$,
 $$아케이드 기계가 가장 무거운 블록 두 개를 계속 부딪쳐서 부숩니다. 두 블록의 무게가 `x`, `y`이고 `x <= y`라고 할 때,

- `x == y`이면 두 블록 모두 산산조각 납니다.
- `x != y`이면 가벼운 블록은 사라지고, 무거운 블록은 `y - x` 무게로 줄어듭니다.

블록이 하나 이하로 남을 때까지 이 과정을 반복합니다. 블록 무게 배열 `blocks`가 주어질 때, 마지막에 살아남은 블록의 무게를 반환하고, 더미가 비어 있으면 `0`을 반환하세요.

**예시 1:**
```
입력: blocks = [3,6,4,9,5,2]
출력: 1
설명:
9와 6을 부딪치면 3이 남습니다; 더미는 [3,4,5,2,3]이 됩니다.
5와 4를 부딪치면 1이 남습니다; 더미는 [3,2,3,1]이 됩니다.
3과 3을 부딪치면 둘 다 사라집니다; 더미는 [2,1]이 됩니다.
2와 1을 부딪치면 1이 남습니다; 더미는 [1]이 됩니다.
```

**예시 2:**
```
입력: blocks = [9]
출력: 9
```$$,
 $$- `1 <= blocks.length <= 40`
- `1 <= blocks[i] <= 1500`$$),

-- 8. nearest-cafe-stops
((SELECT id FROM problems WHERE slug = 'nearest-cafe-stops'), 'ko',
 $$가장 가까운 카페 배달지$$,
 $$바리스타가 아침 배달 동선을 짭니다. 각 매장은 `[x, y]` 좌표에 있고 카페는 원점에 있습니다. 카페에서 가장 가까운 `k`개의 매장을 반환하세요.

거리는 유클리드 거리 `sqrt(x^2 + y^2)`로 계산합니다. 가장 가까운 `k`개의 배달지를 임의의 순서로 반환하면 되며, 정답은 순서를 빼면 유일합니다.

**예시 1:**
```
입력: stops = [[2,4],[7,7]], k = 1
출력: [[2,4]]
설명: `sqrt(2^2 + 4^2) ≈ 4.47`이 `sqrt(7^2 + 7^2) ≈ 9.90`보다 작으므로 (2, 4)가 가장 가까운 배달지입니다.
```

**예시 2:**
```
입력: stops = [[5,5],[1,2],[-3,1],[4,-4]], k = 2
출력: [[-3,1],[1,2]]
설명: 가장 가까운 두 배달지는 (-3, 1)이며 거리는 `sqrt(10)`, (1, 2)이며 거리는 `sqrt(5)`입니다.
```$$,
 $$- `1 <= k <= stops.length <= 2 * 10^3`
- `|x|, |y| <= 10^8`$$),

-- 9. spiral-shelf-walk
((SELECT id FROM problems WHERE slug = 'spiral-shelf-walk'), 'ko',
 $$선반 나선 순회$$,
 $$`m x n` 격자 `board`가 주어질 때, 그 값을 나선 순서로 반환하세요. 맨 윗줄을 가로지르고, 가장 오른쪽 열을 따라 내려가고, 맨 아랫줄을 따라 되돌아오고, 가장 왼쪽 열을 따라 올라간 다음, 안쪽으로 한 칸 들어가서 같은 패턴을 반복합니다. 각 칸은 정확히 한 번씩만 방문합니다.

**예시 1:**
```
입력: board = [[1,2],[3,4]]
출력: [1,2,4,3]
```

**예시 2:**
```
입력: board = [[5,6,7],[8,9,10],[11,12,13],[14,15,16]]
출력: [5,6,7,10,13,16,15,14,11,8,9,12]
```$$,
 $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 10`
- `-100 <= board[i][j] <= 100`$$),

-- 10. online-friend-mask
((SELECT id FROM problems WHERE slug = 'online-friend-mask'), 'ko',
 $$접속 중인 친구 마스크$$,
 $$정수 `sensorMask`는 접속 중인 팀원들을 비트로 묶어 표현합니다 — 켜져 있는 비트 하나는 친구 한 명이 접속해 있다는 뜻입니다.

`countActiveSensors(sensorMask)`를 구현해, `sensorMask`를 부호 없는 값으로 보고 `1` 비트의 개수를 반환하세요.

**예시 1:**
```
입력: sensorMask = 29
출력: 4
설명: 29는 이진수로 11101이며, 켜진 비트가 네 개 있습니다.
```

**예시 2:**
```
입력: sensorMask = 256
출력: 1
설명: 256은 이진수로 100000000이며, 친구 한 명만 접속해 있습니다.
```$$,
 $$- `1 <= sensorMask <= 2.1 * 10^9`$$);
