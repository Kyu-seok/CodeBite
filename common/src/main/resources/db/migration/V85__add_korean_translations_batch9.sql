-- Korean translations: batch 9 (problems #81-90)

------------------------------------------------------------
-- #81 phone-combos
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'phone-combos'),
    'ko',
    '전화번호 조합',
    '`2`부터 `9`까지의 숫자로 이루어진 문자열이 주어졌을 때, 해당 숫자들이 나타낼 수 있는 모든 문자 조합을 반환하세요. 결과 순서는 상관없습니다.

전화기 키패드처럼, 각 숫자는 다음과 같은 문자에 대응됩니다:

- `2`: abc
- `3`: def
- `4`: ghi
- `5`: jkl
- `6`: mno
- `7`: pqrs
- `8`: tuv
- `9`: wxyz

`1`은 어떤 문자에도 대응되지 않습니다.

**예시 1:**
```
Input: digits = "23"
Output: ["ad","ae","af","bd","be","bf","cd","ce","cf"]
Explanation: 2는 "abc", 3은 "def"에 대응되므로, 각 숫자에서 한 글자씩 선택한 모든 조합을 구합니다.
```

**예시 2:**
```
Input: digits = ""
Output: []
Explanation: 빈 입력이면 조합이 없습니다.
```

**예시 3:**
```
Input: digits = "2"
Output: ["a","b","c"]
```',
    '- `0 <= digits.length <= 4`
- `digits[i]`는 `[''2'', ''9'']` 범위의 숫자입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #82 pacific-atlantic
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pacific-atlantic'),
    'ko',
    '태평양-대서양',
    '두 대양에 접한 `m x n` 크기의 직사각형 섬이 주어집니다. **태평양**은 섬의 위쪽과 왼쪽 가장자리에, **대서양**은 오른쪽과 아래쪽 가장자리에 접해 있습니다.

섬은 정수 높이 격자로 표현되며, `heights[r][c]`는 행 `r`, 열 `c` 셀의 고도입니다.

비가 오면, 물은 현재 셀의 높이보다 **같거나 낮은** 상하좌우 인접 셀로 흐릅니다. 대양에 직접 접한 셀에서는 바다로 물이 흘러나갑니다.

빗물이 태평양과 대서양 **모두**에 도달할 수 있는 모든 좌표 `[r, c]`를 반환하세요.

**예시 1:**
```
Input: heights = [[1,2,2,3,5],[3,2,3,4,4],[2,4,5,3,1],[6,7,1,4,5],[5,1,1,2,4]]
Output: [[0,4],[1,3],[1,4],[2,2],[3,0],[3,1],[4,0]]
Explanation: 셀 [2,2](높이 5)에서 물은 왼쪽/위로 흘러 태평양에, 오른쪽/아래로 흘러 대서양에 도달합니다.
```

**예시 2:**
```
Input: heights = [[1]]
Output: [[0,0]]
Explanation: 셀이 하나뿐이므로 양쪽 대양 모두에 접합니다.
```',
    '- `m == heights.length`
- `n == heights[r].length`
- `1 <= m, n <= 200`
- `0 <= heights[r][c] <= 10^5`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #83 course-order
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'course-order'),
    'ko',
    '수강 순서',
    '`0`부터 `numCourses - 1`까지 번호가 매겨진 `numCourses`개의 과목이 있습니다. 배열 `prerequisites`에서 `prerequisites[i] = [a, b]`는 과목 `a`를 수강하려면 과목 `b`를 먼저 이수해야 한다는 뜻입니다.

모든 과목을 이수할 수 있는 수강 순서를 반환하세요. 유효한 순서가 여러 개이면 아무거나 반환해도 됩니다. 선수과목 관계에 순환이 있어 모든 과목을 이수할 수 없다면, 빈 배열을 반환하세요.

**예시 1:**
```
Input: numCourses = 2, prerequisites = [[1,0]]
Output: [0,1]
Explanation: 과목이 2개입니다. 과목 1을 수강하려면 과목 0을 먼저 이수해야 하므로, 올바른 순서는 [0,1]입니다.
```

**예시 2:**
```
Input: numCourses = 4, prerequisites = [[1,0],[2,0],[3,1],[3,2]]
Output: [0,1,2,3] or [0,2,1,3]
Explanation: 두 순서 모두 모든 선수과목 조건을 만족합니다. 과목 0은 선수과목이 없으므로 맨 앞에 오고, 과목 3은 1과 2에 모두 의존합니다.
```

**예시 3:**
```
Input: numCourses = 1, prerequisites = []
Output: [0]
```',
    '- `1 <= numCourses <= 2000`
- `0 <= prerequisites.length <= numCourses * (numCourses - 1)`
- `prerequisites[i].length == 2`
- `0 <= a, b < numCourses`
- `a != b`
- 모든 `[a, b]` 쌍은 고유합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #84 connected-components
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'connected-components'),
    'ko',
    '연결 요소',
    '`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 노드로 이루어진 그래프가 주어집니다. 정수 `n`과 배열 `edges`가 주어지며, `edges[i] = [a, b]`는 노드 `a`와 `b` 사이의 양방향 간선을 나타냅니다.

