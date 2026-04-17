-- Korean translations: batch 20 (problems #191-200)

------------------------------------------------------------
-- #191 absent-number
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'absent-number'),
    'ko',
    '빠진 숫자',
    '`[0, n]` 범위의 서로 다른 정수 `n`개가 담긴 배열 `nums`가 주어집니다. 이 범위에서 배열에 없는 숫자 하나를 찾아 반환하세요.

`n + 1`개의 후보(`0`부터 `n`까지) 중 배열에는 `n`개만 들어 있으므로, 정확히 하나의 값이 빠져 있습니다.

**예시 1:**
```
Input: nums = [3,0,1]
Output: 2
Explanation: 배열 길이가 3이므로 전체 범위는 [0, 1, 2, 3]입니다. 2가 빠져 있습니다.
```

**예시 2:**
```
Input: nums = [0,1]
Output: 2
Explanation: 배열 길이가 2이므로 전체 범위는 [0, 1, 2]입니다. 2가 빠져 있습니다.
```

**예시 3:**
```
Input: nums = [9,6,4,2,3,5,7,0,1]
Output: 8
```',
    '- `1 <= nums.length <= 10000`
- `0 <= nums[i] <= n`
- nums의 모든 값은 고유합니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #192 bitwise-sum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bitwise-sum'),
    'ko',
    '비트 덧셈',
    '두 정수 `a`와 `b`가 주어졌을 때, `+`나 `-` 연산자를 사용하지 않고 두 수의 합을 구하세요.

비트 연산(AND, OR, XOR, NOT, 시프트)만으로 결과를 계산해야 합니다. 이진 덧셈의 원리를 생각해 보세요. XOR은 올림 없는 합을 구하고, AND 후 왼쪽 시프트는 올림 비트를 구합니다.

**예시 1:**
```
Input: a = 3, b = 5
Output: 8
```

**예시 2:**
```
Input: a = -7, b = 3
Output: -4
```

**예시 3:**
```
Input: a = 0, b = 0
Output: 0
```',
    '- `-1000 <= a, b <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #193 power-check
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'power-check'),
    'ko',
    '2의 거듭제곱 판별',
    '정수 `n`이 주어졌을 때, 2의 거듭제곱이면 `true`를, 아니면 `false`를 반환하세요.

`n == 2^k`를 만족하는 음이 아닌 정수 `k`가 존재하면 `n`은 2의 거듭제곱입니다. `2^0 = 1`이므로 `1`도 2의 거듭제곱입니다. 0 이하의 수는 절대 2의 거듭제곱이 아닙니다.

**예시 1:**
```
Input: n = 1
Output: true
Explanation: 2^0 = 1.
```

**예시 2:**
```
Input: n = 16
Output: true
Explanation: 2^4 = 16.
```

**예시 3:**
```
Input: n = 6
Output: false
```',
    '- `-2^31 <= n <= 2^31 - 1`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #194 bit-distance
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bit-distance'),
    'ko',
    '비트 거리',
    '두 정수 `x`와 `y`가 주어졌을 때, 이진 표현에서 서로 다른 비트 위치의 수를 반환하세요. 이를 **해밍 거리**라고 합니다.

`x`와 `y`의 각 비트를 비교하여, 한쪽이 `1`이고 다른 쪽이 `0`인 위치마다 거리가 1씩 증가합니다.

**예시 1:**
```
Input: x = 1, y = 4
Output: 2
Explanation: 1의 이진수는 001, 4는 100입니다. 위치 0과 2에서 다릅니다.
```

**예시 2:**
```
Input: x = 3, y = 1
Output: 1
Explanation: 3은 11, 1은 01입니다. 위치 1에서만 다릅니다.
```

**예시 3:**
```
Input: x = 0, y = 0
Output: 0
Explanation: 두 값이 동일하므로 다른 비트가 없습니다.
```',
    '- `0 <= x, y <= 2^31 - 1`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #195 stack-queue
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'stack-queue'),
    'ko',
    '스택으로 큐 구현',
    '두 개의 스택만 사용하여 **선입선출(FIFO) 큐**를 설계하세요. 큐의 기본 연산인 뒤에 추가, 앞에서 제거, 앞 원소 확인, 비어있는지 확인을 지원해야 합니다.

