-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 12 (problems #111-#120)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (position, speed, target,
-- heights, fighters, key, value, timestamp, zonesA, zonesB, menu, volumes,
-- days, capacity, head, k) stay verbatim. First mention of each variable
-- in Korean prose is paired with a Korean noun phrase describing its role.
-- Constraint identifiers are aligned with the canonical English parameter
-- names from the V135 / V149 source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'group-car-packs', 'largest-rectangle-histogram', 'brawler-lane-collision',
      'timestamp-value-store', 'merged-price-median', 'find-menu-calorie',
      'min-daily-brew', 'lru-cache', 'flip-chunks-of-k', 'swap-print-pairs'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. group-car-packs
((SELECT id FROM problems WHERE slug = 'group-car-packs'), 'ko',
 $$자동차 팩 묶기$$,
 $$자동차들이 1차선 도로를 따라 `target` 킬로미터에 있는 톨게이트로 향합니다. `i`번째 자동차는 위치 `position[i]`에서 출발하며 순항 속도 `speed[i]`로 달립니다. 빠른 차는 앞 차를 추월할 수 없어, 따라잡으면 앞 차의 느린 속도에 맞춰 함께 달립니다. **팩(pack)** 은 함께 달리는 자동차 묶음을 뜻합니다.

톨게이트에 도착하는 팩의 개수를 반환하세요.

**예시 1:**
```
입력: target = 20, position = [0,3,7,14], speed = [5,3,2,1]
출력: 2
설명: 14km 지점의 차는 6시간 만에 혼자 도착합니다. 7km, 3km, 0km 지점의 차들은 톨게이트에 닿기 전에 모두 7km 지점의 차를 따라잡아 한 팩을 이룹니다. 따라서 팩은 모두 두 개입니다.
```

**예시 2:**
```
입력: target = 15, position = [5], speed = [2]
출력: 1
```$$,
 $$- `1 <= position.length == speed.length <= 10^5`
- `0 < target <= 10^6`
- `0 <= position[i] < target`
- `0 < speed[i] <= 10^6`
- 모든 `position[i]`는 서로 다릅니다.$$),

-- 2. largest-rectangle-histogram
((SELECT id FROM problems WHERE slug = 'largest-rectangle-histogram'), 'ko',
 $$히스토그램 최대 직사각형$$,
 $$히스토그램이 배열 `heights`로 주어집니다. `heights[i]`는 `i`번째 막대의 높이이고, 모든 막대의 너비는 1입니다. 히스토그램 안에 완전히 들어가는 (여러 인접 막대에 걸쳐 있어도 됩니다) 가장 큰 직사각형의 넓이를 구하세요.

`i..j` 구간을 덮는 직사각형의 높이는 `min(heights[i..j])`, 너비는 `j - i + 1`입니다.

**예시 1:**
```
입력: heights = [2,1,5,6,2,3]
출력: 10
설명: 인덱스 2와 3에 있는 막대(높이 5와 6)가 함께 2×5 크기의 직사각형을 받쳐, 넓이는 10이 됩니다.
```

**예시 2:**
```
입력: heights = [2,4]
출력: 4
```$$,
 $$- `1 <= heights.length <= 10^5`
- `0 <= heights[i] <= 10^4`$$),

-- 3. brawler-lane-collision
((SELECT id FROM problems WHERE slug = 'brawler-lane-collision'), 'ko',
 $$투사 차선 충돌$$,
 $$같은 차선 위를 동시에 이동하는 투사들의 줄이 있습니다. 배열 `fighters`의 각 값은 부호 있는 힘을 나타내며, 절댓값은 세기, 부호는 방향을 의미합니다(양수는 오른쪽, 음수는 왼쪽).

같은 방향으로 가는 투사들은 절대 만나지 않습니다. 반대 방향의 투사들이 충돌하면 약한 쪽이 쓰러지고, 같으면 둘 다 쓰러집니다.

모든 충돌이 끝난 뒤 살아남은 투사들을 원래 왼쪽에서 오른쪽 순서로 반환하세요.

**예시 1:**
```
입력: fighters = [3,7,-8]
출력: [-8]
설명: -8이 7을 쓰러뜨리고, 이어서 3까지 쓰러뜨려 결국 -8만 남습니다.
```

**예시 2:**
```
입력: fighters = [-3,4,-4,2]
출력: [-3,2]
설명: 4와 -4는 서로 부딪쳐 함께 사라집니다. -3과 2는 같은 방향이 아니지만 서로 만날 일이 없어 모두 살아남습니다.
```$$,
 $$- `1 <= fighters.length <= 10^4`
- `-1000 <= fighters[i] <= 1000`
- `fighters[i] != 0`$$),

