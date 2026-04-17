-- Korean translations: batch 14 (problems #131-140)

------------------------------------------------------------
-- #131 feed-designer
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'feed-designer'),
    'ko',
    '피드 설계',
    '메시지 게시, 팔로우/언팔로우, 맞춤 뉴스피드 조회를 지원하는 간단한 소셜 피드 시스템을 설계하세요.

`FeedDesigner` 클래스를 다음 메서드와 함께 구현하세요:

- `FeedDesigner()` 피드 시스템을 초기화합니다.
- `postMessage(userId, messageId)` 사용자 `userId`가 고유한 `messageId`로 새 메시지를 게시합니다.
- `getNewsFeed(userId)` 해당 사용자의 뉴스피드에서 **가장 최근 메시지 10개**의 ID를 반환합니다. 피드에는 본인이 작성한 메시지와 팔로우 중인 사용자의 메시지가 포함되며, 최신순으로 정렬됩니다.
- `follow(followerId, followeeId)` 사용자 `followerId`가 `followeeId`를 팔로우합니다. `followerId == followeeId`이면 아무 동작도 하지 않습니다.
- `unfollow(followerId, followeeId)` 사용자 `followerId`가 `followeeId`를 언팔로우합니다. `followerId == followeeId`이면 아무 동작도 하지 않습니다.

**예시 1:**
```
Input: ["FeedDesigner","postMessage","postMessage","getNewsFeed"]
       [[],[1,10],[1,20],[1]]
Output: [null,null,null,[20,10]]
Explanation: 사용자 1이 메시지 두 개를 게시합니다. 피드에서 최신 메시지가 먼저 표시됩니다.
```

**예시 2:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1]]
Output: [null,null,null,null,[20,10]]
Explanation: 사용자 1이 사용자 2를 팔로우합니다. 이제 사용자 1의 피드에 사용자 2의 메시지도 포함됩니다.
```

**예시 3:**
```
Input: ["FeedDesigner","postMessage","postMessage","follow","getNewsFeed","unfollow","getNewsFeed"]
       [[],[1,10],[2,20],[1,2],[1],[1,2],[1]]
Output: [null,null,null,null,[20,10],null,[10]]
Explanation: 사용자 2를 언팔로우한 후, 사용자 1의 피드에 사용자 2의 메시지가 더 이상 표시되지 않습니다.
```',
    '- `1 <= userId, followerId, followeeId <= 500`
- `0 <= messageId <= 10^4`
- 전체 메서드 호출 횟수는 최대 `3 * 10^4`회'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #132 running-median
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'running-median'),
    'ko',
    '실시간 중앙값',
    '정수를 하나씩 추가하면서 현재까지 추가된 모든 원소의 **중앙값**을 효율적으로 구할 수 있는 자료구조를 설계하세요.

`MedianTracker` 클래스를 구현하세요:

- `MedianTracker()` 자료구조를 초기화합니다.
- `addNum(num)` 정수 `num`을 컬렉션에 추가합니다.
- `findMedian()` 현재까지 추가된 모든 원소의 중앙값을 반환합니다. 원소 개수가 짝수이면 가운데 두 값의 평균을 실수로 반환합니다.

**예시 1:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian"]
       [[],[1],[],[2],[],[3],[]]
Output: [null,null,1.0,null,1.5,null,2.0]
Explanation: 1을 추가하면 중앙값은 1.0. 2를 추가하면 [1, 2]의 중앙값은 1.5. 3을 추가하면 [1, 2, 3]의 중앙값은 2.0.
```

**예시 2:**
```
Input: ["MedianTracker","addNum","addNum","addNum","addNum","findMedian"]
       [[],[4],[2],[5],[3],[]]
Output: [null,null,null,null,null,3.5]
Explanation: 정렬된 컬렉션은 [2, 3, 4, 5]. 원소가 4개이므로 중앙값은 (3 + 4) / 2 = 3.5.
```

**예시 3:**
```
Input: ["MedianTracker","addNum","findMedian","addNum","findMedian"]
       [[],[7],[],[3],[]]
Output: [null,null,7.0,null,5.0]
Explanation: 7을 추가하면 중앙값은 7.0. 3을 추가하면 [3, 7]의 중앙값은 (3 + 7) / 2 = 5.0.
```',
    '- `-10^5 <= num <= 10^5`
- addNum과 findMedian 호출 횟수는 최대 `5 * 10^4`회
- findMedian은 항상 addNum이 최소 한 번 호출된 후에 호출됨'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #133 rearrange-letters
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rearrange-letters'),
    'ko',
    '문자 재배치',
    '문자열 `s`가 주어졌을 때, **인접한** 두 문자가 같지 않도록 문자를 재배치하세요.