`StackQueue` 클래스를 구현하세요:
- `StackQueue()` -- 빈 큐를 초기화합니다.
- `void push(int x)` -- 원소 `x`를 큐의 뒤에 추가합니다.
- `int pop()` -- 큐의 앞에서 원소를 제거하고 반환합니다.
- `int peek()` -- 큐의 앞 원소를 제거하지 않고 반환합니다.
- `boolean empty()` -- 큐가 비어있으면 `true`, 아니면 `false`를 반환합니다.

스택의 기본 연산(push, pop, peek, empty)만 사용할 수 있으며, 두 개의 스택 외에 다른 자료구조는 사용할 수 없습니다.

**예시 1:**
```
Input:
["StackQueue","push","push","peek","pop","empty"]
[[],[1],[2],[],[],[]]
Output: [null,null,null,1,1,false]
Explanation: 1과 2를 push한 뒤 peek은 1(큐의 앞)을 반환합니다. pop은 1을 제거하고 반환합니다. 큐에 2가 남아 있으므로 empty는 false입니다.
```

**예시 2:**
```
Input:
["StackQueue","push","push","push","pop","pop","peek","empty"]
[[],[10],[20],[30],[],[],[],[]]
Output: [null,null,null,null,10,20,30,false]
Explanation: 넣은 순서대로 10, 20이 꺼내지고, peek은 30을 보여줍니다.
```

**예시 3:**
```
Input:
["StackQueue","push","pop","empty"]
[[],[42],[],[]]
Output: [null,null,42,true]
Explanation: 42를 push한 뒤 pop하면 큐가 비어 있게 됩니다.
```',
    '- `1 <= x <= 9`
- push, pop, peek, empty 호출은 최대 100회입니다
- pop과 peek 호출 시 큐가 비어있지 않음이 보장됩니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #196 ring-buffer
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ring-buffer'),
    'ko',
    '원형 큐',
    '고정된 최대 용량을 가진 **원형 큐**(링 버퍼)를 설계하세요. 내부 저장 공간의 끝에 도달하면 처음으로 돌아가 공간을 재활용합니다.

`RingBuffer` 클래스를 구현하세요:
- `RingBuffer(int k)` -- 최대 용량 `k`로 버퍼를 초기화합니다.
- `boolean enQueue(int value)` -- 뒤쪽에 원소를 삽입합니다. 성공하면 `true`, 버퍼가 가득 차면 `false`를 반환합니다.
- `boolean deQueue()` -- 앞쪽의 원소를 제거합니다. 성공하면 `true`, 버퍼가 비어있으면 `false`를 반환합니다.
- `int front()` -- 앞쪽 원소를 반환합니다. 비어있으면 `-1`을 반환합니다.
- `int rear()` -- 뒤쪽 원소를 반환합니다. 비어있으면 `-1`을 반환합니다.
- `boolean isEmpty()` -- 버퍼에 원소가 없으면 `true`를 반환합니다.
- `boolean isFull()` -- 버퍼가 최대 용량에 도달했으면 `true`를 반환합니다.

**예시 1:**
```
Input:
["RingBuffer","enQueue","enQueue","enQueue","enQueue","rear","isFull","deQueue","enQueue","rear"]
[[3],[1],[2],[3],[4],[],[],[],[4],[]]
Output: [null,true,true,true,false,3,true,true,true,4]
Explanation: 용량이 3인 버퍼에 1, 2, 3을 넣으면 가득 차서 4 삽입은 실패합니다. 앞 원소(1)를 제거하면 4를 넣을 수 있습니다.
```

**예시 2:**
```
Input:
["RingBuffer","enQueue","deQueue","front","deQueue"]
[[2],[5],[],[],[]]
Output: [null,true,true,-1,false]
Explanation: 5를 넣고 빼면 front()는 -1을 반환합니다(비어있으므로). 두 번째 deQueue도 실패합니다.
```

**예시 3:**
```
Input:
["RingBuffer","isEmpty","enQueue","isEmpty","isFull","enQueue","isFull"]
[[2],[],[1],[],[],[2],[]]
Output: [null,true,true,false,false,true,true]
Explanation: 새 버퍼는 비어 있습니다. 원소 하나를 추가하면 더 이상 비어있지 않고, 두 번째를 추가하면 가득 찹니다.
```',
    '- `1 <= k <= 1000`
