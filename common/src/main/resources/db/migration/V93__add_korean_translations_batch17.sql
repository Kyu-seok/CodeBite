-- Korean translations: batch 17 (problems #161-170)

------------------------------------------------------------
-- #161 longest-chain-count
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'longest-chain-count'),
    'ko',
    '최장 증가 부분수열 개수',
    '정수 배열 `nums`가 주어졌을 때, **가장 긴 순증가 부분수열**의 개수를 반환하세요.

**순증가 부분수열**이란 배열에서 선택한 원소들로 이루어진 수열(연속일 필요 없음)로, 각 원소가 바로 앞 원소보다 엄격히 큰 것을 말합니다. 먼저 모든 부분수열 중 최대 길이를 구한 뒤, 그 최대 길이를 달성하는 부분수열이 몇 개인지 세면 됩니다.

**예시 1:**
```
Input: nums = [1,3,5,4,7]
Output: 2
Explanation: 최장 증가 부분수열의 길이는 4이며, [1,3,5,7]과 [1,3,4,7] 두 가지가 있습니다.
```

**예시 2:**
```
Input: nums = [2,2,2,2,2]
Output: 5
Explanation: 각 원소가 길이 1짜리 증가 부분수열을 이루므로, 총 5개입니다.
```

**예시 3:**
```
Input: nums = [1,2,3]
Output: 1
Explanation: 최장 증가 부분수열은 [1,2,3] 하나뿐이며 길이는 3입니다.
```',
    '- `1 <= nums.length <= 2000`
- `-10^6 <= nums[i] <= 10^6`'
);

------------------------------------------------------------
-- #162 stock-cooldown
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'stock-cooldown'),
    'ko',
    '주식 쿨다운',
    '정수 배열 `prices`가 주어지며, `prices[i]`는 `i`번째 날의 주식 가격입니다.

다음 규칙 하에서 매수-매도 거래를 원하는 만큼 할 수 있습니다:
- 한 번에 최대 1주만 보유할 수 있습니다.
- 주식을 판 다음 날은 반드시 쉬어야 합니다(**쿨다운** 기간).

얻을 수 있는 최대 총 수익을 반환하세요.

**예시 1:**
```
Input: prices = [1,2,3,0,2]
Output: 3
Explanation: 0일에 매수, 1일에 매도(수익 1). 2일은 쿨다운. 3일에 매수, 4일에 매도(수익 2). 총 수익 3.
```

**예시 2:**
```
Input: prices = [1]
Output: 0
Explanation: 하루뿐이라 거래를 완료할 수 없습니다.
```

**예시 3:**
```
Input: prices = [1,4,2,7]
Output: 6
Explanation: 0일에 매수, 3일에 매도하면 수익 6. 중간에 팔고 다시 사는 것보다 이 방법이 최적입니다.
```',
    '- `1 <= prices.length <= 5000`
- `0 <= prices[i] <= 1000`'
);

------------------------------------------------------------
-- #163 sign-assignments
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'sign-assignments'),
    'ko',
    '부호 배정',
    '정수 배열 `nums`와 정수 `target`이 주어집니다. 각 원소 앞에 `+` 또는 `-` 부호를 붙여서 합이 `target`이 되는 경우의 수를 반환하세요.

모든 원소는 정확히 한 번씩 사용해야 하며, 각 원소에 `+` 또는 `-` 중 하나를 반드시 배정해야 합니다.

**예시 1:**
```
Input: nums = [1,1,1,1,1], target = 3
Output: 5
Explanation: 합이 3이 되는 부호 배정은 5가지입니다: +1+1+1+1-1, +1+1+1-1+1, +1+1-1+1+1, +1-1+1+1+1, -1+1+1+1+1.
```

**예시 2:**
```
Input: nums = [1], target = 1
Output: 1
```

**예시 3:**
```
Input: nums = [2,3,5], target = 0
Output: 2
Explanation: +2+3-5 = 0, -2-3+5 = 0.
```',
    '- `1 <= nums.length <= 20`
- `0 <= nums[i] <= 1000`
- `-1000 <= target <= 1000`'
);

------------------------------------------------------------
-- #164 string-weave
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'string-weave'),
    'ko',
    '문자열 엮기',
    '세 문자열 `s1`, `s2`, `s3`가 주어졌을 때, `s3`가 `s1`과 `s2`를 **인터리빙**하여 만들 수 있는지 판별하세요.

인터리빙이란 두 문자열의 모든 문자를 정확히 한 번씩 사용하되, 각 문자열 내에서의 상대적 순서를 유지하면서 합치는 것입니다. 예를 들어, `"aaxaby"`는 `"aab"`과 `"axy"`의 유효한 인터리빙이지만, `"abaaxy"`는 아닙니다.

