-- Korean translations: batch 6 (problems #51-60)

------------------------------------------------------------
-- #51 color-sort
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'color-sort'),
    'ko',
    '색상 정렬',
    '`0`, `1`, `2` 값만 들어 있는 배열 `nums`가 주어졌을 때, 모든 `0`이 앞에, 그 다음 `1`, 마지막에 `2`가 오도록 **제자리(in-place)**에서 정렬하세요.

내장 정렬 함수를 사용하지 않고 풀어야 합니다.

**예시 1:**
```
Input: nums = [2,0,2,1,1,0]
Output: [0,0,1,1,2,2]
Explanation: 세 종류의 값이 오름차순으로 그룹화됩니다.
```

**예시 2:**
```
Input: nums = [2,0,1]
Output: [0,1,2]
```

**예시 3:**
```
Input: nums = [0]
Output: [0]
```',
    '- `1 <= nums.length <= 300`
- `nums[i]`는 `0`, `1`, 또는 `2`입니다.'
);

------------------------------------------------------------
-- #52 next-arrangement
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'next-arrangement'),
    'ko',
    '다음 순열',
    '정수 배열 `nums`가 주어졌을 때, **사전순으로 바로 다음인 순열**로 재배열하세요.

다음 순열이 없는 경우(내림차순으로 정렬된 경우) 가장 작은 순서(오름차순)로 재배열합니다.

**제자리(in-place)**에서 상수 추가 메모리만 사용하여 풀어야 합니다.

**예시 1:**
```
Input: nums = [1,2,3]
Output: [1,3,2]
Explanation: [1,2,3]의 다음 순열은 [1,3,2]입니다.
```

**예시 2:**
```
Input: nums = [3,2,1]
Output: [1,2,3]
Explanation: 다음 순열이 없으므로 가장 작은 순서로 재배열합니다.
```

**예시 3:**
```
Input: nums = [1,1,5]
Output: [1,5,1]
```',
    '- `1 <= nums.length <= 100`
- `0 <= nums[i] <= 100`'
);

------------------------------------------------------------
-- #53 first-missing-positive
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'first-missing-positive'),
    'ko',
    '최소 누락 양수',
    '정렬되지 않은 정수 배열 `nums`가 주어졌을 때, 배열에 없는 가장 작은 양의 정수를 반환하세요.

**O(n)** 시간, **O(1)** 추가 공간으로 풀어야 합니다.

**예시 1:**
```
Input: nums = [1,2,0]
Output: 3
Explanation: 1과 2가 있으므로 누락된 최소 양수는 3입니다.
```

**예시 2:**
```
Input: nums = [3,4,-1,1]
Output: 2
Explanation: 1은 있지만 2가 빠져 있습니다.
```

**예시 3:**
```
Input: nums = [7,8,9,11,12]
Output: 1
Explanation: 가장 작은 양수인 1이 배열에 없습니다.
```',
    '- `1 <= nums.length <= 10^5`
- `-2^31 <= nums[i] <= 2^31 - 1`'
);

------------------------------------------------------------
-- #54 rain-collector
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'rain-collector'),
    'ko',
    '빗물 모으기',
    '음이 아닌 정수 `n`개로 이루어진 배열 `height`가 주어집니다. 각 원소는 너비 1인 막대의 높이를 나타냅니다. 비가 온 후 막대 사이에 고이는 물의 총량을 구하세요.

각 위치에 고이는 물의 양은 왼쪽에서 가장 높은 막대와 오른쪽에서 가장 높은 막대 중 작은 값에서 해당 막대의 높이를 뺀 값입니다.

**예시 1:**
```
Input: height = [0,1,0,2,1,0,1,3,2,1,2,1]
Output: 6
Explanation: 지형도에 총 6단위의 빗물이 고입니다.
```

**예시 2:**
```
Input: height = [4,2,0,3,2,5]
Output: 9
```',
    '- `n == height.length`
- `1 <= n <= 2 * 10^4`
- `0 <= height[i] <= 10^5`'
);

------------------------------------------------------------
-- #55 move-zeroes
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'move-zeroes'),
    'ko',
    '0 이동',
    '정수 배열 `nums`가 주어졌을 때, 모든 `0`을 배열 끝으로 옮기되 나머지 원소의 상대적 순서는 유지하세요.

배열을 복사하지 않고 **제자리(in-place)**에서 수정해야 합니다.

**예시 1:**
```
Input: nums = [0,1,0,3,12]
Output: [1,3,12,0,0]
Explanation: 0이 아닌 원소의 순서는 그대로 유지되고, 모든 0이 뒤로 이동합니다.
```

**예시 2:**
```
Input: nums = [0]
Output: [0]
```',
    '- `1 <= nums.length <= 10^4`
- `-2^31 <= nums[i] <= 2^31 - 1`'
);

------------------------------------------------------------
-- #56 substring-permutation
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'substring-permutation'),
    'ko',
    '부분 문자열 순열',
    '두 문자열 `s1`과 `s2`가 주어졌을 때, `s2`에 `s1`의 순열이 부분 문자열로 포함되어 있으면 `true`를, 아니면 `false`를 반환하세요.

즉, `s1`의 문자를 재배열한 결과가 `s2`의 연속된 구간에 존재하는지 확인하세요.