그래프에서 **연결 요소**의 개수를 반환하세요. 연결 요소란, 그룹 안의 모든 노드가 어떤 경로로든 서로 도달할 수 있는 노드들의 집합입니다.

**예시 1:**
```
Input: n = 5, edges = [[0,1],[1,2],[3,4]]
Output: 2
Explanation: 노드 0, 1, 2가 하나의 컴포넌트를 이루고, 노드 3, 4가 또 다른 컴포넌트를 이룹니다.
```

**예시 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[3,4]]
Output: 1
Explanation: 모든 노드가 간선으로 연결되어 하나의 컴포넌트를 이룹니다.
```',
    '- `1 <= n <= 2000`
- `0 <= edges.length <= 5000`
- `edges[i].length == 2`
- `0 <= a, b < n`
- `a != b`
- 중복 간선은 없습니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #85 rotting-oranges
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rotting-oranges'),
    'ko',
    '썩은 오렌지',
    '`m x n` 격자가 주어지며, 각 셀에는 다음 세 값 중 하나가 들어 있습니다:

- `0`: 빈 칸
- `1`: 신선한 오렌지
- `2`: 썩은 오렌지

매 분마다, 썩은 오렌지에 **상하좌우로 인접한** 신선한 오렌지는 모두 썩게 됩니다.

신선한 오렌지가 하나도 남지 않을 때까지 걸리는 최소 시간(분)을 반환하세요. 모든 오렌지를 썩게 만들 수 없다면 `-1`을 반환하세요.

**예시 1:**
```
Input: grid = [[2,1,1],[1,1,0],[0,1,1]]
Output: 4
Explanation: 왼쪽 위 모서리에서 썩기 시작하여, 4분 후 오른쪽 아래 오렌지까지 모두 썩게 됩니다.
```

**예시 2:**
```
Input: grid = [[2,1,1],[0,1,1],[1,0,1]]
Output: -1
Explanation: 왼쪽 아래 오렌지에는 썩음이 도달할 수 없습니다.
```

**예시 3:**
```
Input: grid = [[0,2]]
Output: 0
Explanation: 신선한 오렌지가 없으므로 답은 0입니다.
```',
    '- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 10`
- `grid[i][j]`는 `0`, `1`, 또는 `2`입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #86 account-merger
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'account-merger'),
    'ko',
    '계정 병합',
    '문자열 리스트의 리스트 `accounts`가 주어집니다. 각 `accounts[i]`의 첫 번째 원소 `accounts[i][0]`은 계정 소유자의 이름이고, 나머지 원소들은 해당 계정에 연결된 이메일 주소입니다.

같은 사람의 계정을 병합하세요. 두 계정이 같은 이메일 주소를 하나라도 공유하면, 같은 사람의 계정입니다. 단, 이름이 같더라도 다른 사람일 수 있습니다.

병합 후, 각 계정의 첫 번째 원소는 이름이고 나머지 이메일은 **정렬된 순서**로 반환하세요. 계정 자체의 순서는 상관없습니다.

**예시 1:**
```
Input: accounts = [["John","johnsmith@mail.com","john_newyork@mail.com"],["John","johnsmith@mail.com","john00@mail.com"],["Mary","mary@mail.com"],["John","johnnybravo@mail.com"]]
Output: [["John","john00@mail.com","john_newyork@mail.com","johnsmith@mail.com"],["John","johnnybravo@mail.com"],["Mary","mary@mail.com"]]
Explanation: 처음 두 "John" 계정이 "johnsmith@mail.com"을 공유하므로 이메일이 병합됩니다. 세 번째 "John"은 겹치는 이메일이 없어 별개로 남습니다.
```

**예시 2:**
```
Input: accounts = [["Gabe","Gabe0@m.co","Gabe3@m.co","Gabe1@m.co"],["Kevin","Kevin3@m.co","Kevin5@m.co","Kevin0@m.co"],["Ethan","Ethan5@m.co","Ethan4@m.co","Ethan0@m.co"],["Hanzo","Hanzo3@m.co","Hanzo1@m.co","Hanzo0@m.co"],["Fern","Fern5@m.co","Fern1@m.co","Fern0@m.co"]]
Output: [["Ethan","Ethan0@m.co","Ethan4@m.co","Ethan5@m.co"],["Fern","Fern0@m.co","Fern1@m.co","Fern5@m.co"],["Gabe","Gabe0@m.co","Gabe1@m.co","Gabe3@m.co"],["Hanzo","Hanzo0@m.co","Hanzo1@m.co","Hanzo3@m.co"],["Kevin","Kevin0@m.co","Kevin3@m.co","Kevin5@m.co"]]
Explanation: 공유하는 이메일이 없으므로, 각 계정의 이메일만 정렬됩니다.
```',
    '- `1 <= accounts.length <= 1000`
