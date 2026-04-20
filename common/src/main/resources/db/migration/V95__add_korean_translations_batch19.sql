-- Korean translations: batch 19 (problems #181-190)

------------------------------------------------------------
-- #181 zero-matrix
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'zero-matrix'),
    'ko',
    '0 행렬 변환',
    '`m x n` 정수 행렬이 주어졌을 때, 값이 `0`인 원소가 있으면 해당 원소의 행 전체와 열 전체를 모두 `0`으로 바꾸세요. 행렬을 **제자리(in-place)**에서 수정해야 합니다.

원래 `0`이었던 위치를 기준으로 행과 열을 채워야 합니다. 원래 `0`이 아니었더라도 같은 행이나 열에 `0`이 있으면 함께 `0`이 됩니다.

**예시 1:**
```
Input: matrix = [[1,1,1],[1,0,1],[1,1,1]]
Output: [[1,0,1],[0,0,0],[1,0,1]]
Explanation: (1, 1) 위치의 값이 0이므로, 1번 행 전체와 1번 열 전체가 0이 됩니다.
```

**예시 2:**
```
Input: matrix = [[0,1,2,0],[3,4,5,2],[1,3,1,5]]
Output: [[0,0,0,0],[0,4,5,0],[0,3,1,0]]
Explanation: 0번 행의 0번, 3번 열에 0이 있으므로 0번 행 전체와 0번, 3번 열 전체가 0으로 바뀝니다.
```

**예시 3:**
```
Input: matrix = [[1,2],[3,4]]
Output: [[1,2],[3,4]]
Explanation: 0이 없으므로 행렬이 그대로 유지됩니다.
```',
    '- `m == matrix.length`
- `n == matrix[0].length`
- `1 <= m, n <= 200`
- `-2^31 <= matrix[i][j] <= 2^31 - 1`'
);

------------------------------------------------------------
-- #182 power-function
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'power-function'),
    'ko',
    '거듭제곱 계산',
    '실수 `x`와 정수 `n`이 주어졌을 때, `x`의 `n`제곱(`x^n`)을 구하세요.

음수 지수도 처리해야 합니다. `n`이 음수이면 `x^n`은 `1 / x^|n|`과 같습니다. 예를 들어 `2^-2 = 1 / (2^2) = 0.25`입니다.

`x`를 `n`번 반복해서 곱하는 단순한 방법은 `n`이 클 때 너무 느립니다. 곱셈 횟수를 줄이는 방법을 생각해 보세요.

결과는 소수점 5자리까지 반올림하여 반환하세요.

**예시 1:**
```
Input: x = 2.00000, n = 10
Output: 1024.00000
```

**예시 2:**
```
Input: x = 2.10000, n = 3
Output: 9.26100
```

**예시 3:**
```
Input: x = 2.00000, n = -2
Output: 0.25000
Explanation: 2^-2 = 1 / (2^2) = 1/4 = 0.25
```',
    '- `-100.0 < x < 100.0`
- `-2^31 <= n <= 2^31 - 1`
- `n`은 정수
- `x`가 0이 아니거나 `n > 0`
- `-10^4 <= x^n <= 10^4`'
);

------------------------------------------------------------
-- #183 string-multiply
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'string-multiply'),
    'ko',
    '문자열 곱셈',
    '문자열로 표현된 두 음이 아닌 정수 `num1`과 `num2`가 주어졌을 때, 두 수의 곱을 문자열로 반환하세요.

내장 큰 수 라이브러리를 사용하거나 입력을 직접 정수로 변환하면 안 됩니다. 손으로 필산하듯이 자릿수별로 곱셈을 수행하세요.

**예시 1:**
```
Input: num1 = "2", num2 = "3"
Output: "6"
```

**예시 2:**
```
Input: num1 = "123", num2 = "456"
Output: "56088"
```

**예시 3:**
```
Input: num1 = "99", num2 = "0"
Output: "0"
Explanation: 어떤 수든 0을 곱하면 0입니다.
```',
    '- `1 <= num1.length, num2.length <= 200`