-- 4. timestamp-value-store
((SELECT id FROM problems WHERE slug = 'timestamp-value-store'), 'ko',
 $$타임스탬프 값 저장소$$,
 $$길드 협동 게임은 플레이어의 상태 태그를 타임스탬프가 찍힌 체크포인트마다 자동 저장합니다. 특정 시점에 플레이어의 태그가 무엇이었는지 조회할 수 있도록, 태그 스냅샷을 저장하고 시점 질의에 답하는 `TimestampedStore`를 구현하세요.

- `TimestampedStore()` — 빈 저장소를 생성합니다.
- `void write(String key, String value, int timestamp)` — `timestamp` 시점에 `key`의 값으로 `value`를 기록합니다. 동일한 `key`에 대한 연속된 `write` 호출의 `timestamp`는 항상 엄격히 증가한다고 보장됩니다.
- `String readAt(String key, int timestamp)` — `key`에 대해 기록된 값 중 타임스탬프가 `timestamp` 이하인 가장 최근 값을 반환하고, 해당하는 기록이 없으면 `""`을 반환합니다.

조회 시점이 두 기록 사이에 있다면 바로 직전 기록의 값을 반환하면 됩니다.$$,
 $$- `1 <= key.length, value.length <= 100`
- `key`와 `value`는 영문 소문자, 숫자로 구성됩니다.
- `1 <= timestamp <= 10^7`
- 같은 `key`에 대한 모든 `timestamp`는 엄격히 증가합니다.
- `write`와 `readAt`은 합쳐서 최대 `2 * 10^5`번 호출됩니다.$$),

-- 5. merged-price-median
((SELECT id FROM problems WHERE slug = 'merged-price-median'), 'ko',
 $$합친 가격 목록의 중앙값$$,
 $$두 바리스타가 각자 오늘의 음료 가격을 정렬해 적어두었습니다: `zonesA`와 `zonesB`. 두 목록을 합친 결과의 중앙값을 반환하세요. 전체 개수가 홀수면 가운데 값, 짝수면 가운데 두 값의 평균입니다.

`m = zonesA.length`, `n = zonesB.length`라 할 때, 풀이는 `O(log(m + n))` 시간에 동작해야 합니다.

**예시 1:**
```
입력: zonesA = [2,5], zonesB = [4]
출력: 4.0
설명: 합친 목록은 [2,4,5]이고, 가운데 값은 4입니다.
```

**예시 2:**
```
입력: zonesA = [3,8], zonesB = [5,11]
출력: 6.5
설명: 합친 목록은 [3,5,8,11]이고, 중앙값은 (5 + 8) / 2 = 6.5입니다.
```

**예시 3:**
```
입력: zonesA = [], zonesB = [12]
출력: 12.0
설명: 값이 하나뿐이라 그 값이 곧 중앙값입니다.
```$$,
 $$- `zonesA.length == m`
- `zonesB.length == n`
- `0 <= m, n <= 1000`
- `1 <= m + n <= 2000`
- `-10^6 <= zonesA[i], zonesB[i] <= 10^6`
- `zonesA`와 `zonesB`는 비내림차순으로 정렬되어 있습니다.$$),

