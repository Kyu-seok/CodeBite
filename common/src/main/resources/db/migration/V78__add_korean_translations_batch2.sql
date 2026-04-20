-- Korean translations: batch 2 (problems #11-20)

------------------------------------------------------------
-- #11 sorted-pair-sum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sorted-pair-sum'),
    'ko',
    '정렬된 두 수의 합',
    '**1-인덱스** 기반의 정수 배열 `numbers`가 비내림차순으로 정렬되어 주어집니다. 두 수의 합이 `target`이 되는 두 수를 찾으세요.

두 수의 인덱스를 정수 배열 `[index1, index2]`로 반환하세요. 단, `1 <= index1 < index2 <= numbers.length`를 만족해야 합니다.

각 입력에는 정확히 하나의 해가 존재하며, 같은 원소를 두 번 사용할 수 없습니다. 상수 추가 공간만 사용하는 풀이를 작성하세요.

**예시 1:**
```
Input: numbers = [2,7,11,15], target = 9
Output: [1,2]
Explanation: 2와 7의 합이 9이므로 index1 = 1, index2 = 2를 반환합니다.
```

**예시 2:**
```
Input: numbers = [2,3,4], target = 6
Output: [1,3]
```

**예시 3:**
```
Input: numbers = [-1,0], target = -1
Output: [1,2]
```',
    '- `2 <= numbers.length <= 3 * 10^4`
- `-1000 <= numbers[i] <= 1000`
- `numbers`는 비내림차순으로 정렬되어 있습니다.
- `-1000 <= target <= 1000`
- 정확히 하나의 해가 존재함이 보장됩니다.'
);

------------------------------------------------------------
-- #12 three-sum
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'three-sum'),
    'ko',
    '세 수의 합',
    '정수 배열 `nums`가 주어졌을 때, `nums[i] + nums[j] + nums[k] == 0`을 만족하는 모든 고유한 세 쌍 `[nums[i], nums[j], nums[k]]`를 반환하세요. 단, `i`, `j`, `k`는 서로 다른 인덱스여야 합니다.

결과에 중복된 세 쌍이 포함되면 안 됩니다. 세 쌍의 순서는 상관없습니다.

**예시 1:**
```
Input: nums = [-1,0,1,2,-1,-4]
Output: [[-1,-1,2],[-1,0,1]]
Explanation: nums[0] + nums[1] + nums[2] = (-1) + 0 + 1 = 0, nums[0] + nums[3] + nums[4] = (-1) + 2 + (-1) = 0. 고유한 세 쌍은 [-1,0,1]과 [-1,-1,2]입니다.
```

**예시 2:**
```
Input: nums = [0,1,1]
Output: []
Explanation: 합이 0이 되는 세 쌍이 존재하지 않습니다.
```

**예시 3:**
```
Input: nums = [0,0,0]
Output: [[0,0,0]]
```',
    '- `3 <= nums.length <= 3000`
- `-10^5 <= nums[i] <= 10^5`'
);

------------------------------------------------------------
-- #13 water-container
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'water-container'),
    'ko',
    '물 담기',
    '길이 `n`의 정수 배열 `height`가 주어집니다. `i`번째 선분의 두 끝점은 `(i, 0)`과 `(i, height[i])`입니다.

두 선분을 골라 x축과 함께 물을 가장 많이 담을 수 있는 컨테이너를 만드세요. 컨테이너가 담을 수 있는 최대 물의 양을 반환하세요.

컨테이너를 기울일 수는 없습니다.

**예시 1:**
```
Input: height = [1,8,6,2,5,4,8,3,7]
Output: 49
Explanation: 인덱스 1과 8의 선분으로 만든 컨테이너가 49만큼의 물을 담을 수 있습니다.
```

**예시 2:**
```
Input: height = [1,1]
Output: 1
```',
    '- `n == height.length`
- `2 <= n <= 10^5`
- `0 <= height[i] <= 10^4`'
);

