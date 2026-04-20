-- Korean translations: batch 12 (problems #111-120)

------------------------------------------------------------
-- #111 car-convoy
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'car-convoy'),
    'ko',
    '차량 행렬',
    '목적지 `target` 마일 지점을 향해 편도 1차선 도로에서 `n`대의 차가 달리고 있습니다. 길이가 `n`인 두 정수 배열 `position`과 `speed`가 주어지며, `position[i]`는 `i`번째 차의 출발 위치(마일), `speed[i]`는 시속(마일/시간)입니다.

차는 앞에 있는 차를 추월할 수 없습니다. 빠른 차가 느린 차를 따라잡으면 느린 차의 속도에 맞춰 함께 이동합니다. 이렇게 선두 차량의 속도에 맞춰 함께 이동하는 한 대 이상의 차량 그룹을 **행렬(convoy)**이라 합니다.

목적지에 도착하는 행렬의 수를 반환하세요.

**예시 1:**
```
Input: target = 12, position = [10,8,0,5,3], speed = [2,4,1,1,3]
Output: 3
Explanation: 위치 10과 8의 차는 같은 시간에 도착하므로 하나의 행렬을 이룹니다. 위치 3의 차가 위치 5의 차를 따라잡아 두 번째 행렬을 만듭니다. 위치 0의 차는 혼자 세 번째 행렬이 됩니다.
```

**예시 2:**
```
Input: target = 10, position = [3], speed = [3]
Output: 1
```

**예시 3:**
```
Input: target = 100, position = [0,2,4], speed = [4,2,1]
Output: 1
Explanation: 위치 4의 차가 가장 느립니다. 뒤의 모든 차가 결국 따라잡아 하나의 행렬이 됩니다.
```',
    '- `1 <= n <= 10^5`
- `0 <= position[i] < target <= 10^9`
- `1 <= speed[i] <= 10^6`
- `position`의 모든 값은 서로 다릅니다'
);

------------------------------------------------------------
-- #112 tallest-bar
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'tallest-bar'),
    'ko',
    '최대 막대 직사각형',
    '음이 아닌 정수 배열 `heights`가 히스토그램을 나타냅니다. 각 원소는 너비 `1`인 막대의 높이입니다. 히스토그램 안에서 만들 수 있는 가장 큰 직사각형의 넓이를 반환하세요.

직사각형은 수평축에 정렬되어야 하며, 막대 아래에 완전히 들어가야 합니다.

**예시 1:**
```
Input: heights = [2,1,5,6,2,3]
Output: 10
Explanation: 인덱스 2, 3의 막대(높이 5, 6)에 걸쳐 넓이 = 5 * 2 = 10인 직사각형이 가장 큽니다.
```

**예시 2:**
```
Input: heights = [2,4]
Output: 4
```

**예시 3:**
```
Input: heights = [6,2,5,4,5,1,6]
Output: 12
Explanation: 인덱스 2~4에 걸쳐 최소 높이 4, 너비 3인 직사각형의 넓이 = 4 * 3 = 12가 가장 큽니다.
```',
    '- `1 <= heights.length <= 10^5`
- `0 <= heights[i] <= 10^4`'
);

------------------------------------------------------------
-- #113 space-rocks
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'space-rocks'),
    'ko',
    '우주 암석 충돌',
    '정수 배열 `rocks`가 일렬로 놓인 우주 암석들을 나타냅니다. 모든 충돌이 끝난 후 남아있는 암석의 상태를 구하세요.

각 원소의 절댓값은 암석의 크기를, 부호는 이동 방향을 나타냅니다. 양수는 오른쪽, 음수는 왼쪽으로 이동합니다.

충돌 규칙:
- 같은 방향으로 이동하는 암석은 충돌하지 않습니다.
- 오른쪽으로 이동하는 암석이 왼쪽으로 이동하는 암석을 만나면, 작은 쪽이 파괴됩니다.
- 두 암석의 크기가 같으면 둘 다 파괴됩니다.
- 반대 방향의 암석을 만나지 않는 암석은 그대로 남습니다.

모든 충돌이 끝난 후 남은 암석의 배열을 반환하세요.

**예시 1:**
```
Input: rocks = [5,10,-5]
Output: [5,10]
Explanation: 10과 -5가 충돌하여 10이 살아남습니다. 5와 10은 같은 방향이므로 충돌하지 않습니다.
```

