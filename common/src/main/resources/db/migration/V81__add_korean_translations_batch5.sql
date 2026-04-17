-- Korean translations: batch 5 (problems #41-50)

------------------------------------------------------------
-- #41 house-thief
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'house-thief'),
    'ko',
    '도둑의 선택',
    '거리를 따라 늘어선 집들을 털 계획을 세우고 있습니다. 각 집에는 일정 금액의 현금이 보관되어 있습니다. 단, 인접한 두 집을 같은 밤에 털면 보안 시스템이 연동되어 경찰에 신고됩니다.

정수 배열 `nums`가 주어지고, `nums[i]`는 `i`번째 집에 있는 금액을 나타냅니다. 경보를 울리지 않고 오늘 밤 훔칠 수 있는 최대 금액을 반환하세요.

**예시 1:**
```
Input: nums = [1,2,3,1]
Output: 4
Explanation: 1번 집(금액 = 1)과 3번 집(금액 = 3)을 턴다. 합계 = 1 + 3 = 4.
```

**예시 2:**
```
Input: nums = [2,7,9,3,1]
Output: 12
Explanation: 1번 집(금액 = 2), 3번 집(금액 = 9), 5번 집(금액 = 1)을 턴다. 합계 = 2 + 9 + 1 = 12.
```',
    '- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 400`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #42 coin-picker
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'coin-picker'),
    'ko',
    '동전 거스름',
    '정수 배열 `coins`(동전의 종류)와 정수 `amount`(목표 금액)가 주어집니다.

해당 금액을 만들기 위해 필요한 최소 동전 개수를 반환하세요. 어떤 조합으로도 금액을 만들 수 없으면 `-1`을 반환하세요.

각 동전은 무제한으로 사용할 수 있습니다.

**예시 1:**
```
Input: coins = [1,5,10], amount = 12
Output: 3
Explanation: 12 = 10 + 1 + 1
```

**예시 2:**
```
Input: coins = [2], amount = 3
Output: -1
Explanation: 2원짜리 동전만으로는 3을 만들 수 없습니다.
```

**예시 3:**
```
Input: coins = [1], amount = 0
Output: 0
Explanation: 금액이 0이면 동전이 필요 없습니다.
```',
    '- `1 <= coins.length <= 12`
- `1 <= coins[i] <= 2^31 - 1`
- `0 <= amount <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #43 longest-ascending
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-ascending'),
    'ko',
    '최장 증가 부분수열',
    '정수 배열 `nums`가 주어졌을 때, 가장 긴 순증가 **부분수열**의 길이를 반환하세요.

**부분수열**이란 배열에서 원소를 0개 이상 삭제하되, 나머지 원소의 순서는 그대로 유지하여 만든 수열입니다. 예를 들어 `[3,6,7]`은 `[0,3,1,6,2,7]`의 부분수열입니다.

**예시 1:**
```
Input: nums = [10,9,2,5,3,7,101,18]
Output: 4
Explanation: 가장 긴 증가 부분수열은 [2,3,7,101]이므로 길이는 4입니다.
```

**예시 2:**
```
Input: nums = [0,1,0,3,2,3]
Output: 4
```

**예시 3:**
```
Input: nums = [7,7,7,7,7,7,7]
Output: 1
Explanation: 모든 원소가 동일하므로 순증가 부분수열의 길이는 1입니다.
```',
    '- `1 <= nums.length <= 2500`
- `-10^4 <= nums[i] <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #44 word-segmentation
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'word-segmentation'),
    'ko',
    '단어 분리',
    '문자열 `s`와 문자열 리스트 `wordDict`(사전)가 주어졌을 때, `s`를 사전에 있는 단어들로 공백 구분하여 나눌 수 있으면 `true`를, 아니면 `false`를 반환하세요.

같은 사전 단어를 여러 번 사용해도 됩니다.

**예시 1:**
```
Input: s = "codebite", wordDict = ["code","bite"]
Output: true
Explanation: "codebite"를 "code bite"로 분리할 수 있습니다.
```

**예시 2:**
```
Input: s = "applepenapple", wordDict = ["apple","pen"]
Output: true
Explanation: "applepenapple"을 "apple pen apple"로 분리할 수 있습니다. "apple"을 재사용합니다.
```

**예시 3:**
```
Input: s = "catsandog", wordDict = ["cats","dog","sand","and","cat"]
Output: false
Explanation: 주어진 사전으로는 "catsandog"을 분리할 수 없습니다.
```',
    '- `1 <= s.length <= 300`
- `1 <= wordDict.length <= 1000`
- `1 <= wordDict[i].length <= 20`
- `s`와 `wordDict[i]`는 소문자 영어 알파벳으로만 구성됩니다.
- `wordDict`의 모든 문자열은 고유합니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #45 largest-subarray
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'largest-subarray'),
    'ko',
    '최대 부분배열 합',
    '정수 배열 `nums`가 주어졌을 때, 합이 가장 큰 연속 부분배열을 찾아 그 합을 반환하세요.

**부분배열**이란 배열 내의 비어 있지 않은 연속된 원소들의 시퀀스입니다.

**예시 1:**
```
Input: nums = [-2,1,-3,4,-1,2,1,-5,4]
Output: 6
Explanation: 부분배열 [4,-1,2,1]의 합이 6으로 가장 큽니다.
```

**예시 2:**
```
Input: nums = [1]
Output: 1
Explanation: 부분배열 [1]의 합이 1입니다.
```

**예시 3:**
```
Input: nums = [5,4,-1,7,8]
Output: 23
Explanation: 부분배열 [5,4,-1,7,8]의 합이 23입니다.
```',
    '- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #46 reach-the-end
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'reach-the-end'),
    'ko',
    '끝까지 도달',
    '정수 배열 `nums`가 주어집니다. 첫 번째 인덱스에서 시작하며, 각 원소 `nums[i]`는 인덱스 `i`에서 앞으로 점프할 수 있는 최대 칸 수를 나타냅니다.