- num1과 num2는 숫자로만 구성됩니다
- 숫자 0 자체를 제외하면 num1과 num2에 선행 0이 없습니다'
);

------------------------------------------------------------
-- #184 joyful-number
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'joyful-number'),
    'ko',
    '즐거운 수',
    '양의 정수 `n`이 주어졌을 때, **즐거운 수**인지 판별하세요.

즐거운 수란 다음 과정을 반복했을 때 최종적으로 `1`에 도달하는 수입니다: 각 자릿수의 제곱을 모두 더한 뒤, 그 결과로 같은 과정을 반복합니다. 만약 `1`에 도달하지 못하고 무한 루프에 빠지면 즐거운 수가 아닙니다.

`n`이 즐거운 수이면 `true`를, 아니면 `false`를 반환하세요.

**예시 1:**
```
Input: n = 19
Output: true
Explanation: 1^2 + 9^2 = 82, 8^2 + 2^2 = 68, 6^2 + 8^2 = 100, 1^2 + 0^2 + 0^2 = 1
```

**예시 2:**
```
Input: n = 2
Output: false
Explanation: 자릿수 제곱합이 순환하며 1에 도달하지 못합니다.
```

**예시 3:**
```
Input: n = 1
Output: true
```',
    '- `1 <= n <= 2^31 - 1`'
);

------------------------------------------------------------
-- #185 increment-digits
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'increment-digits'),
    'ko',
    '숫자 배열 +1',
    '음이 아닌 정수가 자릿수 배열로 주어집니다. `digits[0]`이 가장 높은 자릿수입니다. 이 수에 1을 더한 결과를 자릿수 배열로 반환하세요.

입력에는 선행 0이 없습니다(숫자 0 자체인 `[0]`은 예외). 자릿수 올림(예: `9 + 1 = 10`)을 올바르게 처리해야 합니다.

**예시 1:**
```
Input: digits = [1,2,3]
Output: [1,2,4]
Explanation: 123에 1을 더하면 124가 됩니다.
```

**예시 2:**
```
Input: digits = [9,9]
Output: [1,0,0]
Explanation: 99 + 1 = 100이므로 자릿수가 하나 늘어납니다.
```

**예시 3:**
```
Input: digits = [0]
Output: [1]
```',
    '- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- 숫자 0 자체를 제외하면 입력 배열에 선행 0이 없습니다'
);

------------------------------------------------------------
-- #186 fizz-buzz-game
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'fizz-buzz-game'),
    'ko',
    'Fizz Buzz 게임',
    '양의 정수 `n`이 주어졌을 때, `1`부터 `n`까지 각 숫자에 대해 다음 규칙으로 문자열 배열을 만드세요:

- 3과 5 모두의 배수이면 `"FizzBuzz"`
- 3의 배수이면 `"Fizz"`
- 5의 배수이면 `"Buzz"`
- 그 외에는 숫자를 문자열로 변환

결과 배열을 반환하세요.

**예시 1:**
```
Input: n = 3
Output: ["1","2","Fizz"]
```

**예시 2:**
```
Input: n = 5
Output: ["1","2","Fizz","4","Buzz"]
```

**예시 3:**
```
Input: n = 15
Output: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```',
    '- `1 <= n <= 10^4`'
);

------------------------------------------------------------
-- #187 mirror-number
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'mirror-number'),
    'ko',
    '회문 수',
    '정수 `x`가 주어졌을 때, 앞에서 읽으나 뒤에서 읽으나 같으면 `true`를, 아니면 `false`를 반환하세요.

음수는 앞에 마이너스 부호가 있으므로 절대 회문 수가 될 수 없습니다. 예를 들어 `-121`을 뒤집으면 `121-`이 되어 원래와 다릅니다.

**예시 1:**
```
Input: x = 121
Output: true
Explanation: 121을 뒤집어도 121입니다.
```

**예시 2:**
```
Input: x = -45
Output: false
Explanation: 음수는 마이너스 부호 때문에 회문 수가 될 수 없습니다.
```

