-- Korean translations: batch 18 (problems #171-180)

------------------------------------------------------------
-- #171 longest-climb
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-climb'),
    'ko',
    '최장 증가 경로',
    '`m x n` 정수 행렬이 주어질 때, **순증가하는 가장 긴 경로**의 길이를 구하세요.

각 칸에서 상하좌우 네 방향으로 이동할 수 있으며, 인접한 칸의 값이 현재 칸보다 **순수하게 클 때**만 이동 가능합니다. 경로의 시작점과 끝점은 어디든 상관없습니다.

행렬에서 가장 긴 증가 경로의 길이를 반환하세요.

**예시 1:**
```
Input: matrix = [[9,9,4],[6,6,8],[2,1,1]]
Output: 4
Explanation: 가장 긴 증가 경로는 1 -> 2 -> 6 -> 9이며, 길이는 4입니다.
```

**예시 2:**
```
Input: matrix = [[3,4,5],[3,2,6],[2,2,1]]
Output: 4
Explanation: 가장 긴 증가 경로 중 하나는 3 -> 4 -> 5 -> 6입니다.
```

**예시 3:**
```
Input: matrix = [[1]]
Output: 1
Explanation: 칸이 하나뿐이면 경로 길이는 1입니다.
```',
    '- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 200`
- `0 <= matrix[i][j] <= 2^31 - 1`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #172 hand-grouping
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'hand-grouping'),
    'ko',
    '카드 그룹 나누기',
    '정수 배열 `hand`(카드 모음)와 정수 `groupSize`가 주어집니다.

카드를 재배열하여 각 그룹이 정확히 `groupSize`개의 **연속된 정수**로 이루어지도록 나눌 수 있는지 판별하세요. 모든 카드는 정확히 하나의 그룹에 속해야 합니다.

가능하면 `true`를, 불가능하면 `false`를 반환하세요.

**예시 1:**
```
Input: hand = [1,2,3,6,2,3,4,7,8], groupSize = 3
Output: true
Explanation: [1,2,3], [2,3,4], [6,7,8]로 나눌 수 있습니다.
```

**예시 2:**
```
Input: hand = [1,2,3,4,5], groupSize = 4
Output: false
Explanation: 카드 5장을 4장씩 그룹으로 나눌 수 없습니다.
```

**예시 3:**
```
Input: hand = [5,1], groupSize = 1
Output: true
Explanation: 각 카드가 크기 1인 그룹을 형성합니다.
```',
    '- `1 <= hand.length <= 10^4`
- `0 <= hand[i] <= 10^9`
- `1 <= groupSize <= hand.length`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #173 label-splitter
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'label-splitter'),
    'ko',
    '라벨 분할',
    '소문자 영어로 이루어진 문자열 `s`가 주어질 때, 각 문자가 **하나의 구간에만** 등장하도록 최대한 많은 구간으로 나누세요.

구간들을 순서대로 이어 붙이면 원래 문자열 `s`가 되어야 합니다.

각 구간의 길이를 배열로 반환하세요.

**예시 1:**
```
Input: s = "abacbc"
Output: [6]
Explanation: ''a'', ''b'', ''c''가 서로 겹치므로 전체 문자열이 하나의 구간입니다.
```

**예시 2:**
```
Input: s = "abcadefg"
Output: [4,4]
Explanation: ''a''가 인덱스 0과 3에 나타나므로 첫 구간은 "abca"(길이 4)입니다. 나머지 "defg"는 공유 문자가 없어 두 번째 구간(길이 4)이 됩니다.
```

**예시 3:**
```
Input: s = "xyz"
Output: [1,1,1]
Explanation: 각 문자가 한 번만 나타나므로 각각 독립된 구간이 됩니다.
```',
    '- `1 <= s.length <= 500`
- s는 소문자 영어로 구성됩니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #174 flexible-brackets
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flexible-brackets'),
    'ko',
    '유연한 괄호',
    '`''(''`, `'')''`, `''*''` 세 종류의 문자만 포함하는 문자열 `s`가 주어질 때, 올바른 괄호 문자열을 만들 수 있는지 판별하세요.

`''*''` 문자는 **유연**하게 처리할 수 있습니다:
- 여는 괄호 `''(''`로 취급
- 닫는 괄호 `'')''`로 취급
- 빈 문자열로 취급 (제거)

모든 여는 괄호에 대응하는 닫는 괄호가 올바른 순서로 있으면 괄호 문자열이 유효합니다.