- `0 <= value <= 1000`
- enQueue, deQueue, front, rear, isEmpty, isFull 호출은 최대 3000회입니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #197 hash-table
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'hash-table'),
    'ko',
    '해시 맵 구현',
    '내장 해시 맵이나 딕셔너리 라이브러리를 사용하지 않고 해시 맵을 직접 설계하세요. 키-값 쌍의 삽입, 조회, 삭제를 지원해야 합니다.

`SimpleHashMap` 클래스를 구현하세요:
- `SimpleHashMap()` -- 빈 맵을 생성합니다.
- `void put(int key, int value)` -- `(key, value)` 쌍을 삽입합니다. 키가 이미 존재하면 값을 갱신합니다.
- `int get(int key)` -- `key`에 매핑된 값을 반환합니다. 키가 없으면 `-1`을 반환합니다.
- `void remove(int key)` -- 키와 값을 삭제합니다. 키가 없으면 아무 동작도 하지 않습니다.

**예시 1:**
```
Input: ["SimpleHashMap","put","put","get","get","put","get","remove","get"] / [[],[1,10],[2,20],[1],[3],[2,30],[2],[2],[2]]
Output: [null,null,null,10,-1,null,30,null,-1]
Explanation: (1,10)과 (2,20)을 넣은 뒤 get(1)은 10, get(3)은 -1입니다. 키 2를 30으로 갱신하면 get(2)는 30입니다. 키 2를 삭제하면 get(2)는 -1입니다.
```

**예시 2:**
```
Input: ["SimpleHashMap","put","put","put","get","get","get"] / [[],[5,50],[10,100],[15,150],[5],[10],[15]]
Output: [null,null,null,null,50,100,150]
```

**예시 3:**
```
Input: ["SimpleHashMap","get","remove","get"] / [[],[7],[7],[7]]
Output: [null,-1,null,-1]
Explanation: 빈 맵에서 get과 remove를 호출하면 각각 -1을 반환하고 아무 동작도 하지 않습니다.
```',
    '- `0 <= key, value <= 10^6`
- put, get, remove 호출은 최대 `10^4`회입니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #198 random-set
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'random-set'),
    'ko',
    '랜덤 집합',
    '삽입, 삭제, 랜덤 원소 조회를 각각 평균 `O(1)` 시간에 지원하는 자료구조를 설계하세요.

`RandomSet` 클래스를 구현하세요:
- `RandomSet()` -- 빈 집합을 생성합니다.
- `boolean insert(int val)` -- `val`을 집합에 추가합니다. 이미 있으면 `false`, 없었으면 `true`를 반환합니다.
- `boolean remove(int val)` -- `val`을 집합에서 제거합니다. 있었으면 `true`, 없었으면 `false`를 반환합니다.
- `int getRandom()` -- 현재 집합에서 균일한 확률로 랜덤 원소를 반환합니다. 모든 원소가 선택될 확률이 동일해야 합니다. 이 메서드는 집합이 비어있지 않을 때만 호출됩니다.

**예시 1:**
```
Input: ["RandomSet","insert","insert","remove","getRandom"] / [[],[1],[2],[1],[]]
Output: [null,true,true,true,2]
Explanation: 1과 2를 삽입한 뒤 1을 제거하면 2만 남습니다. getRandom은 2를 반환합니다.
```

**예시 2:**
```
Input: ["RandomSet","insert","insert","remove","insert","remove","getRandom"] / [[],[5],[5],[5],[5],[10],[]]
Output: [null,true,false,true,true,false,5]
Explanation: 두 번째 insert(5)는 이미 있으므로 false입니다. remove(10)은 없으므로 false입니다. 5만 남아 getRandom은 5를 반환합니다.
```

**예시 3:**
```
Input: ["RandomSet","insert","remove","remove","insert","getRandom"] / [[],[7],[7],[7],[7],[]]
Output: [null,true,true,false,true,7]
Explanation: insert(7) 후 remove(7)으로 집합이 비워집니다. 두 번째 remove(7)은 false입니다. 다시 7을 넣으면 유일한 원소이므로 getRandom은 7을 반환합니다.
```',
    '- `-2^31 <= val <= 2^31 - 1`
- insert, remove, getRandom 호출은 최대 `2 * 10^5`회입니다
- getRandom 호출 시 집합에 원소가 하나 이상 있음이 보장됩니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #199 state-snapshots
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'state-snapshots'),
    'ko',
    '상태 스냅샷',
    '특정 인덱스에 값을 설정하고, 현재 상태의 스냅샷을 찍고, 이전 스냅샷의 값을 조회할 수 있는 자료구조를 설계하세요.