**예시 3:**
```
Input: x = 10
Output: false
Explanation: 10을 뒤집으면 01이 되어 10과 다릅니다.
```',
    '- `-2^31 <= x <= 2^31 - 1`'
);

------------------------------------------------------------
-- #188 numeral-converter
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'numeral-converter'),
    'ko',
    '로마 숫자 변환',
    '로마 숫자를 나타내는 문자열 `s`가 주어졌을 때, 정수 값으로 변환하세요.

로마 숫자는 7개의 기호를 사용합니다:
- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

보통 큰 기호에서 작은 기호 순서로 왼쪽부터 씁니다. 단, 작은 기호가 큰 기호 바로 앞에 오면 뺄셈을 의미합니다. 예를 들어 `IV`는 4(5 - 1), `IX`는 9(10 - 1)입니다.

유효한 뺄셈 조합은 총 6가지입니다:
- `IV` = 4, `IX` = 9
- `XL` = 40, `XC` = 90
- `CD` = 400, `CM` = 900

주어진 로마 숫자의 정수 값을 반환하세요.

**예시 1:**
```
Input: s = "III"
Output: 3
Explanation: I + I + I = 3.
```

**예시 2:**
```
Input: s = "LVIII"
Output: 58
Explanation: L + V + I + I + I = 50 + 5 + 1 + 1 + 1 = 58.
```

**예시 3:**
```
Input: s = "MCMXCIV"
Output: 1994
Explanation: M + CM + XC + IV = 1000 + 900 + 90 + 4 = 1994.
```',
    '- `1 <= s.length <= 15`
- s는 I, V, X, L, C, D, M 문자로만 구성됩니다
- 입력은 `[1, 3999]` 범위의 유효한 로마 숫자입니다'
);

------------------------------------------------------------
-- #189 bit-tracker
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'bit-tracker'),
    'ko',
    '비트 개수 추적',
    '음이 아닌 정수 `n`이 주어졌을 때, 길이 `n + 1`인 배열 `answer`를 반환하세요. `answer[i]`는 `i`의 이진 표현에서 `1`인 비트의 개수입니다.

즉, `0`부터 `n`까지 각 정수에 대해 `1`로 설정된 비트 수를 세어 해당 인덱스에 저장하세요.

**예시 1:**
```
Input: n = 2
Output: [0,1,1]
Explanation: 0 = 0b0 (1이 0개), 1 = 0b1 (1이 1개), 2 = 0b10 (1이 1개)
```

**예시 2:**
```
Input: n = 5
Output: [0,1,1,2,1,2]
Explanation: 0~5의 이진수는 0, 1, 10, 11, 100, 101
```

**예시 3:**
```
Input: n = 0
Output: [0]
```',
    '- `0 <= n <= 10^5`'
);

------------------------------------------------------------
-- #190 flip-bits
------------------------------------------------------------
INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES (
    (SELECT id FROM problems WHERE slug = 'flip-bits'),
    'ko',
    '비트 뒤집기',
    '32비트 부호 없는 정수 `n`이 주어졌을 때, 32개 비트의 순서를 모두 뒤집어 부호 없는 정수로 반환하세요.

입력의 비트 0(최하위 비트)이 출력의 비트 31(최상위 비트)이 되고, 비트 1은 비트 30이 되는 식으로 32개 위치 모두 뒤집습니다.

**예시 1:**
```
Input: n = 43261596
Output: 964176192
Explanation: 43261596의 이진수는 00000010100101000001111010011100입니다. 비트를 뒤집으면 00111001011110000010100101000000이 되어 964176192입니다.
```

**예시 2:**
```
Input: n = 4294967293
Output: 3221225471
Explanation: 4294967293의 이진수는 11111111111111111111111111111101입니다. 뒤집으면 10111111111111111111111111111111이 되어 3221225471입니다.
```

**예시 3:**
```
Input: n = 1
Output: 2147483648
Explanation: 비트 0만 1입니다. 뒤집으면 비트 31로 이동하여 2147483648이 됩니다.
```',
    '- 입력은 32비트 부호 없는 정수입니다 (`0 <= n <= 2^32 - 1`)'
);