유효하게 만들 수 있으면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: s = "(*))"
Output: true
Explanation: ''*''를 ''(''로 취급하면 여분의 '')''와 짝이 맞습니다.
```

**예시 2:**
```
Input: s = "(**)"
Output: true
Explanation: 두 ''*''를 빈 문자열로 취급하면 "()"가 되어 유효합니다.
```

**예시 3:**
```
Input: s = ")("
Output: false
Explanation: 와일드카드가 없어 순서를 고칠 수 없습니다.
```',
    '- `1 <= s.length <= 100`
- `s[i]`는 ''('', '')'', 또는 ''*'''
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #175 triplet-former
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'triplet-former'),
    'ko',
    '트리플렛 만들기',
    '세 정수로 이루어진 배열인 `triplets` 리스트와 목표 트리플렛 `target = [x, y, z]`가 주어집니다.

트리플렛의 부분집합을 골라 각 위치에서 **최댓값**을 취하여 결합할 수 있습니다. 트리플렛 `t1, t2, ..., tk`를 선택하면 결과는 `[max(t1[0], ..., tk[0]), max(t1[1], ..., tk[1]), max(t1[2], ..., tk[2])]`입니다.

이런 방식으로 정확히 `target`을 만들 수 있으면 `true`를, 아니면 `false`를 반환하세요.

단, 트리플렛의 어떤 값이라도 `target`의 대응 값보다 크면 해당 트리플렛은 선택할 수 없습니다. 예를 들어 `target`이 `[2, 4, 5]`일 때 `[2, 5, 3]`은 위치 1에서 `5 > 4`이므로 사용 불가합니다.

**예시 1:**
```
Input: triplets = [[2,5,3],[1,8,4],[1,7,5]], target = [2,7,5]
Output: true
Explanation: [2,5,3]과 [1,7,5]를 선택하면 각 위치의 최댓값이 [2,7,5]가 됩니다.
```

**예시 2:**
```
Input: triplets = [[3,4,5],[4,5,6]], target = [3,2,5]
Output: false
Explanation: 위치 1에 값 2를 가진 트리플렛이 없으므로 [3,2,5]를 만들 수 없습니다.
```

**예시 3:**
```
Input: triplets = [[2,5,3],[2,3,4],[1,2,5],[5,2,3]], target = [5,5,5]
Output: true
Explanation: [2,5,3], [1,2,5], [5,2,3]을 선택하면 각 위치의 최댓값이 [5,5,5]가 됩니다.
```',
    '- `1 <= triplets.length <= 10^5`
- `triplets[i].length == 3`
- `1 <= triplets[i][j], target[j] <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #176 height-queue
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'height-queue'),
    'ko',
    '키 순서 대기열',
    '`people` 리스트가 주어지며, 각 사람은 `[h, k]` 쌍으로 표현됩니다:

- `h`는 그 사람의 키입니다.
- `k`는 이 사람 **앞에** 서 있는 사람 중 키가 `h` **이상**인 사람의 수입니다.

사람들이 순서 없이 주어질 때, 모든 사람의 `k` 조건을 만족하도록 대기열을 복원하여 반환하세요.

유효한 배치가 반드시 존재합니다.

**예시 1:**
```
Input: people = [[7,0],[4,4],[7,1],[5,0],[6,1],[5,2]]
Output: [[5,0],[7,0],[5,2],[6,1],[4,4],[7,1]]
```

**예시 2:**
```
Input: people = [[6,0],[5,0],[4,0],[3,2],[2,2],[1,4]]
Output: [[4,0],[5,0],[2,2],[3,2],[1,4],[6,0]]
```

**예시 3:**
```
Input: people = [[3,0],[3,1]]
Output: [[3,0],[3,1]]
```',
    '- `1 <= people.length <= 2000`
- `0 <= h <= 10^6`
- `0 <= k < people.length`
- 유효한 대기열 배치가 반드시 존재합니다'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #177 almost-sorted
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'almost-sorted'),
    'ko',
    '거의 정렬된 배열',
    '정수 배열 `nums`가 주어질 때, 원소를 **최대 하나** 수정하여 배열을 **비내림차순**으로 만들 수 있는지 판별하세요.

배열이 비내림차순이란 `0 <= i < nums.length - 1`인 모든 `i`에 대해 `nums[i] <= nums[i + 1]`을 만족하는 것입니다.

