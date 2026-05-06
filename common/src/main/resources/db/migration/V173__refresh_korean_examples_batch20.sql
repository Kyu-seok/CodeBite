-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 20 (problems #191-#200)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (lockers, firstCount,
-- secondCount, specimenCount, leftFlags, rightFlags, k, value, timestamp,
-- key, val, length, index, snapId) stay verbatim. The first mention of
-- each variable in Korean prose is paired with a Korean noun phrase
-- describing its role. Constraint identifiers align with the canonical
-- English parameter names used in V135 source descriptions (with method
-- and class signatures sourced from V124 and V127 where applicable).

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'find-empty-locker', 'add-without-plus', 'power-of-two-tank',
      'compare-loadout-bits', 'queue-from-stacks', 'chat-ring-buffer',
      'snack-stock-map', 'random-pick-bag', 'versioned-cells',
      'click-tally-window'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. find-empty-locker
((SELECT id FROM problems WHERE slug = 'find-empty-locker'), 'ko',
 $$비어 있는 사물함 찾기$$,
 $$체육 선생님이 `0, 1, 2, ..., n`번 사물함을 나눠 주면서 그중 `n`개가 이미 누군가에게 배정됐다고 알려 줍니다. `[0, n]` 범위 중에서 정확히 한 번호만 빠져 있고, 그 번호가 당신 자리입니다.

이미 배정된 번호들이 담긴 배열 `lockers`가 주어질 때, 빠진 번호 하나를 반환하세요. 답은 반드시 존재하며 유일합니다.

**예시 1:**
```
입력: lockers = [4,2,0,1]
출력: 3
설명: lockers의 길이가 4이므로 전체 범위는 [0..4]입니다. 빠진 번호는 3 하나뿐입니다.
```

**예시 2:**
```
입력: lockers = [5,3,1,0,2]
출력: 4
설명: 전체 범위가 [0..5]인데 4가 목록에 없습니다.
```$$,
 $$- `1 <= lockers.length <= 2 * 10^5`
- `0 <= lockers[i] <= lockers.length`
- `lockers`의 모든 값은 서로 다릅니다.$$),

-- 2. add-without-plus
((SELECT id FROM problems WHERE slug = 'add-without-plus'), 'ko',
 $$더하기 없이 더하기$$,
 $$오래된 휴대용 게임기는 두 개의 킬 카운터 레지스터에 대해 비트 연산(AND, OR, XOR, NOT, 시프트)만 지원합니다. `+`나 `-`를 쓰지 않고 두 값을 더해야 합니다.

두 정수 `firstCount`(첫 번째 카운터 값)와 `secondCount`(두 번째 카운터 값)가 주어졌을 때, 비트 연산만으로 합을 구하는 `combineCounters`를 구현하세요. XOR는 올림을 무시한 합을, AND 후 왼쪽으로 한 칸 시프트한 값은 올림을 나타내므로, 올림이 0이 될 때까지 반복하면 됩니다.

**예시 1:**
```
입력: firstCount = 12, secondCount = 9
출력: 21
```

**예시 2:**
```
입력: firstCount = -15, secondCount = 4
출력: -11
```$$,
 $$- `-1500 <= firstCount, secondCount <= 1500`$$),

-- 3. power-of-two-tank
((SELECT id FROM problems WHERE slug = 'power-of-two-tank'), 'ko',
 $$2의 거듭제곱 수조$$,
 $$어느 수족관 가게는 물고기 마릿수가 2의 거듭제곱(`1`, `2`, `4`, `8`, `16`, ...)일 때만 수조를 유지합니다. 새끼들이 두 배씩 갈라지는 사육 정책 때문이죠. 그 외의 마릿수는 모두 혼합 수조로 분류됩니다.

정수 `specimenCount`(수조 안의 개체 수)가 주어졌을 때, 어떤 음이 아닌 정수 `k`에 대해 `specimenCount == 2^k`이면 `true`를, 그렇지 않으면 `false`를 반환하는 `isSoloSpecies(specimenCount)`를 구현하세요.

**예시 1:**
```
입력: specimenCount = 32
출력: true
설명: 32 = 2^5.
```

**예시 2:**
```
입력: specimenCount = 12
출력: false
설명: 12는 2^3 = 8과 2^4 = 16 사이에 있으므로 2의 거듭제곱이 아닙니다.
```$$,
 $$- `-2.1 * 10^9 <= specimenCount <= 2.1 * 10^9`$$),