유효한 재배치 결과를 아무거나 하나 반환하세요. 유효한 배치가 불가능하면 빈 문자열 `""`을 반환하세요.

**예시 1:**
```
Input: s = "aab"
Output: "aba"
```

**예시 2:**
```
Input: s = "aaab"
Output: ""
Explanation: 어떻게 배치해도 ''a''가 두 개 연속으로 나올 수밖에 없습니다.
```

**예시 3:**
```
Input: s = "aabb"
Output: "abab"
```',
    '- `1 <= s.length <= 500`
- s는 소문자 영어 알파벳으로만 구성됨'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #134 frequent-words
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'frequent-words'),
    'ko',
    '빈출 단어',
    '문자열 배열 `words`와 정수 `k`가 주어졌을 때, 가장 자주 등장하는 단어 `k`개를 반환하세요.

결과는 빈도 기준 **내림차순**으로 정렬하세요. 빈도가 같은 단어가 있으면 **사전순**으로 정렬하세요.

**예시 1:**
```
Input: words = ["apple","banana","apple","cherry","banana","apple"], k = 2
Output: ["apple","banana"]
Explanation: "apple"은 3번, "banana"는 2번 등장합니다. 가장 빈번한 2개 단어입니다.
```

**예시 2:**
```
Input: words = ["yes","yes","no","no","maybe"], k = 3
Output: ["no","yes","maybe"]
Explanation: "yes"와 "no"는 모두 2번 등장하므로 사전순으로 정렬됩니다. "maybe"는 1번 등장합니다.
```

**예시 3:**
```
Input: words = ["hello","world","hello"], k = 1
Output: ["hello"]
```',
    '- `1 <= words.length <= 500`
- `1 <= words[i].length <= 10`
- `words[i]`는 소문자 영어 알파벳으로 구성됨
- `k`는 `[1, 고유 단어 수]` 범위
- 답은 유일함이 보장됨'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #135 unique-subsets
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-subsets'),
    'ko',
    '고유 부분집합',
    '**중복** 값이 포함될 수 있는 정수 배열 `nums`가 주어졌을 때, 가능한 모든 부분집합(멱집합)을 반환하세요.

결과에 중복된 부분집합이 포함되어서는 안 됩니다. 부분집합의 순서는 상관없습니다.

**예시 1:**
```
Input: nums = [1,2,2]
Output: [[],[1],[1,2],[1,2,2],[2],[2,2]]
```

**예시 2:**
```
Input: nums = [0]
Output: [[],[0]]
```

**예시 3:**
```
Input: nums = [4,4,4,1,4]
Output: [[],[1],[1,4],[1,4,4],[1,4,4,4],[1,4,4,4,4],[4],[4,4],[4,4,4],[4,4,4,4]]
Explanation: 입력에 중복이 있지만, 각 부분집합은 한 번만 나타납니다.
```',
    '- `1 <= nums.length <= 10`
- `-10 <= nums[i] <= 10`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #136 unique-combinations
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-combinations'),
    'ko',
    '고유 조합',
    '중복이 포함될 수 있는 정수 배열 `candidates`와 목표 값 `target`이 주어졌을 때, 합이 `target`이 되는 모든 고유한 조합을 구하세요.

`candidates`의 각 숫자는 조합당 **한 번만** 사용할 수 있으며, 결과에 중복 조합이 포함되어서는 안 됩니다.

**예시 1:**
```
Input: candidates = [10,1,2,7,6,1,5], target = 8
Output: [[1,1,6],[1,2,5],[1,7],[2,6]]
```

**예시 2:**
```
Input: candidates = [2,5,2,1,2], target = 5
Output: [[1,2,2],[5]]
```

**예시 3:**
```
Input: candidates = [1,1,1,1], target = 2
Output: [[1,1]]
Explanation: 1이 네 번 나타나지만, 합이 2가 되려면 1 두 개를 고르는 수밖에 없습니다. 중복 조합은 제외됩니다.
```',
    '- `1 <= candidates.length <= 100`
- `1 <= candidates[i] <= 50`
- `1 <= target <= 30`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #137 palindrome-split
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'palindrome-split'),
    'ko',
    '회문 분할',
    '문자열 `s`가 주어졌을 때, **모든** 부분 문자열이 회문이 되도록 분할하세요. 가능한 모든 회문 분할을 반환하세요.

분할은 문자의 순서를 바꾸지 않고 왼쪽부터 오른쪽까지 전체 문자열을 빠짐없이 나눠야 합니다. 분할 결과의 순서는 상관없습니다.

**예시 1:**
```
Input: s = "aab"
Output: [["a","a","b"],["aa","b"]]
```