`s3`가 `s1`과 `s2`의 유효한 인터리빙이면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: s1 = "aab", s2 = "axy", s3 = "aaxaby"
Output: true
Explanation: s1에서 "a", s2에서 "a","x", s1에서 "a","b", s2에서 "y" 순서로 가져오면 됩니다.
```

**예시 2:**
```
Input: s1 = "aab", s2 = "axy", s3 = "abaaxy"
Output: false
Explanation: 순서를 유지하면서 s1과 s2를 엮어 s3를 만들 수 없습니다.
```

**예시 3:**
```
Input: s1 = "", s2 = "", s3 = ""
Output: true
Explanation: 빈 문자열 두 개를 합치면 빈 문자열이 됩니다.
```',
    '- `0 <= s1.length, s2.length <= 100`
- `0 <= s3.length <= 200`
- s1, s2, s3는 소문자 영어 알파벳으로 구성됩니다'
);

------------------------------------------------------------
-- #165 subsequence-count
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'subsequence-count'),
    'ko',
    '부분수열 개수',
    '두 문자열 `s`와 `t`가 주어졌을 때, `s`에서 `t`와 같은 **서로 다른 부분수열**의 개수를 반환하세요.

**부분수열**이란 문자열에서 0개 이상의 문자를 삭제하되 나머지 문자의 상대적 순서는 바꾸지 않고 만든 문자열입니다. 예를 들어, `"ace"`는 `"abcde"`의 부분수열이지만, `"aec"`는 아닙니다.

답은 64비트 정수 범위에 들어감이 보장됩니다.

**예시 1:**
```
Input: s = "rabbbit", t = "rabbit"
Output: 3
Explanation: s에서 "rabbit"을 만드는 방법은 3가지입니다 -- 세 개의 ''b'' 중 어떤 것을 가운데 ''b''로 사용하느냐에 따라 달라집니다.
```

**예시 2:**
```
Input: s = "babgbag", t = "bag"
Output: 5
Explanation: s에서 "bag" 부분수열을 만드는 서로 다른 방법이 5가지 있습니다.
```

**예시 3:**
```
Input: s = "aaa", t = "a"
Output: 3
```',
    '- `1 <= s.length, t.length <= 1000`
- s와 t는 소문자 영어 알파벳으로 구성됩니다'
);

------------------------------------------------------------
-- #166 pattern-matcher
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'pattern-matcher'),
    'ko',
    '패턴 매칭',
    '문자열 `s`와 패턴 `p`가 주어졌을 때, 패턴이 문자열 **전체**와 일치하는지 판별하세요.

패턴에는 두 가지 특수 문자를 사용할 수 있습니다:
- `.`은 임의의 한 문자와 일치합니다.
- `*`는 바로 앞 문자가 **0번 이상** 반복되는 것과 일치합니다.

부분 문자열이 아니라, `s` 전체가 처음부터 끝까지 매칭되어야 합니다.

**예시 1:**
```
Input: s = "aa", p = "a"
Output: false
Explanation: 패턴 "a"는 한 글자만 커버하므로, "aa" 전체와 일치하지 않습니다.
```

**예시 2:**
```
Input: s = "aa", p = "a*"
Output: true
Explanation: ''*''는 앞의 ''a''가 0번 이상 반복을 의미하므로, "a*"는 "aa"와 일치합니다.
```

**예시 3:**
```
Input: s = "ab", p = ".*"
Output: true
Explanation: ".*"는 임의의 문자가 0번 이상 반복이므로, 어떤 문자열과도 일치합니다.
```',
    '- `1 <= s.length <= 20`
- `1 <= p.length <= 20`
- s는 소문자 영어 알파벳으로만 구성됩니다
- p는 소문자 영어 알파벳, ''.'', ''*''로만 구성됩니다
- 각 ''*'' 앞에는 유효한 문자가 존재합니다 (''*''가 첫 글자이거나 다른 ''*'' 바로 뒤에 오는 경우는 없습니다)'
);

------------------------------------------------------------
-- #167 balloon-popper
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'balloon-popper'),
    'ko',
    '풍선 터뜨리기',
    '배열 `nums`가 주어지며, 각 원소는 풍선에 적힌 숫자를 나타냅니다. 풍선을 한 번에 하나씩, 원하는 순서로 터뜨릴 수 있습니다.

인덱스 `i`의 풍선을 터뜨리면 `nums[i - 1] * nums[i] * nums[i + 1]`만큼의 코인을 얻습니다. 풍선이 터지면 제거되고, 양옆 풍선이 서로 인접하게 됩니다. `i - 1` 또는 `i + 1`이 범위를 벗어나면 해당 이웃의 값은 `1`로 취급합니다.

모든 풍선을 터뜨려서 얻을 수 있는 최대 코인 수를 반환하세요.

**예시 1:**
```
Input: nums = [3,1,5,8]
Output: 167
Explanation: 최적 순서로 값 1, 5, 3, 8 순서대로 터뜨리면: 3*1*5 + 3*5*8 + 1*3*8 + 1*8*1 = 15 + 120 + 24 + 8 = 167.
```

**예시 2:**
```
Input: nums = [1,5]
Output: 10
Explanation: 값 1을 먼저 터뜨리면 1*1*5 = 5. 그 다음 5를 터뜨리면 1*5*1 = 5. 합계 = 10.
```

**예시 3:**
```
Input: nums = [9]
Output: 9
Explanation: 풍선이 하나뿐이므로 1*9*1 = 9.
```',
    '- `1 <= nums.length <= 300`
- `0 <= nums[i] <= 100`'
);

------------------------------------------------------------
-- #168 largest-square
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'largest-square'),
    'ko',
    '최대 정사각형',
    '`"0"`과 `"1"`로 이루어진 `m x n` 이진 행렬이 주어졌을 때, `"1"`로만 이루어진 가장 큰 정사각형의 넓이를 구하세요.

한 변의 길이가 `k`인 정사각형의 넓이는 `k * k`입니다. 행렬에 `"1"`이 없으면 `0`을 반환하세요.

**예시 1:**
```
Input: matrix = [["1","0","1","0","0"],["1","0","1","1","1"],["1","1","1","1","1"],["1","0","0","1","0"]]
Output: 4
Explanation: 모두 1로 이루어진 가장 큰 정사각형의 한 변 길이는 2이므로, 넓이는 2 * 2 = 4입니다.
```

**예시 2:**
```
Input: matrix = [["0","1"],["1","0"]]
Output: 1
Explanation: 1로만 이루어진 가장 큰 정사각형의 한 변 길이는 1입니다.
```

**예시 3:**
```
Input: matrix = [["0"]]
Output: 0
Explanation: 행렬에 1이 없으므로 넓이는 0입니다.
```',
    '- `m == matrix.length`
- `n == matrix[i].length`
- `1 <= m, n <= 300`
- `matrix[i][j]`는 ''0'' 또는 ''1'''
);

------------------------------------------------------------
-- #169 change-maker
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'change-maker'),
    'ko',
    '거스름돈 만들기',
    '정수 `amount`와 사용 가능한 동전 종류를 나타내는 정수 배열 `coins`가 주어졌을 때, 합이 정확히 `amount`가 되는 서로 다른 조합의 수를 반환하세요.

각 동전은 무한히 사용할 수 있습니다. 두 조합이 다르다는 것은 적어도 하나의 동전 종류에서 사용 개수가 다르다는 뜻입니다.

목표 금액을 만들 수 없으면 `0`을 반환하세요.

**예시 1:**
```
Input: amount = 5, coins = [1,2,5]
Output: 4
Explanation: 4가지 조합: 5, 2+2+1, 2+1+1+1, 1+1+1+1+1.
```

**예시 2:**
```
Input: amount = 3, coins = [2]
Output: 0
Explanation: 2원짜리 동전으로는 3을 만들 수 없습니다.
```

**예시 3:**
```
Input: amount = 0, coins = [1,2]
Output: 1
Explanation: 금액 0을 만드는 방법은 동전을 하나도 쓰지 않는 경우 딱 한 가지입니다.
```',
    '- `1 <= coins.length <= 300`
- `1 <= coins[i] <= 5000`
- coins의 모든 값은 고유합니다
- `0 <= amount <= 5000`'
);

------------------------------------------------------------
-- #170 cheapest-path
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'cheapest-path'),
    'ko',
    '최소 비용 경로',
    '음이 아닌 정수로 이루어진 `m x n` 격자가 주어졌을 때, 좌상단에서 우하단까지의 경로 중 경로 위 모든 값의 합이 최소가 되는 경로를 찾으세요.

각 단계에서 **오른쪽** 또는 **아래**로만 이동할 수 있습니다.

최소 경로 합을 반환하세요.

**예시 1:**
```
Input: grid = [[1,3,1],[1,5,1],[4,2,1]]
Output: 7
Explanation: 경로 1 -> 3 -> 1 -> 1 -> 1이 가장 작은 합 7을 줍니다.
```

**예시 2:**
```
Input: grid = [[1,2,3],[4,5,6]]
Output: 12
Explanation: 경로 1 -> 2 -> 3 -> 6의 합은 12입니다.
```

**예시 3:**
```
Input: grid = [[5]]
Output: 5
Explanation: 격자에 칸이 하나뿐이므로, 그 값이 답입니다.
```',
    '- `m == grid.length`
- `n == grid[i].length`
- `1 <= m, n <= 200`
- `0 <= grid[i][j] <= 200`'
);