**예시 2:**
```
Input: rocks = [8,-8]
Output: []
Explanation: 8과 -8은 크기가 같으므로 둘 다 파괴됩니다.
```

**예시 3:**
```
Input: rocks = [-2,-1,1,2]
Output: [-2,-1,1,2]
Explanation: 왼쪽으로 이동하는 암석이 이미 왼쪽에 있으므로 충돌이 발생하지 않습니다.
```',
    '- `2 <= rocks.length <= 10^4`
- `-1000 <= rocks[i] <= 1000`
- `rocks[i] != 0`'
);

------------------------------------------------------------
-- #114 time-map
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'time-map'),
    'ko',
    '타임스탬프 맵',
    '같은 키에 대해 서로 다른 타임스탬프로 여러 값을 저장하고, 주어진 타임스탬프 이하에서 가장 최근 값을 조회하는 자료구조를 설계하세요.

`TimeMap` 클래스를 구현하세요:

- `TimeMap()` 자료구조를 초기화합니다.
- `set(key, value, timestamp)` 주어진 `timestamp`에 `key`-`value` 쌍을 저장합니다.
- `get(key, timestamp)` `key`에 대해 `timestamp` 이하인 가장 큰 타임스탬프의 값을 반환합니다. 해당하는 값이 없으면 빈 문자열 `""`을 반환합니다.

각 키에 대한 `set` 호출의 타임스탬프는 항상 순증가합니다.

**예시 1:**
```
Input: ["TimeMap","set","get","get","set","get"]
       [[],["foo","bar",1],["foo",1],["foo",3],["foo","bar2",4],["foo",4]]
Output: [null,null,"bar","bar",null,"bar2"]
Explanation: set("foo", "bar", 1)은 타임스탬프 1에 "bar"를 저장합니다. get("foo", 1)은 "bar"를 반환합니다. get("foo", 3)은 타임스탬프 1 <= 3이므로 "bar"를 반환합니다. set("foo", "bar2", 4)는 타임스탬프 4에 "bar2"를 저장합니다. get("foo", 4)는 "bar2"를 반환합니다.
```

**예시 2:**
```
Input: ["TimeMap","set","set","get","get","get"]
       [[],["hello","world",1],["hello","code",2],["hello",1],["hello",2],["hello",3]]
Output: [null,null,null,"world","code","code"]
Explanation: get("hello", 1)은 "world"를 반환합니다. get("hello", 2)는 "code"를 반환합니다. get("hello", 3)은 타임스탬프 2 <= 3이므로 "code"를 반환합니다.
```

**예시 3:**
```
Input: ["TimeMap","set","get","get"]
       [[],["key","val",5],["key",3],["key",5]]
Output: [null,null,"","val"]
Explanation: get("key", 3)은 타임스탬프 3 이하에 저장된 값이 없으므로 ""를 반환합니다. get("key", 5)는 "val"을 반환합니다.
```',
    '- `1 <= key.length, value.length <= 100`
- `1 <= timestamp <= 10^7`
- 각 키에 대한 set 호출의 타임스탬프는 순증가합니다
- `set`과 `get` 호출은 최대 `2 * 10^5`회입니다'
);

------------------------------------------------------------
-- #115 sorted-median
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sorted-median'),
    'ko',
    '정렬된 배열의 중앙값',
    '오름차순으로 정렬된 두 정수 배열 `nums1`과 `nums2`가 주어졌을 때, 두 배열을 합친 전체의 **중앙값**을 반환하세요.

중앙값은 모든 원소를 정렬했을 때 가운데 위치한 값입니다. 전체 원소 수가 짝수인 경우에는 가운데 두 값의 평균입니다.

풀이의 시간 복잡도는 `O(log(m + n))`이어야 합니다. 여기서 `m`은 `nums1`의 길이, `n`은 `nums2`의 길이입니다.

**예시 1:**
```
Input: nums1 = [1,3], nums2 = [2]
Output: 2.0
Explanation: 합친 배열은 [1,2,3]이고, 가운데 원소는 2입니다.
```

**예시 2:**
```
Input: nums1 = [1,2], nums2 = [3,4]
Output: 2.5
Explanation: 합친 배열은 [1,2,3,4]이고, 가운데 두 원소 2와 3의 평균은 (2 + 3) / 2 = 2.5입니다.
```