------------------------------------------------------------
-- #14 stock-profit
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'stock-profit'),
    'ko',
    '주식 수익',
    '배열 `prices`가 주어지며, `prices[i]`는 `i`번째 날의 주식 가격입니다.

하루를 골라 주식을 사고, 그 이후의 다른 날에 팔아서 수익을 최대화하려 합니다. 이 거래에서 얻을 수 있는 최대 수익을 반환하세요.

수익을 낼 수 없으면 `0`을 반환하세요.

**예시 1:**
```
Input: prices = [7,1,5,3,6,4]
Output: 5
Explanation: 2일차에 사고(가격 = 1) 5일차에 팔면(가격 = 6) 수익 = 6-1 = 5입니다.
```

**예시 2:**
```
Input: prices = [7,6,4,3,1]
Output: 0
Explanation: 가격이 계속 하락하므로 수익을 낼 수 있는 거래가 없습니다. 최대 수익 = 0.
```',
    '- `1 <= prices.length <= 10^5`
- `0 <= prices[i] <= 10^4`'
);

------------------------------------------------------------
-- #15 unique-substring
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'unique-substring'),
    'ko',
    '고유 문자 부분 문자열',
    '문자열 `s`가 주어졌을 때, 중복 문자가 없는 가장 긴 부분 문자열의 길이를 구하세요.

**부분 문자열**이란 문자열 내의 연속된 문자 시퀀스입니다.

**예시 1:**
```
Input: s = "abcabcbb"
Output: 3
Explanation: 답은 "abc"이며 길이는 3입니다.
```

**예시 2:**
```
Input: s = "bbbbb"
Output: 1
Explanation: 답은 "b"이며 길이는 1입니다.
```

**예시 3:**
```
Input: s = "pwwkew"
Output: 3
Explanation: 답은 "wke"이며 길이는 3입니다.
```',
    '- `0 <= s.length <= 5 * 10^4`
- `s`는 영문자, 숫자, 기호, 공백으로 구성됩니다.'
);

------------------------------------------------------------
-- #16 character-swap
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'character-swap'),
    'ko',
    '문자 교체',
    '대문자 영어로만 이루어진 문자열 `s`와 정수 `k`가 주어집니다. 문자열에서 아무 문자를 골라 다른 대문자 영어 글자로 바꿀 수 있으며, 이 작업을 최대 `k`번 수행할 수 있습니다.

최대 `k`번 교체한 후, 같은 문자로만 이루어진 가장 긴 부분 문자열의 길이를 반환하세요.

**예시 1:**
```
Input: s = "ABAB", k = 2
Output: 4
Explanation: 두 ''A''를 ''B''로 바꾸거나 그 반대로 하면 됩니다.
```

**예시 2:**
```
Input: s = "AABABBA", k = 1
Output: 4
Explanation: 가운데 ''B'' 하나를 ''A''로 바꾸면 "AABAAABA"가 됩니다. 부분 문자열 "AAAA"의 길이는 4입니다.
```',
    '- `1 <= s.length <= 10^5`
- `s`는 대문자 영어 글자로만 구성됩니다.
- `0 <= k <= s.length`'
);

------------------------------------------------------------
-- #17 smallest-window
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'smallest-window'),
    'ko',
    '최소 윈도우',
    '두 문자열 `s`와 `t`가 주어졌을 때, `t`의 모든 문자(중복 포함)를 포함하는 `s`의 가장 짧은 부분 문자열을 반환하세요. 그런 부분 문자열이 없으면 빈 문자열 `""`을 반환하세요.

`t`의 각 문자는 윈도우에 `t`에서의 등장 횟수 이상 포함되어야 합니다. 같은 최소 길이의 윈도우가 여러 개면 가장 먼저 나오는 것을 반환하세요.

**예시 1:**
```
Input: s = "ADOBECODEBANC", t = "ABC"
Output: "BANC"
Explanation: 최소 윈도우 부분 문자열 "BANC"에 t의 ''A'', ''B'', ''C''가 모두 포함됩니다.
```