-- 4. compare-loadout-bits
((SELECT id FROM problems WHERE slug = 'compare-loadout-bits'), 'ko',
 $$로드아웃 비트 비교$$,
 $$두 팀원이 각자의 로드아웃 비트마스크를 가지고 있는데, 비트 하나하나가 특정 퍽 슬롯을 의미합니다. 두 사람이 서로 다른 퍽 슬롯을 몇 개나 골랐는지 세세요.

두 음이 아닌 정수 `leftFlags`(왼쪽 팀원의 비트마스크)와 `rightFlags`(오른쪽 팀원의 비트마스크)가 주어질 때, 두 값에서 비트가 다른 자리의 개수를 반환하세요.

**예시 1:**
```
입력: leftFlags = 10, rightFlags = 5
출력: 4
설명: 10은 1010이고 5는 0101이라, 하위 4비트가 모두 다릅니다.
```

**예시 2:**
```
입력: leftFlags = 14, rightFlags = 9
출력: 3
설명: 14는 1110이고 9는 1001이므로 0, 1, 2번 비트가 다릅니다.
```$$,
 $$- `0 <= leftFlags, rightFlags <= 2.1 * 10^9`$$),

-- 5. queue-from-stacks
((SELECT id FROM problems WHERE slug = 'queue-from-stacks'), 'ko',
 $$스택으로 큐 만들기$$,
 $$카페 음료 픽업 카운터에서는 손님을 도착 순서대로 응대해야 하는데, 사용 가능한 트레이는 가장 위쪽 컵만 만질 수 있는 푸시다운 스택뿐입니다. 정확히 두 개의 그런 스택만 사용해 FIFO 큐처럼 동작하는 `QueueFromStacks`를 만드세요. 배열, 리스트, 데크 같은 다른 자료구조는 일절 쓸 수 없으며, 두 내부 스택에 대해서는 push, pop, peek, 비어 있는지 확인 외의 연산을 허용하지 않습니다.

- `QueueFromStacks()` — 빈 큐를 시작합니다.
- `void push(int x)` — 주문 `x`를 뒤쪽에 추가합니다.
- `int pop()` — 맨 앞 주문을 꺼내 반환합니다.
- `int peek()` — 맨 앞 주문을 꺼내지 않고 반환합니다.
- `boolean empty()` — 큐가 비어 있으면 `true`를 반환합니다.

호출자는 비어 있는 큐에 `pop`이나 `peek`을 부르지 않습니다.

**예시:**
```
q = new QueueFromStacks()
q.push(1)
q.push(2)
q.peek()   // 1  -- 줄 맨 앞
q.pop()    // 1  -- 맨 앞 손님 응대 완료
q.empty()  // false -- 2번 주문이 아직 대기 중
```$$,
 $$- `1 <= x <= 9`
- `push`, `pop`, `peek`, `empty`를 합쳐 최대 `100`회 호출됩니다.
- `pop`과 `peek`은 큐가 비어 있지 않을 때만 호출됩니다.$$),

-- 6. chat-ring-buffer
((SELECT id FROM problems WHERE slug = 'chat-ring-buffer'), 'ko',
 $$채팅 링 버퍼$$,
 $$파티 채팅에서는 가장 최근 메시지만을 고정된 크기의 원형 버퍼에 보관합니다. 이를 관리하는 `FixedRing`을 구현하세요.

- `FixedRing(int k)` — 용량 `k`(최대 보관 가능한 메시지 수)인 빈 링을 만듭니다.
- `boolean push(int value)` — 메시지 `value`를 뒤쪽에 추가합니다. 성공하면 `true`, 가득 차 있으면 `false`를 반환합니다.
- `boolean pull()` — 맨 앞 메시지를 제거합니다. 성공하면 `true`, 비어 있으면 `false`를 반환합니다.
- `int front()` — 맨 앞 메시지를 제거하지 않고 반환하며, 비어 있으면 `-1`을 반환합니다.
- `int rear()` — 맨 뒤 메시지를 제거하지 않고 반환하며, 비어 있으면 `-1`을 반환합니다.
- `boolean isEmpty()` — 링에 메시지가 하나도 없으면 `true`를 반환합니다.
- `boolean isFull()` — `k`개의 슬롯이 전부 차 있으면 `true`를 반환합니다.

**예시:**
```
ring = new FixedRing(3)
ring.push(1); ring.push(2); ring.push(3)   // 모두 성공
ring.push(4)                               // false, 링이 가득 참
ring.rear()                                // 3
ring.pull()                                // true, 1을 제거
ring.push(4)                               // true, 한 바퀴 돌아 들어감
ring.rear()                                // 4
```$$,
 $$- `1 <= k <= 1000`
- `0 <= value <= 1000`
- `push`, `pull`, `front`, `rear`, `isEmpty`, `isFull`을 합쳐 최대 `3000`회 호출됩니다.$$),

