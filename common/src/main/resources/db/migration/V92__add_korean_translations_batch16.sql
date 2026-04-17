-- Korean translations: batch 16 (problems #151-160)

------------------------------------------------------------
-- #151 Symbol Order
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'symbol-order'),
    'ko',
    '문자 순서',
    '알 수 없는 언어의 알파벳 순서대로 정렬된 단어 목록이 주어집니다. 이 언어는 영어와 동일한 소문자 알파벳을 사용하지만, 문자의 순서가 다를 수 있습니다.

정렬된 단어 목록을 분석하여 이 언어의 문자 순서를 알아내세요. 올바른 순서로 나열된 문자열을 반환하세요. 유효한 순서가 존재하지 않으면 (예: 모순되는 규칙이 있는 경우) 빈 문자열 `""`을 반환하세요.

긴 단어가 자신의 접두사보다 앞에 오는 경우 (예: `"abc"`가 `"ab"` 앞), 접두사가 항상 먼저 와야 하므로 유효하지 않은 순서입니다.

**예시 1:**
```
Input: words = ["wrt","wrf","er","ett","rftt"]
Output: "wertf"
Explanation: 인접한 단어 쌍을 비교하면 t < f, w < e, r < t, e < r 순서를 알 수 있고, 이를 종합하면 w -> e -> r -> t -> f 순서가 됩니다.
```

**예시 2:**
```
Input: words = ["z","x"]
Output: "zx"
Explanation: z, x 쌍에서 이 언어에서는 z가 x보다 앞에 온다는 것을 알 수 있습니다.
```

**예시 3:**
```
Input: words = ["abc","ab"]
Output: ""
Explanation: "abc"가 "ab" 앞에 있지만, "ab"는 "abc"의 접두사입니다. 정렬된 목록에서 짧은 접두사가 먼저 와야 하므로 모순됩니다.
```',
    '- 입력 목록에는 최소 1개의 단어가 포함됩니다
- 모든 단어는 소문자 영어 알파벳으로만 구성됩니다
- 순서 관계가 없는 문자들이 있을 수 있으며, 이 경우 유효한 순서가 하나만 존재하도록 테스트 입력이 설계되어 있습니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #152 Extra Edge
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'extra-edge'),
    'ko',
    '여분의 간선',
    '원래 `1`부터 `n`까지 번호가 매겨진 `n`개의 노드로 이루어진 트리에 간선 하나가 추가되어 정확히 하나의 사이클이 생긴 무방향 그래프가 주어집니다. 그래프는 배열 `edges`로 표현되며, `edges[i] = [a, b]`는 노드 `a`와 `b` 사이의 무방향 연결을 나타냅니다.

제거하면 그래프가 다시 유효한 트리가 되는 여분의 간선을 찾아 반환하세요. 사이클을 끊을 수 있는 간선이 여러 개라면, `edges` 배열에서 가장 **마지막에** 나오는 간선을 반환하세요.

**예시 1:**
```
Input: edges = [[1,2],[1,3],[2,3]]
Output: [2,3]
Explanation: 원래 트리는 1-2와 1-3을 연결했습니다. 간선 [2,3]이 사이클 1-2-3-1을 만듭니다.
```

**예시 2:**
```
Input: edges = [[1,2],[2,3],[3,4],[1,4],[1,5]]
Output: [1,4]
Explanation: [1,4]를 제거하면 사이클 1-2-3-4-1이 끊어지고 유효한 트리가 복원됩니다.
```

**예시 3:**
```
Input: edges = [[1,2],[1,3],[1,4],[3,4]]
Output: [3,4]
Explanation: 간선 [3,4]가 노드 1을 거치는 경로와 함께 사이클을 형성합니다.
```',
    '- `n == edges.length`
- `3 <= n <= 1000`
- `edges[i].length == 2`
- `1 <= edges[i][0], edges[i][1] <= n`
- `edges[i][0] != edges[i][1]`
- 중복 간선은 없습니다
- 그래프는 연결되어 있고 정확히 하나의 사이클을 포함합니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #153 Airport Route
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'airport-route'),
    'ko',
    '공항 경로',
    '항공권 목록 `tickets`가 주어지며, 각 항공권은 세 글자 공항 코드를 사용하여 `[출발지, 도착지]`로 표현됩니다. 모든 항공권은 `"JFK"`에서 출발하는 한 여행자의 것입니다.

모든 항공권을 정확히 한 번씩 사용하는 전체 여행 경로를 재구성하세요. 유효한 경로가 여러 개 있다면, 단계별로 비교했을 때 **사전순으로 가장 작은** 경로를 반환하세요.

입력에는 유효한 경로가 최소 하나 존재함이 보장됩니다.

**예시 1:**
```
Input: tickets = [["MUC","LHR"],["JFK","MUC"],["SFO","SJC"],["LHR","SFO"]]
Output: ["JFK","MUC","LHR","SFO","SJC"]
Explanation: 여행 경로는 JFK -> MUC -> LHR -> SFO -> SJC이며, 4장의 항공권을 모두 사용합니다.
```

