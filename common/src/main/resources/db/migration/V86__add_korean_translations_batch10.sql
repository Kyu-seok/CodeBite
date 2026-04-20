-- Korean translations: batch 10 (problems #91-100)

------------------------------------------------------------
-- #91 unique-paths
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-paths'),
    'ko',
    '고유 경로',
    '`m x n` 격자의 크기를 나타내는 두 정수 `m`과 `n`이 주어집니다.

로봇이 격자의 왼쪽 상단 (`[0, 0]`)에서 출발하여 오른쪽 하단 (`[m - 1, n - 1]`)까지 이동하려 합니다. 로봇은 매 단계에서 **오른쪽** 또는 **아래쪽**으로만 이동할 수 있습니다.

오른쪽 하단에 도달할 수 있는 고유한 경로의 총 개수를 반환하세요.

**예시 1:**
```
Input: m = 3, n = 7
Output: 28
```

**예시 2:**
```
Input: m = 3, n = 2
Output: 3
Explanation: 왼쪽 상단에서 오른쪽 하단까지 정확히 3가지 경로가 있습니다:
1. Right -> Down -> Down
2. Down -> Down -> Right
3. Down -> Right -> Down
```',
    '- `1 <= m, n <= 100`'
);

------------------------------------------------------------
-- #92 longest-common-subseq
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-common-subseq'),
    'ko',
    '최장 공통 부분 수열',
    '두 문자열 `text1`과 `text2`가 주어졌을 때, **최장 공통 부분 수열**의 길이를 반환하세요. 공통 부분 수열이 없으면 `0`을 반환합니다.

**부분 수열**이란 원래 순서를 유지하면서 연속하지 않아도 되는 문자들의 나열입니다. 예를 들어, `"ace"`는 `"abcde"`에서 `b`와 `d`를 제거하면 얻을 수 있으므로 부분 수열입니다.

**예시 1:**
```
Input: text1 = "abcde", text2 = "ace"
Output: 3
Explanation: 최장 공통 부분 수열은 "ace"이며, 길이는 3입니다.
```

**예시 2:**
```
Input: text1 = "abc", text2 = "abc"
Output: 3
Explanation: 최장 공통 부분 수열은 "abc"이며, 길이는 3입니다.
```

**예시 3:**
```
Input: text1 = "abc", text2 = "def"
Output: 0
Explanation: 공통 부분 수열이 없으므로 결과는 0입니다.
```',
    '- `1 <= text1.length, text2.length <= 1000`
- `text1`과 `text2`는 소문자 영어 문자로만 구성됩니다.'
);

------------------------------------------------------------
-- #93 edit-distance
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'edit-distance'),
    'ko',
    '편집 거리',
    '두 문자열 `word1`과 `word2`가 주어졌을 때, `word1`을 `word2`로 변환하는 데 필요한 최소 연산 횟수를 반환하세요.

사용 가능한 연산은 다음 세 가지입니다:
- 문자 **삽입**
- 문자 **삭제**
- 문자 **교체**

각 연산은 한 번의 단계로 계산됩니다.

**예시 1:**
```
Input: word1 = "horse", word2 = "ros"
Output: 3
Explanation:
horse -> rorse (''h''를 ''r''로 교체)
rorse -> rose (''r'' 삭제)
rose -> ros (''e'' 삭제)
```

**예시 2:**
```
Input: word1 = "intention", word2 = "execution"
Output: 5
Explanation:
intention -> inention (''t'' 삭제)
inention -> enention (''i''를 ''e''로 교체)
enention -> exention (''n''을 ''x''로 교체)
exention -> exection (''n''을 ''c''로 교체)
exection -> execution (''u'' 삽입)
```',
    '- `0 <= word1.length, word2.length <= 500`
- `word1`과 `word2`는 소문자 영어 문자로 구성됩니다.'
);

------------------------------------------------------------
-- #94 jump-game-ii
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'jump-game-ii'),
    'ko',
    '점프 게임 II',
    '길이 `n`인 **0-인덱스** 정수 배열 `nums`가 주어집니다. 시작 위치는 인덱스 `0`입니다.

각 원소 `nums[i]`는 인덱스 `i`에서 앞으로 점프할 수 있는 최대 거리를 나타냅니다. 예를 들어, `nums[i] = 3`이면 인덱스 `i + 1`, `i + 2`, `i + 3`으로 점프할 수 있습니다.

마지막 인덱스 `nums[n - 1]`에 도달하기 위한 최소 점프 횟수를 반환하세요. 입력은 항상 끝까지 도달할 수 있는 경우만 주어집니다.

**예시 1:**
```
Input: nums = [2,3,1,1,4]
Output: 2
Explanation: 인덱스 0에서 인덱스 1로 1칸 점프한 뒤, 인덱스 1에서 마지막 인덱스로 3칸 점프합니다.
```

**예시 2:**
```
Input: nums = [2,3,0,1,4]
Output: 2
```',
    '- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 1000`
- `nums[n - 1]`에 도달할 수 있음이 보장됩니다.'
);

------------------------------------------------------------
-- #95 gas-station
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'gas-station'),
    'ko',
    '주유소',
    '원형 경로를 따라 `n`개의 주유소가 배치되어 있습니다. 주유소 `i`에서 보충할 수 있는 연료량은 `gas[i]`입니다.

연료 탱크 용량에 제한이 없는 자동차가 있고, 주유소 `i`에서 `i + 1`로 이동하는 데 `cost[i]`만큼의 연료가 소모됩니다. 빈 탱크 상태에서 아무 주유소에서 출발합니다.

두 정수 배열 `gas`와 `cost`가 주어졌을 때, 시계 방향으로 한 바퀴를 완주할 수 있는 출발 주유소의 인덱스를 반환하세요. 완주할 수 없으면 `-1`을 반환합니다.