-- 7. snack-stock-map
((SELECT id FROM problems WHERE slug = 'snack-stock-map'), 'ko',
 $$간식 재고 맵$$,
 $$자판기의 간식 수량을 조회할 수 있는 룩업 테이블을 만듭니다. 내장 딕셔너리 라이브러리는 사용할 수 없습니다.

다음과 같은 `ChainedMap` 클래스를 구현하세요.

- `ChainedMap()` — 빈 맵을 만듭니다.
- `void set(int key, int value)` — 간식 `key`(간식 식별자)의 수량을 `value`(보관 개수)로 설정하며, 이미 있으면 덮어씁니다.
- `int lookup(int key)` — 간식 `key`의 수량을 반환하고, 등록돼 있지 않으면 `-1`을 반환합니다.
- `void erase(int key)` — 간식 `key`를 제거합니다. 등록돼 있지 않으면 아무 일도 하지 않습니다.

**예시 1:**
```
입력: ["ChainedMap","set","set","lookup","lookup","set","lookup","erase","lookup"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
출력: [null,null,null,10,-1,null,30,null,-1]
설명: (1,10)과 (2,20)을 기록한 뒤 간식 1은 자기 수량을, 간식 3은 -1을 반환합니다. 간식 2를 30으로 덮어쓰면 다음 조회에 반영되고, 지운 뒤 다시 조회하면 -1이 나옵니다.
```

**예시 2:**
```
입력: ["ChainedMap","set","set","set","lookup","lookup","lookup"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
출력: [null,null,null,null,50,100,150]
설명: 서로 다른 세 간식이 따로 저장되고, 각각 자기 수량을 그대로 다시 읽어 옵니다.
```

**예시 3:**
```
입력: ["ChainedMap","lookup","erase","lookup"] / [[],[7],[7],[7]]
출력: [null,-1,null,-1]
설명: 한 번도 추가된 적 없는 간식을 조회하거나 지워도 아무 문제가 없습니다.
```$$,
 $$- `0 <= key, value <= 800000`
- `set`, `lookup`, `erase`를 합쳐 최대 `8000`회 호출됩니다.$$),

-- 8. random-pick-bag
((SELECT id FROM problems WHERE slug = 'random-pick-bag'), 'ko',
 $$무작위로 뽑는 가방$$,
 $$게임 모임에서 서로 다른 카드 번호들이 들어 있는 가방을 두고, 필요할 때마다 카드 한 장을 무작위로 뽑고 싶어 합니다. 가방 안에 현재 들어 있는 모든 카드가 같은 확률로 뽑히도록 `RandomBag`을 만들고, 삽입·제거·뽑기 모두 평균적으로 상수 시간에 동작하게 하세요.

- `RandomBag()` — 비어 있는 가방으로 시작합니다.
- `boolean insert(int val)` — 카드 `val`(카드 번호)을 추가합니다. 새로 추가됐으면 `true`, 이미 있었으면 `false`를 반환합니다.
- `boolean remove(int val)` — 카드 `val`을 제거합니다. 있었으면 `true`, 없었으면 `false`를 반환합니다.
- `int drawRandom()` — 현재 가방에서 카드 하나를 균등 확률로 뽑아 반환합니다. 가방이 비어 있지 않을 때만 호출됩니다.

**예시:**
```
호출:   ["RandomBag","insert","insert","remove","drawRandom"]
인자:   [[],[1],[2],[1],[]]
결과:   [null,true,true,true,2]
```
카드 `1`과 `2`를 넣은 뒤 `1`을 빼면 가방에는 `2`만 남으므로 뽑기는 `2`를 반환합니다.$$,
 $$- `-10^8 <= val <= 10^8`
- `insert`, `remove`, `drawRandom`을 합쳐 최대 `2 * 10^5`회 호출됩니다.
- `drawRandom`은 가방이 비어 있지 않을 때만 호출됩니다.$$),