마지막 인덱스에 도달할 수 있으면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: nums = [2,3,1,1,4]
Output: true
Explanation: 인덱스 0에서 1칸 점프하여 인덱스 1로, 이후 3칸 점프하여 마지막 인덱스에 도달합니다.
```

**예시 2:**
```
Input: nums = [3,2,1,0,4]
Output: false
Explanation: 어떻게 해도 인덱스 3에 도달하게 되며, 최대 점프 거리가 0이므로 마지막 인덱스에 도달할 수 없습니다.
```',
    '- `1 <= nums.length <= 10^4`
- `0 <= nums[i] <= 10^5`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #47 overlap-merge
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'overlap-merge'),
    'ko',
    '겹치는 구간 병합',
    '`intervals[i] = [start_i, end_i]` 형태의 구간 배열 `intervals`가 주어졌을 때, 겹치는 모든 구간을 병합하고, 입력의 모든 구간을 포함하는 겹치지 않는 구간 배열을 반환하세요.

두 구간은 공통 지점이 하나라도 있으면 겹치는 것으로 봅니다. 예를 들어 `[1,3]`과 `[2,6]`은 겹치지만, `[1,2]`와 `[3,4]`는 겹치지 않습니다.

**예시 1:**
```
Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
Output: [[1,6],[8,10],[15,18]]
Explanation: 구간 [1,3]과 [2,6]이 겹치므로 [1,6]으로 병합합니다.
```

**예시 2:**
```
Input: intervals = [[1,4],[4,5]]
Output: [[1,5]]
Explanation: 구간 [1,4]와 [4,5]는 겹치는 것으로 간주합니다.
```',
    '- `1 <= intervals.length <= 10^4`
- `intervals[i].length == 2`
- `0 <= start_i <= end_i <= 10^4`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #48 rotate-grid
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rotate-grid'),
    'ko',
    '행렬 회전',
    '이미지를 나타내는 `n x n` 2D `matrix`가 주어집니다. 이미지를 시계 방향으로 90도 회전하세요.

**제자리(in-place)**에서 회전해야 합니다. 즉, 입력 행렬을 직접 수정해야 하며, 별도의 2D 행렬을 할당하면 안 됩니다.

**예시 1:**
```
Input: matrix = [[1,2,3],[4,5,6],[7,8,9]]
Output: [[7,4,1],[8,5,2],[9,6,3]]
```

**예시 2:**
```
Input: matrix = [[5,1,9,11],[2,4,8,10],[13,3,6,7],[15,14,12,16]]
Output: [[15,13,2,5],[14,3,4,1],[12,6,8,9],[16,7,10,11]]
```',
    '- `n == matrix.length == matrix[i].length`
- `1 <= n <= 20`
- `-1000 <= matrix[i][j] <= 1000`'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #49 lone-element
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'lone-element'),
    'ko',
    '혼자인 원소',
    '비어 있지 않은 정수 배열 `nums`가 주어지며, 하나의 원소를 제외한 모든 원소가 정확히 두 번씩 나타납니다. 한 번만 나타나는 그 원소를 찾아 반환하세요.

시간 복잡도 O(n), 추가 공간 O(1)로 풀어야 합니다.

**예시 1:**
```
Input: nums = [2,2,1]
Output: 1
```

**예시 2:**
```
Input: nums = [4,1,2,1,2]
Output: 4
Explanation: 1과 2는 각각 두 번 나타나고, 4만 한 번 나타납니다.
```

**예시 3:**
```
Input: nums = [1]
Output: 1
```',
    '- `1 <= nums.length <= 3 * 10^4`
- `-3 * 10^4 <= nums[i] <= 3 * 10^4`
- 하나의 원소를 제외한 모든 원소가 정확히 두 번 나타납니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;

------------------------------------------------------------
-- #50 kth-largest-stream
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'kth-largest-stream'),
    'ko',
    'K번째 큰 수 스트림',
    '정수 스트림에서 `k`번째로 큰 원소를 찾는 클래스를 설계하세요. 여기서 `k`번째로 큰 원소란 정렬했을 때 `k`번째로 큰 값을 의미하며, `k`번째로 큰 고유한 값이 아닙니다.

`KthLargest` 클래스를 구현하세요:

- `KthLargest(int k, int[] nums)` -- 정수 `k`와 초기 정수 스트림 `nums`로 객체를 초기화합니다.
- `int add(int val)` -- 정수 `val`을 스트림에 추가하고, 현재까지의 스트림에서 `k`번째로 큰 원소를 반환합니다.

**예시 1:**
```
Input:
["KthLargest", "add", "add", "add", "add", "add"]
[[3, [4, 5, 8, 2]], [3], [5], [10], [9], [4]]
Output: [null, 4, 5, 5, 8, 8]

Explanation:
KthLargest kthLargest = new KthLargest(3, [4, 5, 8, 2]);
kthLargest.add(3);   // return 4
kthLargest.add(5);   // return 5
kthLargest.add(10);  // return 5
kthLargest.add(9);   // return 8
kthLargest.add(4);   // return 8
```',
    '- `1 <= k <= 10^4`
- `0 <= nums.length <= 10^4`
- `-10^4 <= nums[i] <= 10^4`
- `-10^4 <= val <= 10^4`
- `add`는 최대 `10^4`번 호출됩니다.
- `k`번째 원소를 조회할 때 배열에 최소 `k`개의 원소가 있음이 보장됩니다.'
)
ON CONFLICT (problem_id, locale) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    constraints = EXCLUDED.constraints,
    updated_at = CURRENT_TIMESTAMP;