**예시 2:**
```
Input: s = "a"
Output: [["a"]]
```

**예시 3:**
```
Input: s = "aba"
Output: [["a","b","a"],["aba"]]
Explanation: 각 글자를 하나씩 나눈 "a", "b", "a"와 전체 문자열 "aba" 모두 유효한 회문 분할입니다.
```',
    '- `1 <= s.length <= 16`
- s는 소문자 영어 알파벳으로만 구성됨'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #138 ip-builder
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'ip-builder'),
    'ko',
    'IP 주소 생성',
    '숫자로만 이루어진 문자열 `s`가 주어졌을 때, 정확히 세 개의 점을 삽입하여 만들 수 있는 모든 유효한 **IPv4 주소**를 반환하세요.

유효한 IPv4 주소는 점으로 구분된 정확히 네 개의 정수(**옥텟**)로 구성되며, 각 옥텟은 `0`에서 `255` 사이여야 합니다. 옥텟 자체가 `"0"`인 경우를 제외하고 선행 0은 허용되지 않습니다.

결과는 사전순으로 정렬하여 반환하세요.

**예시 1:**
```
Input: s = "25525511135"
Output: ["255.255.11.135","255.255.111.35"]
```

**예시 2:**
```
Input: s = "0000"
Output: ["0.0.0.0"]
```

**예시 3:**
```
Input: s = "101023"
Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","10.102.0.3","101.0.2.3","101.0.23.0"]
```',
    '- `1 <= s.length <= 20`
- s는 숫자로만 구성됨'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #139 valid-tree
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'valid-tree'),
    'ko',
    '유효한 트리',
    '`0`부터 `n - 1`까지 번호가 매겨진 `n`개의 노드와 무방향 간선 목록 `edges`가 주어졌을 때, 이 노드와 간선이 **유효한 트리**를 구성하는지 판별하세요.

유효한 트리의 조건은 다음과 같습니다:
- **완전 연결** -- 모든 노드가 서로 도달 가능해야 합니다.
- **사이클이 없어야** 합니다.

**예시 1:**
```
Input: n = 5, edges = [[0,1],[0,2],[0,3],[1,4]]
Output: true
Explanation: 5개 노드가 모두 연결되어 있고 사이클이 없습니다.
```

**예시 2:**
```
Input: n = 5, edges = [[0,1],[1,2],[2,3],[1,3],[1,4]]
Output: false
Explanation: 노드 1, 2, 3 사이에 사이클이 존재합니다.
```

**예시 3:**
```
Input: n = 4, edges = [[0,1],[2,3]]
Output: false
Explanation: 그래프가 두 개의 분리된 컴포넌트로 나뉘어 있어 유효한 트리가 아닙니다.
```',
    '- `1 <= n <= 2000`
- `0 <= edges.length <= 5000`
- `edges[i].length == 2`
- `0 <= edges[i][0], edges[i][1] < n`
- 자기 루프나 중복 간선은 없음'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #140 gate-distance
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'gate-distance'),
    'ko',
    '게이트 거리',
    '`m x n` 격자가 주어지며, 각 칸에는 다음 세 가지 값 중 하나가 들어 있습니다:

- `-1` -- **장애물** (통과 불가)
- `0` -- **게이트**
- `2147483647` -- **빈 공간**

각 빈 공간에 **가장 가까운 게이트**까지의 거리(이동 횟수)를 채워 넣으세요. 어떤 게이트에도 도달할 수 없는 빈 공간은 `2147483647`을 그대로 유지합니다. 이동은 상하좌우 네 방향만 가능합니다.

격자를 **제자리에서(in-place)** 수정하여 반환하세요.

**예시 1:**
```
Input: grid = [[2147483647,-1,0,2147483647],[2147483647,2147483647,2147483647,-1],[2147483647,-1,2147483647,-1],[0,-1,2147483647,2147483647]]
Output: [[3,-1,0,1],[2,2,1,-1],[1,-1,2,-1],[0,-1,3,4]]
Explanation: 게이트는 (0,2)와 (3,0)에 있습니다. 각 빈 공간에 가장 가까운 게이트까지의 최단 거리가 채워집니다.
```

**예시 2:**
```
Input: grid = [[0,-1],[2147483647,2147483647]]
Output: [[0,-1],[1,2]]
```

**예시 3:**
```
Input: grid = [[2147483647]]
Output: [[2147483647]]
Explanation: 게이트가 없으므로 빈 공간은 도달 불가 상태로 유지됩니다.
```',
    '- `1 <= m, n <= 250`
- `grid[i][j]`는 `-1`, `0`, 또는 `2147483647`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