**예시 3:**
```
Input: nums1 = [], nums2 = [7]
Output: 7.0
Explanation: 한 배열이 비어있으므로 중앙값은 7입니다.
```',
    '- `0 <= nums1.length, nums2.length <= 1000`
- `1 <= nums1.length + nums2.length <= 2000`
- `-10^6 <= nums1[i], nums2[i] <= 10^6`
- 두 배열 모두 오름차순으로 정렬되어 있습니다'
);

------------------------------------------------------------
-- #116 matrix-search-ii
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'matrix-search-ii'),
    'ko',
    '행렬 검색 II',
    '`m x n` 정수 행렬과 정수 `target`이 주어졌을 때, 행렬에 `target`이 존재하면 `true`를, 아니면 `false`를 반환하세요.

행렬은 다음과 같은 특성을 가집니다:
- 각 행은 왼쪽에서 오른쪽으로 오름차순 정렬되어 있습니다.
- 각 열은 위에서 아래로 오름차순 정렬되어 있습니다.

단, 완전히 펼친 정렬 행렬과 달리, 한 행의 첫 원소가 이전 행의 마지막 원소보다 반드시 크지는 **않습니다**.

**예시 1:**
```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 5
Output: true
```

**예시 2:**
```
Input: matrix = [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]], target = 20
Output: false
```

**예시 3:**
```
Input: matrix = [[-5,-3],[2,4]], target = -3
Output: true
Explanation: -3은 첫 번째 행에 있습니다.
```',
    '- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 300`
- `-10^9 <= matrix[i][j] <= 10^9`
- `-10^9 <= target <= 10^9`'
);

------------------------------------------------------------
-- #117 ship-capacity
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ship-capacity'),
    'ko',
    '화물선 적재량',
    '컨베이어 벨트 위의 화물을 `days`일 이내에 한 항구에서 다른 항구로 운송해야 합니다. 정수 배열 `weights`가 주어지며, `weights[i]`는 `i`번째 화물의 무게입니다.

매일 벨트에 놓인 순서대로 화물을 배에 실으며, 다음 화물을 실으면 적재 용량을 초과하는 경우 출항합니다. 다음 날 남은 화물부터 다시 싣기 시작하며, 모든 화물이 운송될 때까지 반복합니다.

모든 화물을 `days`일 이내에 운송할 수 있는 최소 적재 용량을 반환하세요.

**예시 1:**
```
Input: weights = [1,2,3,4,5,6,7,8,9,10], days = 5
Output: 15
Explanation: 적재 용량 15이면 5일에 운송 가능합니다: [1,2,3,4,5], [6,7], [8], [9], [10].
```

**예시 2:**
```
Input: weights = [3,2,2,4,1,4], days = 3
Output: 6
Explanation: 적재 용량 6이면 3일에 운송 가능합니다: [3,2], [2,4], [1,4].
```

**예시 3:**
```
Input: weights = [1,2,3,1,1], days = 4
Output: 3
Explanation: 적재 용량 3이면 4일에 운송 가능합니다: [1,2], [3], [1,1]. 하루가 남습니다.
```',
    '- `1 <= days <= weights.length <= 5 * 10^4`
- `1 <= weights[i] <= 500`'
);

------------------------------------------------------------
-- #118 recent-cache
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'recent-cache'),
    'ko',
    'LRU 캐시',
    '최대 용량이 정해진 캐시를 설계하세요. 캐시가 가득 차면 **가장 오래 사용되지 않은(least recently used)** 항목을 제거합니다.

`RecentCache` 클래스를 구현하세요:

- `RecentCache(int capacity)` 주어진 양의 정수 용량으로 캐시를 생성합니다.
- `int get(int key)` `key`에 해당하는 값이 있으면 반환하고, 없으면 `-1`을 반환합니다. 키에 접근하면 최근 사용으로 표시됩니다.
- `void put(int key, int value)` `key`-`value` 쌍을 삽입하거나 갱신합니다. 이미 `key`가 존재하면 값을 갱신하고 최근 사용으로 표시합니다. 새로운 키를 삽입할 때 용량을 초과하면 가장 오래 사용되지 않은 항목을 먼저 제거합니다.

