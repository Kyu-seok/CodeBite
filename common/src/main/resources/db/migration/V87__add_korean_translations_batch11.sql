-- Korean translations: batch 11 (problems #101-110)

------------------------------------------------------------
-- #101 popular-vote (Popular Vote)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'popular-vote'),
    'ko',
    '과반수 원소',
    '크기가 `n`인 배열 `nums`가 주어졌을 때, **과반수 원소**를 반환하세요. 과반수 원소란 배열에서 `n / 2`번보다 많이 등장하는 원소입니다.

배열에는 항상 과반수 원소가 존재한다고 가정해도 됩니다.

**예시 1:**
```
Input: nums = [3,2,3]
Output: 3
```

**예시 2:**
```
Input: nums = [2,2,1,1,1,2,2]
Output: 2
Explanation: 2가 7개 중 4번 등장합니다.
```

**예시 3:**
```
Input: nums = [1]
Output: 1
```',
    '- `1 <= nums.length <= 50000`
- `-10^9 <= nums[i] <= 10^9`'
);

------------------------------------------------------------
-- #102 remove-sorted-dupes (Remove Sorted Dupes)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'remove-sorted-dupes'),
    'ko',
    '정렬된 배열 중복 제거',
    '비내림차순으로 정렬된 정수 배열 `nums`가 주어졌을 때, 중복을 **제자리에서(in-place)** 제거하여 각 원소가 한 번만 나타나도록 하세요. 원소의 상대적 순서는 유지해야 합니다.

`nums`의 앞부분을 고유한 값들로 덮어쓰고, 고유 원소의 개수 `k`를 반환하세요. `nums`의 처음 `k`개 위치에는 원래 순서대로 고유 값이 들어 있어야 합니다. 인덱스 `k - 1` 이후의 값은 신경 쓰지 않아도 됩니다.

**예시 1:**
```
Input: nums = [1,1,2]
Output: 2, nums = [1,2,_]
Explanation: k = 2를 반환합니다. nums의 처음 두 원소는 1과 2입니다.
```

**예시 2:**
```
Input: nums = [0,0,1,1,1,2,2,3,3,4]
Output: 5, nums = [0,1,2,3,4,_,_,_,_,_]
Explanation: k = 5를 반환합니다. 처음 다섯 자리에 0부터 4까지 들어갑니다.
```

**예시 3:**
```
Input: nums = [7]
Output: 1, nums = [7]
Explanation: 원소가 하나뿐이므로 중복이 없습니다.
```',
    '- `1 <= nums.length <= 3 * 10^4`
- `-100 <= nums[i] <= 100`
- `nums`는 비내림차순으로 정렬되어 있습니다.'
);

------------------------------------------------------------
-- #103 duplicate-finder (Duplicate Finder)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'duplicate-finder'),
    'ko',
    '중복 원소 찾기',
    '길이 `n`인 정수 배열 `nums`가 주어지고, 모든 값은 `1 <= nums[i] <= n`을 만족합니다. **정확히 두 번** 등장하는 모든 원소를 찾으세요. 나머지 원소는 모두 정확히 한 번만 등장합니다.

중복되는 값의 목록을 반환하세요. 결과 순서는 상관없습니다.

O(n) 시간에, 결과 리스트 외에 O(1) 추가 공간만 사용하여 풀어보세요.

**예시 1:**
```
Input: nums = [4,3,2,7,8,2,3,1]
Output: [2,3]
```

**예시 2:**
```
Input: nums = [1,1,2]
Output: [1]
```

**예시 3:**
```
Input: nums = [1,2,3,4,5]
Output: []
Explanation: 두 번 이상 등장하는 원소가 없습니다.
```',
    '- `n == nums.length`
- `1 <= n <= 10^5`
- `1 <= nums[i] <= n`
- 각 원소는 한 번 또는 두 번 등장합니다.'
);

------------------------------------------------------------
-- #104 target-subarray (Target Subarray)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'target-subarray'),
    'ko',
    '목표 부분 배열',
    '정수 배열 `nums`와 정수 `k`가 주어졌을 때, 원소의 합이 정확히 `k`인 연속 부분 배열의 개수를 반환하세요.