**예시 2:**
```
Input: tickets = [["JFK","SFO"],["JFK","ATL"],["SFO","ATL"],["ATL","JFK"],["ATL","SFO"]]
Output: ["JFK","ATL","JFK","SFO","ATL","SFO"]
Explanation: ["JFK","SFO","ATL","JFK","ATL","SFO"]도 모든 항공권을 사용하지만, 두 번째 위치에서 "ATL" < "SFO"이므로 ["JFK","ATL",...]이 사전순으로 더 작습니다.
```

**예시 3:**
```
Input: tickets = [["JFK","KUL"],["JFK","NRT"],["NRT","JFK"]]
Output: ["JFK","NRT","JFK","KUL"]
Explanation: JFK -> KUL을 먼저 선택하면 더 이상 진행할 수 없으므로, JFK -> NRT -> JFK -> KUL이 유효한 경로입니다.
```',
    '- `1 <= tickets.length <= 300`
- `tickets[i].length == 2`
- `departure_i`와 `arrival_i`는 3개의 대문자 영어 알파벳으로 구성됩니다
- `departure_i != arrival_i`
- 모든 항공권은 최소 하나의 유효한 경로를 형성합니다
- 경로는 항상 "JFK"에서 시작합니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #154 Longest Palindrome
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-palindrome'),
    'ko',
    '가장 긴 회문',
    '문자열 `s`가 주어졌을 때, 가장 긴 **회문 부분 문자열**의 길이를 반환하세요.

**회문 부분 문자열**이란 `s` 안의 연속된 문자 시퀀스로, 앞에서 읽으나 뒤에서 읽으나 같은 것을 말합니다. 예를 들어 `"racecar"`는 회문이지만 `"hello"`는 아닙니다.

**예시 1:**
```
Input: s = "babad"
Output: 3
Explanation: "bab"는 길이 3의 회문 부분 문자열입니다. "aba"도 정답입니다.
```

**예시 2:**
```
Input: s = "cbbd"
Output: 2
Explanation: "bb"가 가장 긴 회문 부분 문자열입니다.
```

**예시 3:**
```
Input: s = "x"
Output: 1
Explanation: 한 글자짜리 문자열은 항상 회문입니다.
```',
    '- `1 <= s.length <= 1000`
- s는 소문자 영어 알파벳으로만 구성됩니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #155 Cheap Stairs
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cheap-stairs'),
    'ko',
    '저렴한 계단',
    '정수 배열 `cost`가 주어지며, `cost[i]`는 `i`번째 계단을 밟을 때 내야 하는 비용입니다. 비용을 지불하면 한 칸 또는 두 칸 앞으로 올라갈 수 있습니다.

계단 `0` 또는 계단 `1`에서 출발할 수 있습니다. 계단의 **꼭대기**는 `cost`의 마지막 원소 바로 다음 위치(즉, 인덱스 `cost.length`)입니다.

꼭대기에 도달하기 위한 최소 비용을 반환하세요.

**예시 1:**
```
Input: cost = [10,15,20]
Output: 15
Explanation: 계단 1에서 시작(비용 15)하고, 두 칸 올라가면 꼭대기에 도달합니다. 총 비용 = 15.
```

**예시 2:**
```
Input: cost = [1,100,1,1,1,100,1,1,100,1]
Output: 6
Explanation: 계단 0에서 시작하여 비용이 큰 계단을 건너뛰며 올라갑니다. 총 비용 = 1 + 1 + 1 + 1 + 1 + 1 = 6.
```

**예시 3:**
```
Input: cost = [0,0]
Output: 0
Explanation: 어느 계단에서 시작하든 비용 없이 꼭대기에 도달할 수 있습니다.
```',
    '- `2 <= cost.length <= 1000`
- `0 <= cost[i] <= 999`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #156 Equal Partition
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'equal-partition'),
    'ko',
    '균등 분할',
    '양의 정수로 이루어진 비어 있지 않은 배열 `nums`가 주어졌을 때, 합이 같은 두 부분 집합으로 나눌 수 있는지 판별하세요.

부분 집합이란 배열에서 원소를 선택한 것이며, 각 원소는 최대 한 번만 사용할 수 있습니다. 두 부분 집합은 연속적이거나 크기가 같을 필요는 없고, 합만 같으면 됩니다. 두 부분 집합을 합치면 모든 원소를 포함해야 합니다.