-- 6. find-menu-calorie
((SELECT id FROM problems WHERE slug = 'find-menu-calorie'), 'ko',
 $$메뉴 칼로리 찾기$$,
 $$카페의 칼로리 표는 `m x n` 크기의 격자 `menu`로 주어집니다. 각 행은 왼쪽에서 오른쪽으로 오름차순, 각 열은 위에서 아래로 오름차순입니다. 단, 행끼리는 겹칠 수 있어, 한 행의 첫 값이 바로 윗행의 마지막 값보다 작을 수도 있습니다.

어떤 칸이라도 `target`과 같다면 `true`를, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
입력: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 14
출력: true
```

**예시 2:**
```
입력: menu = [[2,5,9,13,18],[3,7,11,15,21],[4,8,12,17,25],[6,10,14,20,27],[11,16,19,23,31]], target = 24
출력: false
```

**예시 3:**
```
입력: menu = [[-4,-1],[3,5]], target = -1
출력: true
설명: -1은 첫 번째 행, 두 번째 열에 있습니다.
```$$,
 $$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 300`
- `-10^9 <= menu[i][j] <= 10^9`
- 각 행은 왼쪽에서 오른쪽으로 오름차순으로 정렬되어 있습니다.
- 각 열은 위에서 아래로 오름차순으로 정렬되어 있습니다.
- `-10^9 <= target <= 10^9`$$),

-- 7. min-daily-brew
((SELECT id FROM problems WHERE slug = 'min-daily-brew'), 'ko',
 $$최소 일일 추출 용량$$,
 $$카페는 음료 큐 `volumes`에 들어 있는 모든 음료를 주어진 왼쪽에서 오른쪽 순서대로 `days`일 안에 모두 추출해야 합니다. 매일 바리스타는 정수 용량 하나를 정해, 그 용량을 넘기지 않는 한 큐 앞쪽 음료를 차례로 채워 넣다가 다음 음료를 더 넣으면 용량을 초과하는 시점에 그날의 작업을 마칩니다.

`days`일 안에 모든 음료를 보낼 수 있는 가장 작은 일일 용량을 반환하세요.

**예시 1:**
```
입력: volumes = [2,4,5,7,9,11,13,16,18,20], days = 5
출력: 27
설명: 용량 27이면 5일 안에 [2,4,5,7,9], [11,13], [16], [18], [20]으로 나눠 모두 보낼 수 있습니다.
```

**예시 2:**
```
입력: volumes = [4,3,3,5,2,5], days = 3
출력: 8
설명: 용량 8이면 [4,3], [3,5], [2,5] 순서로 3일 만에 모두 처리할 수 있습니다.
```

**예시 3:**
```
입력: volumes = [2,3,4,2,2], days = 4
출력: 4
설명: 용량 4면 [2], [3], [4], [2,2] 순서로 4일 안에 모두 보낼 수 있습니다.
```$$,
 $$- `1 <= days <= volumes.length <= 5 * 10^4`
- `1 <= volumes[i] <= 500`$$),

-- 8. lru-cache
((SELECT id FROM problems WHERE slug = 'lru-cache'), 'ko',
 $$LRU 캐시$$,
 $$고정된 `capacity`를 가진 키/값 저장소 `LRUCache`를 설계하세요. 용량을 초과하는 순간 가장 오래 사용되지 않은(LRU) 엔트리를 자동으로 삭제합니다.

다음 메서드를 구현하세요:
- `LRUCache(int capacity)` — 양의 정수 용량 `capacity`로 캐시를 초기화합니다.
- `int get(int key)` — `key`에 해당하는 값을 반환하거나, 없으면 `-1`을 반환합니다. 성공한 `get`도 최근 사용으로 간주됩니다.
- `void put(int key, int value)` — 엔트리를 새로 넣거나 갱신합니다. 삽입 후 크기가 `capacity`를 넘으면 가장 오래 사용되지 않은 키를 제거합니다.

`get`과 `put` 모두 평균적으로 **O(1)** 시간에 동작해야 합니다.

**예시 1:**
```
입력
["LRUCache","put","put","get","put","get","put","get","get","get"]
[[2],[1,1],[2,2],[1],[3,3],[2],[4,4],[1],[3],[4]]
출력
[null,null,null,1,null,-1,null,-1,3,4]

설명
LRUCache cache = new LRUCache(2);
cache.put(1, 1); // 캐시 = {1=1}
cache.put(2, 2); // 캐시 = {1=1, 2=2}
cache.get(1);    // 1 반환, 캐시 = {2=2, 1=1}
cache.put(3, 3); // 키 2 제거, 캐시 = {1=1, 3=3}
cache.get(2);    // -1 반환 (없음)
cache.put(4, 4); // 키 1 제거, 캐시 = {3=3, 4=4}
cache.get(1);    // -1 반환
cache.get(3);    // 3 반환
cache.get(4);    // 4 반환
```$$,
 $$- `1 <= capacity <= 3000`
- `0 <= key <= 10^4`
- `0 <= value <= 10^5`
- `get`과 `put`은 합쳐 최대 `2 * 10^5`번 호출됩니다.$$),