-- 9. versioned-cells
((SELECT id FROM problems WHERE slug = 'versioned-cells'), 'ko',
 $$버전 관리 셀$$,
 $$샌드박스 게임의 저장 기능을 만들고 있습니다. 월드는 숫자 셀들이 한 줄로 늘어선 구조이고, 살아 있는 행을 자유롭게 수정하다가 원할 때 그 상태를 스냅샷으로 동결해 나중에 다시 볼 수 있어야 합니다. 모든 셀은 `0`으로 시작하고, 스냅샷 id는 `0`부터 차례로 매겨집니다.

다음과 같은 `VersionedCells` 클래스를 구현하세요.

- `VersionedCells(int length)` — 길이 `length`(셀 개수)인 행을 모두 `0`으로 초기화하고, 스냅샷이 하나도 없는 상태로 시작합니다.
- `void set(int index, int val)` — 살아 있는 행의 위치 `index`(셀 위치)에 값 `val`(새 값)을 설정합니다. 이미 커밋된 스냅샷은 영향을 받지 않습니다.
- `int commit()` — 현재 살아 있는 행을 새 스냅샷으로 동결하고 그 id를 반환합니다. 첫 호출은 `0`, 두 번째는 `1`, ... 식으로 이어집니다.
- `int readAt(int index, int snapId)` — 스냅샷 `snapId`(스냅샷 식별자)에서 셀 `index`의 값을 반환합니다.

**예시:**
```
cells = new VersionedCells(3)
cells.set(0, 5)
cells.commit()        // 0을 반환; 스냅샷 0은 [5, 0, 0]
cells.set(0, 6)       // 살아 있는 행은 이제 [6, 0, 0]
cells.readAt(0, 0)    // 5 -- 스냅샷 0의 셀 0 값
```$$,
 $$- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^8`
- `0 <= snapId`이며 `snapId`는 지금까지 호출된 `commit` 횟수보다 반드시 작습니다.
- `set`, `commit`, `readAt`을 합쳐 최대 `50000`회 호출됩니다.$$),

-- 10. click-tally-window
((SELECT id FROM problems WHERE slug = 'click-tally-window'), 'ko',
 $$클릭 윈도 카운터$$,
 $$버튼이 얼마나 자주 눌리는지 추적합니다. 클릭 시각을 기록하고, 최근 5분 동안(양 끝 포함) 몇 번 클릭됐는지 보고하는 `ClickTally`를 만드세요.

- `ClickTally()` — 빈 카운터를 만듭니다.
- `void record(int timestamp)` — 시각 `timestamp`(초 단위 타임스탬프)에 발생한 클릭 한 번을 기록합니다. 같은 초에 여러 번 클릭될 수 있습니다.
- `int countSince(int timestamp)` — `[timestamp - 299, timestamp]` 구간에 들어오는 클릭 수를 반환합니다.

호출은 `timestamp`가 감소하지 않는 순서로만 들어옵니다.

**예시 1:**
```
입력: ["ClickTally","record","record","record","countSince","record","countSince","countSince"] / [[],[1],[2],[3],[4],[300],[300],[301]]
출력: [null,null,null,null,3,null,4,3]
설명: 4초 시점에서 1, 2, 3초의 클릭이 모두 윈도 안에 있습니다. 300초에는 1초의 클릭도 아직 포함되어 4가 나오고, 한 틱 뒤에는 그 클릭이 빠지면서 3으로 줄어듭니다.
```

**예시 2:**
```
입력: ["ClickTally","record","record","record","countSince"] / [[],[100],[100],[100],[100]]
출력: [null,null,null,null,3]
설명: 같은 초에 들어온 세 번의 클릭이 모두 카운트됩니다.
```

**예시 3:**
```
입력: ["ClickTally","countSince","record","countSince"] / [[],[1],[2],[300]]
출력: [null,0,null,1]
설명: 클릭이 들어오기 전에 조회하면 0이 나오고, 이후 들어온 클릭은 300초 시점의 윈도 안에 그대로 들어옵니다.
```$$,
 $$- `1 <= timestamp <= 2 * 10^9`
- 매 호출에서 전달되는 `timestamp`는 직전 호출의 값보다 작지 않습니다.
- `record`와 `countSince`를 합쳐 최대 250회 호출됩니다.$$);