**예시 1:**
```
Input: s1 = "ab", s2 = "eidbaooo"
Output: true
Explanation: s2에 s1의 순열인 "ba"가 포함되어 있습니다.
```

**예시 2:**
```
Input: s1 = "ab", s2 = "eidboaoo"
Output: false
Explanation: s2의 어떤 연속 부분 문자열도 s1의 순열이 아닙니다.
```',
    '- `1 <= s1.length, s2.length <= 10^4`
- `s1`과 `s2`는 소문자 영어 알파벳으로 구성됩니다.'
);

------------------------------------------------------------
-- #57 window-maximum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'window-maximum'),
    'ko',
    '윈도우 최댓값',
    '정수 배열 `nums`와 정수 `k`가 주어집니다. 크기 `k`의 슬라이딩 윈도우가 배열의 왼쪽에서 오른쪽으로 한 칸씩 이동합니다. 각 위치에서 윈도우 안의 원소 `k`개를 볼 수 있습니다.

각 윈도우 위치에서의 최댓값을 담은 배열을 반환하세요.

**예시 1:**
```
Input: nums = [1,3,-1,-3,5,3,6,7], k = 3
Output: [3,3,5,5,6,7]
Explanation:
Window position                Max
---------------               -----
[1  3  -1] -3  5  3  6  7       3
 1 [3  -1  -3] 5  3  6  7       3
 1  3 [-1  -3  5] 3  6  7       5
 1  3  -1 [-3  5  3] 6  7       5
 1  3  -1  -3 [5  3  6] 7       6
 1  3  -1  -3  5 [3  6  7]      7
```

**예시 2:**
```
Input: nums = [1], k = 1
Output: [1]
```',
    '- `1 <= nums.length <= 10^5`
- `-10^4 <= nums[i] <= 10^4`
- `1 <= k <= nums.length`'
);

------------------------------------------------------------
-- #58 polish-notation
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'polish-notation'),
    'ko',
    '역폴란드 표기법',
    '**역폴란드 표기법**(RPN)으로 작성된 산술 식을 계산하세요.

사용 가능한 연산자는 `+`, `-`, `*`, `/`이며, 각 피연산자는 정수 또는 하위 식입니다. 두 정수의 나눗셈은 0 방향으로 내림합니다.

입력은 항상 유효한 RPN 식이며 결과가 존재하고, 0으로 나누는 경우는 없습니다.

**예시 1:**
```
Input: tokens = ["2","1","+","3","*"]
Output: 9
Explanation: ((2 + 1) * 3) = 9
```

**예시 2:**
```
Input: tokens = ["4","13","5","/","+"]
Output: 6
Explanation: (4 + (13 / 5)) = 6
```

**예시 3:**
```
Input: tokens = ["10","6","9","3","+","-11","*","/","*","17","+","5","+"]
Output: 22
Explanation: ((10 * (6 / ((9 + 3) * -11))) + 17) + 5 = 22
```',
    '- `1 <= tokens.length <= 10^4`
- `tokens[i]`는 연산자(`+`, `-`, `*`, `/`) 또는 `[-200, 200]` 범위의 정수입니다.'
);

------------------------------------------------------------
-- #59 parentheses-generator
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'parentheses-generator'),
    'ko',
    '괄호 생성기',
    '괄호 쌍의 개수를 나타내는 정수 `n`이 주어졌을 때, 만들 수 있는 모든 **올바른 괄호 조합**을 반환하세요.

여는 괄호 `(`마다 대응하는 닫는 괄호 `)`가 있고, 올바르게 중첩된 경우를 올바른 괄호라고 합니다.

**예시 1:**
```
Input: n = 3
Output: ["((()))","(()())","(())()","()(())","()()()"]
Explanation: 3쌍의 괄호로 만들 수 있는 올바른 조합 5가지입니다.
```

**예시 2:**
```
Input: n = 1
Output: ["()"]
```',
    '- `1 <= n <= 8`'
);

------------------------------------------------------------
-- #60 temperature-wait
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'temperature-wait'),
    'ko',
    '기온 대기',
    '일별 기온을 나타내는 정수 배열 `temperatures`가 주어졌을 때, `answer[i]`에 `i`일 이후 더 따뜻한 날이 올 때까지 기다려야 하는 일수를 담은 배열 `answer`를 반환하세요.

더 따뜻한 날이 없으면 `answer[i]`를 `0`으로 설정합니다.

**예시 1:**
```
Input: temperatures = [73,74,75,71,69,72,76,73]
Output: [1,1,4,2,1,1,0,0]
Explanation: 0일(73도)의 다음 따뜻한 날은 1일(74도)이므로 answer[0] = 1. 2일(75도)의 다음 따뜻한 날은 6일(76도)이므로 answer[2] = 4.
```

**예시 2:**
```
Input: temperatures = [30,40,50,60]
Output: [1,1,1,0]
Explanation: 마지막 날을 제외하면 매일 전날보다 기온이 높아집니다.
```

**예시 3:**
```
Input: temperatures = [30,60,90]
Output: [1,1,0]
```',
    '- `1 <= temperatures.length <= 10^5`
- `30 <= temperatures[i] <= 100`'
);