**부분 배열**이란 배열 내에서 연속된 원소들의 나열입니다. 배열에 음수가 포함될 수 있으므로 슬라이딩 윈도우 방식은 직접 적용할 수 없습니다.

**예시 1:**
```
Input: nums = [1,1,1], k = 2
Output: 2
Explanation: 인덱스 0에서 시작하는 [1,1]과 인덱스 1에서 시작하는 [1,1] 두 부분 배열의 합이 2입니다.
```

**예시 2:**
```
Input: nums = [1,2,3], k = 3
Output: 2
Explanation: [1,2]와 [3] 모두 합이 3입니다.
```

**예시 3:**
```
Input: nums = [1,-1,0], k = 0
Output: 3
Explanation: [1,-1], [-1,0], [1,-1,0] 모두 합이 0입니다.
```',
    '- `1 <= nums.length <= 20000`
- `-1000 <= nums[i] <= 1000`
- `-10^7 <= k <= 10^7`'
);

------------------------------------------------------------
-- #105 k-distinct-window (K Distinct Window)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'k-distinct-window'),
    'ko',
    'K개 이하 문자 윈도우',
    '문자열 `s`와 정수 `k`가 주어졌을 때, 서로 다른 문자가 최대 `k`개인 **가장 긴 부분 문자열**의 길이를 반환하세요.

**부분 문자열**이란 문자열 내에서 연속된 문자들의 나열입니다.

**예시 1:**
```
Input: s = "aabacbebebe", k = 3
Output: 7
Explanation: 서로 다른 문자가 3개 이하인 가장 긴 부분 문자열은 "cbebebe"입니다.
```

**예시 2:**
```
Input: s = "aaaa", k = 2
Output: 4
Explanation: 전체 문자열에 고유 문자가 1개뿐이므로 조건을 만족합니다.
```

**예시 3:**
```
Input: s = "abcdef", k = 1
Output: 1
Explanation: 모든 문자가 서로 다르므로, 문자 1개짜리 부분 문자열이 가장 깁니다.
```',
    '- `1 <= s.length <= 50000`
- `0 <= k <= 50`
- `s`는 소문자 영어 알파벳으로 구성됩니다.'
);

------------------------------------------------------------
-- #106 quad-sum (Quad Sum)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'quad-sum'),
    'ko',
    '네 수의 합',
    '정수 배열 `nums`와 정수 `target`이 주어졌을 때, 다음 조건을 만족하는 **고유한 네 쌍** `[nums[a], nums[b], nums[c], nums[d]]`을 모두 반환하세요:

- `a`, `b`, `c`, `d`는 서로 다른 인덱스
- `nums[a] + nums[b] + nums[c] + nums[d] == target`

결과에 중복되는 네 쌍이 없어야 합니다. 순서는 상관없습니다.

**예시 1:**
```
Input: nums = [1,0,-1,0,-2,2], target = 0
Output: [[-2,-1,1,2],[-2,0,0,2],[-1,0,0,1]]
Explanation: 합이 0인 서로 다른 네 쌍이 3개 있습니다.
```

**예시 2:**
```
Input: nums = [2,2,2,2,2], target = 8
Output: [[2,2,2,2]]
Explanation: 합이 8인 고유한 네 쌍은 하나뿐입니다.
```

**예시 3:**
```
Input: nums = [1,2,3,4], target = 100
Output: []
Explanation: 합이 100인 네 쌍이 존재하지 않습니다.
```',
    '- `1 <= nums.length <= 200`
- `-10^9 <= nums[i] <= 10^9`
- `-10^9 <= target <= 10^9`'
);

------------------------------------------------------------
-- #107 boat-loading (Boat Loading)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'boat-loading'),
    'ko',
    '보트 탑승',
    '배열 `weights`에서 `weights[i]`는 `i`번째 사람의 몸무게이고, 정수 `capacity`는 보트 한 척의 최대 적재량입니다. 모든 사람을 실어 나르는 데 필요한 **최소 보트 수**를 반환하세요.

각 보트에는 **최대 2명**까지 탈 수 있으며, 두 사람의 몸무게 합이 `capacity`를 넘지 않아야 합니다. 모든 사람은 정확히 한 척의 보트에 배정되어야 합니다.