**예시 2:**
```
Input: s = "a", t = "a"
Output: "a"
```

**예시 3:**
```
Input: s = "a", t = "aa"
Output: ""
Explanation: t의 ''a'' 두 개가 모두 윈도우에 포함되어야 합니다. s에서 가장 큰 윈도우에도 ''a''가 하나뿐이므로 빈 문자열을 반환합니다.
```',
    '- `m == s.length`
- `n == t.length`
- `1 <= m, n <= 10^5`
- `s`와 `t`는 대소문자 영어 글자로 구성됩니다.'
);

------------------------------------------------------------
-- #18 bracket-validator
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bracket-validator'),
    'ko',
    '괄호 검증',
    '`(`, `)`, `{`, `}`, `[`, `]` 문자만 포함하는 문자열 `s`가 주어졌을 때, 유효한 괄호 문자열인지 판별하세요.

다음 조건을 모두 만족하면 유효합니다:
1. 모든 여는 괄호는 같은 종류의 닫는 괄호로 닫혀야 합니다.
2. 여는 괄호는 올바른 순서로 닫혀야 합니다.
3. 모든 닫는 괄호에는 대응하는 같은 종류의 여는 괄호가 있어야 합니다.

**예시 1:**
```
Input: s = "()"
Output: true
```

**예시 2:**
```
Input: s = "()[]{}"
Output: true
```

**예시 3:**
```
Input: s = "(]"
Output: false
```',
    '- `1 <= s.length <= 10^4`
- `s`는 괄호 문자 `''()[]{}''`로만 구성됩니다.'
);

------------------------------------------------------------
-- #19 minimum-stack
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'minimum-stack'),
    'ko',
    '최소 스택',
    'push, pop, top, 최솟값 조회를 모두 상수 시간에 지원하는 스택을 설계하세요.

`MinStack` 클래스의 메서드를 구현하세요:
- `MinStack()` — 스택 객체를 초기화합니다.
- `void push(int val)` — 원소 `val`을 스택에 넣습니다.
- `void pop()` — 스택 꼭대기의 원소를 제거합니다.
- `int top()` — 스택 꼭대기의 원소를 반환합니다.
- `int getMin()` — 스택의 최솟값을 반환합니다.

각 메서드는 `O(1)` 시간에 동작해야 합니다.

**예시 1:**
```
Input:
["MinStack","push","push","push","getMin","pop","top","getMin"]
[[],[-2],[0],[-3],[],[],[],[]]
Output: [null,null,null,null,-3,null,0,-2]
```',
    '- `-2^31 <= val <= 2^31 - 1`
- `pop`, `top`, `getMin`은 항상 비어있지 않은 스택에서 호출됩니다.
- `push`, `pop`, `top`, `getMin` 호출은 최대 `3 * 10^4`번입니다.'
);

------------------------------------------------------------
-- #20 basic-binary-search
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'basic-binary-search'),
    'ko',
    '기본 이진 탐색',
    '오름차순으로 정렬된 정수 배열 `nums`와 정수 `target`이 주어졌을 때, `nums`에서 `target`의 인덱스를 반환하세요. `target`이 배열에 없으면 `-1`을 반환하세요.

`O(log n)` 시간 복잡도의 알고리즘을 작성하세요.

**예시 1:**
```
Input: nums = [-1,0,3,5,9,12], target = 9
Output: 4
Explanation: 9는 nums에 존재하며 인덱스는 4입니다.
```

**예시 2:**
```
Input: nums = [-1,0,3,5,9,12], target = 2
Output: -1
Explanation: 2는 nums에 존재하지 않으므로 -1을 반환합니다.
```',
    '- `1 <= nums.length <= 10^4`
- `-10^4 < nums[i], target < 10^4`
- `nums`의 모든 정수는 고유합니다.
- `nums`는 오름차순으로 정렬되어 있습니다.'
);