-- 9. flip-chunks-of-k
((SELECT id FROM problems WHERE slug = 'flip-chunks-of-k'), 'ko',
 $$k개씩 묶어 뒤집기$$,
 $$파워업 노드들로 이뤄진 연결 리스트가 주어집니다. `k`개씩 연속된 묶음을 제자리에서 뒤집어주세요. 끝에 남은 묶음의 길이가 `k`보다 작다면 그 부분은 그대로 둡니다.

새로운 머리 노드 `head`를 반환하세요. 노드 값은 바꾸지 말고 `next` 포인터만 다시 연결해야 합니다.

**예시 1:**
```
입력: head = [10,20,30,40,50,60,70], k = 3
출력: [30,20,10,60,50,40,70]
설명: 첫 묶음 (10,20,30)은 (30,20,10)으로 뒤집히고, 다음 묶음 (40,50,60)은 (60,50,40)으로 뒤집힙니다. 끝에 남은 70은 길이가 부족해 그대로 유지됩니다.
```

**예시 2:**
```
입력: head = [5,15,25,35], k = 4
출력: [35,25,15,5]
설명: 정확히 길이 4짜리 한 묶음이 통째로 뒤집힙니다.
```

**예시 3:**
```
입력: head = [2,4,6,8,10], k = 1
출력: [2,4,6,8,10]
설명: k = 1이면 각 묶음이 노드 한 개라서, 리스트는 변하지 않습니다.
```$$,
 $$- 리스트의 노드 수는 `n`이며 `1 <= n <= 5000`을 만족합니다.
- `0 <= Node.val <= 1000`
- `1 <= k <= n`$$),

-- 10. swap-print-pairs
((SELECT id FROM problems WHERE slug = 'swap-print-pairs'), 'ko',
 $$인쇄 작업 짝 바꾸기$$,
 $$사무실의 인쇄 큐는 작업 id로 이뤄진 연결 리스트입니다. 큐에서 인접한 두 작업을 짝지어 모두 자리를 바꿔주세요. 작업 수가 홀수라면 마지막 작업은 그대로 둡니다.

`swapQueuePartners(head)`를 구현해 인접한 짝마다 자리를 맞바꾸도록 `next` 포인터를 다시 연결하고, 새로운 머리 노드를 반환하세요. 노드 값은 바꾸지 말고 연결만 바꿔야 합니다.

**예시 1:**
```
입력: head = [11,22,33,44]
출력: [22,11,44,33]
설명: 짝 (11,22)와 (33,44)가 각각 자리를 바꿉니다.
```

**예시 2:**
```
입력: head = [8,3]
출력: [3,8]
설명: 단 하나의 짝이 서로 자리를 바꿉니다.
```

**예시 3:**
```
입력: head = [6,9,15]
출력: [9,6,15]
설명: 첫 짝이 자리를 바꾸고, 짝이 없는 작업 15는 원래 자리를 지킵니다.
```$$,
 $$- 리스트의 노드 수는 `[0, 100]` 범위입니다.
- `0 <= Node.val <= 100`$$);