그러한 분할이 가능하면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: nums = [1,5,11,5]
Output: true
Explanation: [1,5,5]와 [11]로 나눌 수 있으며, 두 부분 집합의 합은 모두 11입니다.
```

**예시 2:**
```
Input: nums = [1,2,3,5]
Output: false
Explanation: 배열을 합이 같은 두 부분 집합으로 나눌 수 없습니다.
```

**예시 3:**
```
Input: nums = [1,1]
Output: true
Explanation: 각 부분 집합에 1이 하나씩 들어가며, 두 합이 같습니다.
```',
    '- `1 <= nums.length <= 200`
- `1 <= nums[i] <= 100`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #157 Perfect Sum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'perfect-sum'),
    'ko',
    '완전 제곱수의 합',
    '양의 정수 `n`이 주어졌을 때, `n`을 **완전 제곱수**의 합으로 나타내는 데 필요한 최소 개수를 반환하세요.

**완전 제곱수**란 어떤 정수의 제곱과 같은 수입니다. 처음 몇 개의 완전 제곱수는 `1`, `4`, `9`, `16`, `25` 등입니다. 같은 완전 제곱수를 여러 번 사용할 수 있습니다.

**예시 1:**
```
Input: n = 12
Output: 3
Explanation: 12 = 4 + 4 + 4 (완전 제곱수 3개).
```

**예시 2:**
```
Input: n = 13
Output: 2
Explanation: 13 = 4 + 9 (완전 제곱수 2개).
```

**예시 3:**
```
Input: n = 1
Output: 1
Explanation: 1 자체가 완전 제곱수입니다.
```',
    '- `1 <= n <= 10000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #158 Nth Ugly
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'nth-ugly'),
    'ko',
    'N번째 못생긴 수',
    '**못생긴 수(ugly number)**란 소인수가 `2`, `3`, `5`만으로 이루어진 양의 정수입니다. 관례상 `1`은 소인수가 없지만 첫 번째 못생긴 수로 간주합니다.

정수 `n`이 주어졌을 때, 오름차순으로 `n`번째 못생긴 수를 반환하세요.

수열은 다음과 같이 시작합니다: `1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24, ...`

`7`은 `2`, `3`, `5` 이외의 소인수이므로 수열에 포함되지 않습니다.

**예시 1:**
```
Input: n = 10
Output: 12
Explanation: 처음 10개의 못생긴 수는 1, 2, 3, 4, 5, 6, 8, 9, 10, 12입니다.
```

**예시 2:**
```
Input: n = 1
Output: 1
Explanation: 1은 정의에 따라 첫 번째 못생긴 수입니다.
```

**예시 3:**
```
Input: n = 15
Output: 24
Explanation: 처음 15개의 못생긴 수는 1, 2, 3, 4, 5, 6, 8, 9, 10, 12, 15, 16, 18, 20, 24입니다.
```',
    '- `1 <= n <= 1690`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #159 Room Builder
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'room-builder'),
    'ko',
    '방 건설 순서',
    '`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 방이 있는 건물을 짓고 있습니다. 방들은 트리 형태의 의존 관계를 가지며, 각 방(방 `0` 제외)은 먼저 지어야 하는 선행 방이 정확히 하나 있습니다. 방 `0`은 루트이며 선행 조건이 없습니다.

길이 `n`의 배열 `prevRoom`이 주어지며, `prevRoom[i]`는 방 `i`를 짓기 전에 완성해야 하는 방 번호입니다. 방 `0`에는 선행 조건이 없으므로 `prevRoom[0] = -1`입니다.

`n`개의 방을 모두 짓는 **유효한 건설 순서의 수**를 반환하세요. 답이 매우 클 수 있으므로 `10^9 + 7`로 나눈 나머지를 반환하세요.

**예시 1:**
```
Input: prevRoom = [-1,0,0,1,1]
Output: 8
Explanation: 방 0을 먼저 지어야 합니다. 그 다음 방 1과 2는 순서에 관계없이 지을 수 있지만, 방 3과 4는 방 1이 먼저 완성되어야 합니다. 유효한 순서는 8가지입니다.
```

**예시 2:**
```
Input: prevRoom = [-1,0,1,2]
Output: 1
Explanation: 방들이 0 -> 1 -> 2 -> 3 체인을 형성하므로 유효한 건설 순서는 하나뿐입니다.
```

**예시 3:**
```
Input: prevRoom = [-1,0,0,0]
Output: 6
Explanation: 방 0을 먼저 짓고, 나머지 3개의 방은 어떤 순서로든 지을 수 있으므로 3! = 6가지입니다.
```',
    '- `1 <= n <= 10^5`
- `prevRoom.length == n`
- `prevRoom[0] == -1`
- `0 <= prevRoom[i] < n` (i >= 1인 경우)
- 입력은 방들이 유효한 트리를 형성함을 보장합니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #160 Break Integer
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'break-integer'),
    'ko',
    '정수 쪼개기',
    '양의 정수 `n`이 주어졌을 때, 최소 두 개의 양의 정수의 합으로 나누고, 그 조각들의 **최대 곱**을 반환하세요.

`n`을 합이 `n`인 두 개 이상의 양의 정수로 분할해야 합니다. 가능한 모든 분할 중에서 조각들의 곱이 최대가 되는 것을 찾으세요.

**예시 1:**
```
Input: n = 2
Output: 1
Explanation: 2 = 1 + 1이고, 1 x 1 = 1입니다.
```

**예시 2:**
```
Input: n = 7
Output: 12
Explanation: 7 = 3 + 4이고, 3 x 4 = 12입니다.
```

**예시 3:**
```
Input: n = 10
Output: 36
Explanation: 10 = 3 + 3 + 4이고, 3 x 3 x 4 = 36입니다.
```',
    '- `2 <= n <= 58`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