**예시 1:**
```
Input: weights = [1,2], capacity = 3
Output: 1
Explanation: 두 사람을 한 보트에 태울 수 있습니다 (1 + 2 = 3).
```

**예시 2:**
```
Input: weights = [3,2,2,1], capacity = 3
Output: 3
Explanation: 몸무게 1인 사람과 2인 사람을 한 보트에 태웁니다. 나머지 두 사람(몸무게 3, 2)은 각각 보트가 필요합니다.
```

**예시 3:**
```
Input: weights = [3,5,3,4], capacity = 5
Output: 4
Explanation: 어떤 두 사람을 합쳐도 적재량을 초과하므로 각자 보트를 타야 합니다.
```',
    '- `1 <= weights.length <= 50000`
- `1 <= weights[i] <= capacity <= 30000`'
);

------------------------------------------------------------
-- #108 sorted-squares (Sorted Squares)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sorted-squares'),
    'ko',
    '정렬된 제곱수',
    '비내림차순으로 정렬된 정수 배열 `nums`가 주어졌을 때, 각 원소의 **제곱값**으로 이루어진 배열을 비내림차순으로 반환하세요.

음수는 제곱하면 양수가 되어 정렬 순서가 바뀔 수 있습니다. 내장 정렬 함수 없이 O(n) 시간에 풀어보세요.

**예시 1:**
```
Input: nums = [-4,-1,0,3,10]
Output: [0,1,9,16,100]
```

**예시 2:**
```
Input: nums = [-7,-3,2,3,11]
Output: [4,9,9,49,121]
```

**예시 3:**
```
Input: nums = [1,2,3,4]
Output: [1,4,9,16]
Explanation: 모든 원소가 양수이면 제곱해도 이미 정렬되어 있습니다.
```',
    '- `1 <= nums.length <= 10000`
- `-10000 <= nums[i] <= 10000`
- `nums`는 비내림차순으로 정렬되어 있습니다.'
);

------------------------------------------------------------
-- #109 shortest-cover (Shortest Cover)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'shortest-cover'),
    'ko',
    '최소 길이 부분 배열',
    '양의 정수로 이루어진 배열 `nums`와 양의 정수 `target`이 주어졌을 때, 합이 `target` 이상인 **가장 짧은 연속 부분 배열**의 길이를 반환하세요. 그런 부분 배열이 없으면 `0`을 반환하세요.

**부분 배열**이란 배열 내에서 연속된 원소들의 나열입니다.

**예시 1:**
```
Input: nums = [2,3,1,2,4,3], target = 7
Output: 2
Explanation: 합이 7 이상인 부분 배열 중 [4,3]이 가장 짧습니다.
```

**예시 2:**
```
Input: nums = [1,4,4], target = 4
Output: 1
Explanation: 원소 하나 [4]만으로 이미 목표를 충족합니다.
```

**예시 3:**
```
Input: nums = [1,1,1,1,1,1], target = 20
Output: 0
Explanation: 전체 합이 6으로 20보다 작습니다.
```',
    '- `1 <= nums.length <= 100000`
- `1 <= nums[i] <= 10000`
- `1 <= target <= 10^9`'
);

------------------------------------------------------------
-- #110 fruit-picker (Fruit Picker)
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fruit-picker'),
    'ko',
    '과일 담기',
    '정수 배열 `items`가 주어지고, 각 원소는 카테고리를 나타냅니다. **서로 다른 카테고리가 최대 2개**인 **가장 긴 연속 구간**을 찾으세요.

해당 구간의 길이를 반환하세요.

**예시 1:**
```
Input: items = [1,2,1,2,3]
Output: 4
Explanation: [1,2,1,2] 구간의 길이가 4이고, 카테고리 1과 2만 포함합니다.
```

**예시 2:**
```
Input: items = [5,5,5,5]
Output: 4
Explanation: 전체 배열에 카테고리가 하나뿐이므로 답은 4입니다.
```

**예시 3:**
```
Input: items = [1,2,3,4,5]
Output: 2
Explanation: 인접한 두 원소로 이루어진 길이 2 구간이 조건을 만족합니다.
```',
    '- `1 <= items.length <= 10^5`
- `0 <= items[i] < items.length`'
);