`get`과 `put` 모두 평균 **O(1)** 시간에 동작해야 합니다.

**예시 1:**
```
Input: ["RecentCache","put","put","get","put","get","put","get","get","get"] [[2],[1,10],[2,20],[1],[3,30],[2],[4,40],[1],[3],[4]]
Output: [null,null,null,10,null,-1,null,-1,30,40]
Explanation: 캐시 용량은 2입니다.
put(1,10) -> 캐시: {1=10}
put(2,20) -> 캐시: {1=10, 2=20}
get(1)    -> 10 반환, 캐시: {2=20, 1=10}
put(3,30) -> 키 2 제거, 캐시: {1=10, 3=30}
get(2)    -> -1 반환 (제거됨)
put(4,40) -> 키 1 제거, 캐시: {3=30, 4=40}
get(1)    -> -1 반환 (제거됨)
get(3)    -> 30 반환
get(4)    -> 40 반환
```

**예시 2:**
```
Input: ["RecentCache","put","get","put","get","get"] [[1],[5,100],[5],[6,200],[5],[6]]
Output: [null,null,100,null,-1,200]
Explanation: 용량이 1이므로 매번 put할 때 이전 항목이 제거됩니다.
```

**예시 3:**
```
Input: ["RecentCache","put","put","put","get","get","get"] [[3],[1,1],[2,2],[3,3],[1],[2],[3]]
Output: [null,null,null,null,1,2,3]
Explanation: 용량이 3이므로 세 항목 모두 제거 없이 저장됩니다.
```',
    '- `1 <= capacity <= 3000`
- `0 <= key <= 10^4`
- `0 <= value <= 10^5`
- `get`과 `put` 호출은 최대 `2 * 10^5`회입니다'
);

------------------------------------------------------------
-- #119 reverse-k-nodes
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reverse-k-nodes'),
    'ko',
    'K개씩 노드 뒤집기',
    '단일 연결 리스트의 `head`와 정수 `k`가 주어졌을 때, `k`개씩 연속된 노드 그룹을 뒤집어서 수정된 리스트를 반환하세요.

끝부분에 남은 노드 수가 `k`개 미만이면 원래 순서를 유지합니다.

노드의 값이 아닌 연결(link) 자체를 변경해야 합니다.

**예시 1:**
```
Input: head = [1,2,3,4,5], k = 2
Output: [2,1,4,3,5]
Explanation: (1,2)와 (3,4) 쌍이 뒤집힙니다. 노드 5는 짝이 없어 그대로 남습니다.
```

**예시 2:**
```
Input: head = [1,2,3,4,5], k = 3
Output: [3,2,1,4,5]
Explanation: 처음 세 노드가 뒤집히고, 나머지 두 노드는 그대로 유지됩니다.
```

**예시 3:**
```
Input: head = [1,2,3,4], k = 1
Output: [1,2,3,4]
Explanation: k = 1이면 각 그룹이 노드 하나이므로 변경 없습니다.
```',
    '- 리스트의 노드 수는 `n`입니다
- `1 <= k <= n <= 5000`
- `0 <= Node.val <= 1000`'
);

------------------------------------------------------------
-- #120 swap-pairs
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'swap-pairs'),
    'ko',
    '노드 쌍 교환',
    '단일 연결 리스트의 `head`가 주어졌을 때, 인접한 두 노드씩 교환하여 수정된 리스트의 헤드를 반환하세요.

노드의 값이 아닌 연결(link) 자체를 변경해야 합니다. 리스트의 노드 수가 홀수이면 마지막 노드는 그대로 남습니다.

**예시 1:**
```
Input: head = [1,2,3,4]
Output: [2,1,4,3]
Explanation: 쌍별로 교환됩니다: (1,2)는 (2,1)로, (3,4)는 (4,3)으로 바뀝니다.
```

**예시 2:**
```
Input: head = [5,10]
Output: [10,5]
Explanation: 하나의 쌍이 교환됩니다.
```

**예시 3:**
```
Input: head = [1,2,3]
Output: [2,1,3]
Explanation: 첫 번째 쌍이 교환되고, 3은 짝이 없으므로 끝에 그대로 남습니다.
```',
    '- `0 <= Number of nodes <= 100`
- `0 <= Node.val <= 100`'
);