최대 한 번의 수정으로 비내림차순을 만들 수 있으면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: nums = [4,2,3]
Output: true
Explanation: 4를 1로 바꾸면 [1,2,3]이 되어 비내림차순입니다.
```

**예시 2:**
```
Input: nums = [4,2,1]
Output: false
Explanation: 한 번의 수정으로는 비내림차순을 만들 수 없습니다.
```

**예시 3:**
```
Input: nums = [3,4,2,3]
Output: false
```',
    '- `1 <= nums.length <= 10^4`
- `-10^5 <= nums[i] <= 10^5`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #178 room-checker
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'room-checker'),
    'ko',
    '일정 충돌 검사',
    '시간 구간 배열 `intervals`가 주어지며, 각 구간은 예약된 일정 `[start, end]`입니다. 모든 일정을 겹침 없이 참석할 수 있는지 판별하세요.

두 일정이 **충돌**하려면 한 일정이 다른 일정이 끝나기 전에 시작해야 합니다. 한 일정이 끝나는 시점과 다른 일정이 시작하는 시점이 동일한 경우는 충돌하지 **않습니다**.

겹치는 일정이 없으면 `true`를, 있으면 `false`를 반환하세요.

**예시 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: false
Explanation: [0,30]이 [5,10], [15,20]과 모두 겹칩니다.
```

**예시 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: true
```

**예시 3:**
```
Input: intervals = [[1,5],[5,10],[10,15]]
Output: true
Explanation: 한 일정이 끝나는 시점에 다음 일정이 시작하면 충돌이 아닙니다.
```',
    '- `0 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start < end <= 10^6`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #179 query-intervals
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'query-intervals'),
    'ko',
    '구간 쿼리',
    '2차원 정수 배열 `intervals`(각 원소 `[start, end]`는 양쪽 끝을 포함하는 구간)와 정수 배열 `queries`가 주어집니다. 각 쿼리 값은 수직선 위의 한 점입니다.

각 쿼리에 대해 해당 점을 포함하는 구간 중 **가장 작은 크기**를 구하세요. 구간 `[start, end]`의 크기는 `end - start + 1`입니다. 해당 점을 포함하는 구간이 없으면 `-1`을 반환합니다.

`queries[i]`에 대한 답을 `i`번째 원소로 하는 배열을 반환하세요.

**예시 1:**
```
Input: intervals = [[1,4],[2,4],[3,6],[2,8]], queries = [2,3,4,5]
Output: [3,3,3,4]
Explanation: 쿼리 2의 경우, [1,4](크기 4), [2,4](크기 3), [2,8](크기 7)이 포함하며 가장 작은 것은 크기 3인 [2,4]입니다. 쿼리 5의 경우, [3,6](크기 4)과 [2,8](크기 7)이 포함하며 가장 작은 크기는 4입니다.
```

**예시 2:**
```
Input: intervals = [[2,3],[2,5],[1,8],[20,25]], queries = [2,19,5,22]
Output: [2,-1,4,6]
Explanation: 쿼리 19를 포함하는 구간이 없으므로 -1입니다. 쿼리 22의 경우 [20,25](크기 6)만 포함합니다.
```

**예시 3:**
```
Input: intervals = [[1,1]], queries = [1,2]
Output: [1,-1]
Explanation: 유일한 구간 [1,1]은 크기 1이며, 쿼리 1은 포함하지만 쿼리 2는 포함하지 않습니다.
```',
    '- `1 <= intervals.length <= 10^5`
- `1 <= queries.length <= 10^5`
- `1 <= start <= end <= 10^7`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #180 arrow-shooter
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'arrow-shooter'),
    'ko',
    '화살 쏘기',
    '2D 공간에 떠 있는 `targets` 리스트가 주어집니다. 각 타겟은 수평 구간 `[start, end]`로, x좌표 `start`부터 `end`까지를 차지합니다(양 끝 포함).

x축에서 수직으로 화살을 쏠 수 있습니다. 위치 `x`에서 쏜 화살은 `start <= x <= end`인 모든 타겟을 파괴합니다.

모든 타겟을 파괴하는 데 필요한 **최소 화살 수**를 반환하세요.

**예시 1:**
```
Input: targets = [[10,16],[2,8],[1,6],[7,12]]
Output: 2
Explanation: x = 6에서 쏘면 [2,8]과 [1,6]을, x = 11에서 쏘면 [10,16]과 [7,12]를 맞힙니다.
```

**예시 2:**
```
Input: targets = [[1,2],[3,4],[5,6],[7,8]]
Output: 4
Explanation: 겹치는 타겟이 없으므로 각각 화살이 필요합니다.
```

**예시 3:**
```
Input: targets = [[1,2],[2,3],[3,4],[4,5]]
Output: 2
Explanation: x = 2에서 쏘면 [1,2]와 [2,3]을, x = 4에서 쏘면 [3,4]와 [4,5]를 맞힙니다.
```',
    '- `1 <= targets.length <= 10^5`
- `targets[i].length == 2`
- `-2^31 <= start <= end <= 2^31 - 1`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