정답이 존재하면 **유일함**이 보장됩니다.

**예시 1:**
```
Input: gas = [1,2,3,4,5], cost = [3,4,5,1,2]
Output: 3
```

**예시 2:**
```
Input: gas = [2,3,4], cost = [3,4,3]
Output: -1
```',
    '- `n == gas.length == cost.length`
- `1 <= n <= 10^5`
- `0 <= gas[i], cost[i] <= 10^4`'
);

------------------------------------------------------------
-- #96 insert-interval
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'insert-interval'),
    'ko',
    '구간 삽입',
    '겹치지 않는 구간 배열 `intervals`가 주어지며, 각 `intervals[i] = [start, end]`는 `start` 기준 오름차순으로 정렬되어 있습니다.

새 구간 `newInterval = [start, end]`가 주어졌을 때, 이를 `intervals`에 삽입하여 배열이 여전히 정렬되고 겹치지 않도록 만드세요. 필요하면 겹치는 구간들을 병합합니다.

삽입 후 업데이트된 구간 배열을 반환하세요.

**예시 1:**
```
Input: intervals = [[1,3],[6,9]], newInterval = [2,5]
Output: [[1,5],[6,9]]
```

**예시 2:**
```
Input: intervals = [[1,2],[3,5],[6,7],[8,10],[12,16]], newInterval = [4,8]
Output: [[1,2],[3,10],[12,16]]
```',
    '- `0 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start <= end <= 10^5`
- `intervals`는 `start` 기준 오름차순 정렬되어 있습니다.
- `newInterval.length == 2`
- `0 <= start <= end <= 10^5`'
);

------------------------------------------------------------
-- #97 non-overlapping
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'non-overlapping'),
    'ko',
    '겹치지 않는 구간',
    '구간 배열 `intervals`가 주어지며, 각 `intervals[i] = [start, end]`입니다. 나머지 구간들이 서로 겹치지 않도록 하기 위해 **제거해야 하는 구간의 최소 개수**를 반환하세요.

두 구간 `[a, b]`와 `[c, d]`는 `b <= c` 또는 `d <= a`이면 겹치지 않습니다.

**예시 1:**
```
Input: intervals = [[1,2],[2,3],[3,4],[1,3]]
Output: 1
Explanation: [1,3]을 제거하면 나머지 구간이 겹치지 않습니다.
```

**예시 2:**
```
Input: intervals = [[1,2],[1,2],[1,2]]
Output: 2
Explanation: 세 개의 [1,2] 중 두 개를 제거해야 겹침이 없어집니다.
```

**예시 3:**
```
Input: intervals = [[1,2],[2,3]]
Output: 0
Explanation: 이미 겹치지 않으므로 제거할 필요가 없습니다.
```',
    '- `1 <= intervals.length <= 10^5`
- `intervals[i].length == 2`
- `-5 * 10^4 <= start < end <= 5 * 10^4`'
);

------------------------------------------------------------
-- #98 meeting-rooms
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'meeting-rooms'),
    'ko',
    '회의실 배정',
    '회의 시간 구간 배열 `intervals`가 주어지며, 각 `intervals[i] = [start, end]`입니다. 모든 회의를 진행하기 위해 필요한 **최소 회의실 수**를 반환하세요.

회의 시간이 겹치면 각각 별도의 회의실이 필요합니다. 회의가 끝나면 해당 회의실은 즉시 사용 가능해집니다.

**예시 1:**
```
Input: intervals = [[0,30],[5,10],[15,20]]
Output: 2
Explanation: [0,30] 회의가 [5,10], [15,20]과 겹치지만, [5,10]과 [15,20]은 서로 겹치지 않습니다. 회의실 2개면 충분합니다.
```

**예시 2:**
```
Input: intervals = [[7,10],[2,4]]
Output: 1
Explanation: 두 회의가 겹치지 않으므로 회의실 1개면 됩니다.
```',
    '- `1 <= intervals.length <= 10^4`
- `0 <= start < end <= 10^6`'
);

------------------------------------------------------------
-- #99 spiral-matrix
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'spiral-matrix'),
    'ko',
    '나선형 행렬',
    '`m x n` 정수 행렬이 주어졌을 때, 모든 원소를 **나선형 순서**로 반환하세요.

나선형 순서란 왼쪽 상단에서 시작하여 첫 번째 행을 오른쪽으로, 마지막 열을 아래로, 마지막 행을 왼쪽으로, 첫 번째 열을 위로 순회한 뒤, 안쪽으로 같은 패턴을 반복하는 것입니다.

**예시 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [1,2,3,6,9,8,7,4,5]
```

**예시 2:**
```
Input: matrix = [[1,2,3,4],[5,6,7,8],[9,10,11,12]]
Output: [1,2,3,4,8,12,11,10,9,5,6,7]
```',
    '- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 10`
- `-100 <= matrix[i][j] <= 100`'
);

------------------------------------------------------------
-- #100 count-bits
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'count-bits'),
    'ko',
    '비트 세기',
    '양의 정수 `n`이 주어졌을 때, 이진 표현에서 **켜진 비트**(1)의 개수를 반환하세요. 이를 **해밍 가중치**라고도 합니다.

**예시 1:**
```
Input: n = 11
Output: 3
Explanation: 11의 이진 표현은 1011이며, 켜진 비트가 3개입니다.
```

**예시 2:**
```
Input: n = 128
Output: 1
Explanation: 128의 이진 표현은 10000000이며, 켜진 비트가 1개입니다.
```

**예시 3:**
```
Input: n = 2147483645
Output: 30
```',
    '- `1 <= n <= 2^31 - 1`'
);