`SnapshotArray` 클래스를 구현하세요:
- `SnapshotArray(int length)` -- 주어진 `length` 크기의 배열을 모두 `0`으로 초기화합니다.
- `void set(int index, int val)` -- `index` 위치의 값을 `val`로 설정합니다.
- `int snap()` -- 현재 배열 상태의 스냅샷을 저장하고 스냅샷 ID를 반환합니다. 첫 호출은 `0`, 두 번째는 `1`, 이후 순차적으로 증가합니다.
- `int get(int index, int snapId)` -- `snapId` 스냅샷이 찍혔을 때의 `index` 위치 값을 반환합니다.

**예시 1:**
```
Input:
["SnapshotArray","set","snap","set","get"]
[[3],[0,5],[],[0,6],[0,0]]
Output: [null,null,0,null,5]
Explanation: set(0, 5) 후 snap으로 ID 0을 저장합니다. 이후 set(0, 6)으로 값을 바꿔도 get(0, 0)은 스냅샷 0의 값인 5를 반환합니다.
```

**예시 2:**
```
Input:
["SnapshotArray","set","set","snap","set","snap","get","get"]
[[2],[0,10],[1,20],[],[0,30],[],[0,0],[0,1]]
Output: [null,null,null,0,null,1,10,30]
Explanation: 스냅샷 0은 [10, 20]을 저장합니다. set(0, 30) 후 스냅샷 1은 [30, 20]을 저장합니다. get(0, 0)은 10, get(0, 1)은 30입니다.
```

**예시 3:**
```
Input:
["SnapshotArray","snap","get","set","snap","get"]
[[1],[],[0,0],[0,7],[],[0,1]]
Output: [null,0,0,null,1,7]
Explanation: 스냅샷 0은 즉시 찍혀 모두 0입니다. 인덱스 0을 7로 설정한 뒤 스냅샷 1을 찍으면 get(0, 1)은 7을 반환합니다.
```',
    '- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^9`
- `0 <= snapId < (snap() 호출 횟수)`
- set, snap, get 호출은 총 최대 50000회입니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #200 click-counter
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'click-counter'),
    'ko',
    '클릭 카운터',
    '최근 300초(5분) 동안의 히트 수를 추적하는 카운터를 설계하세요.

`HitCounter` 클래스를 구현하세요:
- `HitCounter()` -- 히트 0인 상태로 카운터를 초기화합니다.
- `void hit(int timestamp)` -- 주어진 `timestamp`(초 단위)에 히트를 기록합니다. 같은 타임스탬프에 여러 히트가 올 수 있습니다.
- `int getHits(int timestamp)` -- `[timestamp - 299, timestamp]` 구간(양 끝 포함)의 총 히트 수를 반환합니다.

모든 타임스탬프는 `hit`과 `getHits` 호출 전체에 걸쳐 단조 비감소 순서로 주어집니다.

**예시 1:**
```
Input: ["HitCounter","hit","hit","hit","getHits","hit","getHits","getHits"] / [[],[1],[2],[3],[4],[300],[300],[301]]
Output: [null,null,null,null,3,null,4,3]
Explanation: 타임스탬프 4에서 이전 3개의 히트(1, 2, 3)는 모두 [4-299, 4] 구간에 포함되어 3을 반환합니다. 타임스탬프 300에서 1의 히트도 [1, 300] 범위 안이므로 4를 반환합니다. 타임스탬프 301에서 1의 히트는 [2, 301] 범위 밖이므로 3을 반환합니다.
```

**예시 2:**
```
Input: ["HitCounter","hit","hit","hit","getHits"] / [[],[100],[100],[100],[100]]
Output: [null,null,null,null,3]
Explanation: 같은 타임스탬프의 세 히트가 모두 카운트됩니다.
```

**예시 3:**
```
Input: ["HitCounter","getHits","hit","getHits"] / [[],[1],[2],[300]]
Output: [null,0,null,1]
Explanation: 히트가 없을 때 조회하면 0을 반환합니다. 타임스탬프 2의 히트는 300 시점에서도 구간 안에 포함됩니다.
```',
    '- `1 <= timestamp <= 2 * 10^9`
- 각 타임스탬프는 이전 타임스탬프 이상입니다
- hit과 getHits 호출은 최대 300회입니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