- `2 <= accounts[i].length <= 10`
- `1 <= accounts[i][j].length <= 30`
- `accounts[i][0]`은 영어 문자로 구성됩니다.
- `accounts[i][j]` (`j > 0`)는 유효한 이메일입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #87 house-thief-ii
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'house-thief-ii'),
    'ko',
    '도둑과 원형 거리',
    '거리에 줄지어 있는 집들을 털 계획인 도둑이 있습니다. 각 집에는 일정 금액의 돈이 숨겨져 있으며, 집들은 **원형으로 배치**되어 있어 첫 번째 집과 마지막 집이 이웃합니다.

인접한 두 집을 같은 밤에 털면 보안 시스템이 경찰에 신고합니다.

정수 배열 `nums`가 주어지고, `nums[i]`는 `i`번째 집의 금액입니다. 경보를 울리지 않고 오늘 밤 털 수 있는 최대 금액을 반환하세요.

**예시 1:**
```
Input: nums = [2,3,2]
Output: 3
Explanation: 1번 집(금액 2)과 3번 집(금액 2)은 인접하므로 동시에 털 수 없습니다.
```

**예시 2:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: 1번 집(금액 1)과 3번 집(금액 3)을 턴다. 합계 = 1 + 3 = 4.
```

**예시 3:**
```
Input: nums = [1,2,3]
Output: 3
```',
    '- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #88 decode-ways
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'decode-ways'),
    'ko',
    '메시지 디코딩',
    '`A`부터 `Z`까지의 문자를 다음과 같이 숫자로 인코딩할 수 있습니다:

```
''A'' -> "1"
''B'' -> "2"
...
''Z'' -> "26"
```

인코딩된 메시지를 디코딩하려면, 모든 숫자를 그룹으로 나눈 후 위 매핑의 역순으로 문자에 대응시킵니다. 숫자를 그룹으로 나누는 방법은 여러 가지일 수 있습니다.

숫자로만 이루어진 문자열 `s`가 주어졌을 때, 디코딩할 수 있는 **경우의 수**를 반환하세요. 정답은 32비트 정수 범위 내임이 보장됩니다.

`"06"`처럼 앞에 0이 붙는 그룹은 유효하지 않습니다. `"06"`은 어떤 문자에도 대응되지 않기 때문입니다.

**예시 1:**
```
Input: s = "12"
Output: 2
Explanation: "12"는 "AB" (1 2) 또는 "L" (12)로 디코딩할 수 있습니다.
```

**예시 2:**
```
Input: s = "226"
Output: 3
Explanation: "226"은 "BZ" (2 26), "VF" (22 6), 또는 "BBF" (2 2 6)로 디코딩할 수 있습니다.
```

**예시 3:**
```
Input: s = "06"
Output: 0
Explanation: 앞에 0이 붙으므로 "06"은 "F"로 매핑할 수 없습니다.
```',
    '- `1 <= s.length <= 100`
- `s`는 숫자로만 구성되며, 앞에 0이 올 수 있습니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #89 max-product-subarray
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'max-product-subarray'),
    'ko',
    '최대 곱 부분배열',
    '정수 배열 `nums`가 주어졌을 때, 원소가 하나 이상인 연속 부분배열 중 곱이 가장 큰 값을 반환하세요.

**부분배열**은 배열 내에서 연속된 원소들의 시퀀스입니다. 배열에는 양수, 음수, 0이 포함될 수 있습니다.

**예시 1:**
```
Input: nums = [2,3,-2,4]
Output: 6
Explanation: 부분배열 [2,3]의 곱 6이 최대입니다.
```

**예시 2:**
```
Input: nums = [-2,0,-1]
Output: 0
Explanation: [-2,-1]은 연속 부분배열이 아니므로 곱 2가 될 수 없습니다. 가장 큰 곱의 부분배열은 [0]으로, 결과는 0입니다.
```',
    '- `1 <= nums.length <= 2 * 10^4`
- `-10 <= nums[i] <= 10`
- `nums`의 어떤 부분배열의 곱도 32비트 정수 범위 내입니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #90 palindrome-count
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'palindrome-count'),
    'ko',
    '회문 부분문자열 개수',
    '문자열 `s`가 주어졌을 때, **회문(palindrome) 부분문자열**의 개수를 반환하세요.

**회문**은 앞에서 읽으나 뒤에서 읽으나 같은 문자열입니다. **부분문자열**은 문자열 내에서 연속된 문자 시퀀스입니다. 한 글자짜리 문자열은 항상 회문이며, 위치가 다른 동일한 부분문자열은 각각 별도로 셉니다.

**예시 1:**
```
Input: s = "abc"
Output: 3
Explanation: 회문 부분문자열은 "a", "b", "c"로 3개입니다.
```

**예시 2:**
```
Input: s = "aaa"
Output: 6
Explanation: 회문 부분문자열은 "a" 3개, "aa" 2개, "aaa" 1개로 총 6개입니다.
```',
    '- `1 <= s.length <= 1000`
- `s`는 소문자 영어 문자로 구성됩니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
