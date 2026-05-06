-- Refresh Korean translations to fully Korean examples (입력/출력/설명) — batch 19 (problems #181-#190)
--
-- Adopts the new convention from translation-agent.md: every example
-- code-block label is Korean (입력 / 출력 / 설명) and every prose sentence
-- inside the block is Korean. Variable names (board, base, step, left,
-- right, reading, digits, n, code, numeral, upperId, statusWord) stay
-- verbatim. First mention of each variable in Korean prose is paired with
-- a Korean noun phrase describing its role. Constraint identifiers are
-- aligned with the canonical English parameter names from V135 / V149
-- source descriptions.

DELETE FROM problem_translations
WHERE locale = 'ko'
  AND problem_id IN (
    SELECT id FROM problems WHERE slug IN (
      'zero-out-rows-cols', 'battery-drain-power', 'multiply-as-text',
      'calm-phone-number', 'bump-takeout-number', 'fizz-buzz',
      'palindrome-episode-number', 'decode-roman-floor', 'count-flag-bits',
      'reverse-savefile-flags'
    )
  );

INSERT INTO problem_translations (problem_id, locale, title, description, constraints)
VALUES

-- 1. zero-out-rows-cols
((SELECT id FROM problems WHERE slug = 'zero-out-rows-cols'), 'ko',
 $$불량 줄 싹 지우기$$,
 $$퍼즐 게임에서 `0`이 적힌 타일은 자기가 속한 행과 열 전체를 지웁니다. `m x n` 격자 `board`가 주어지면, 원래 `0`이 있던 칸과 같은 행 또는 같은 열에 있는 모든 칸을 `0`으로 바꾸도록 격자를 **제자리에서** 수정하세요.

원래 `0`과 행도 열도 공유하지 않는 칸은 원래 값을 그대로 유지합니다.

**예시 1:**
```
입력: board = [[2,3],[4,5]]
출력: [[2,3],[4,5]]
설명: 0이 하나도 없으므로 격자는 변하지 않습니다.
```

**예시 2:**
```
입력: board = [[4,6,8],[2,0,5],[7,9,3]]
출력: [[4,0,8],[0,0,0],[7,0,3]]
설명: 0이 1행 1열에 있어서 1행과 1열이 모두 0으로 지워집니다.
```$$,
 $$- `m == board.length`
- `n == board[0].length`
- `1 <= m, n <= 200`
- `|board[i][j]| <= 10^8`$$),

-- 2. battery-drain-power
((SELECT id FROM problems WHERE slug = 'battery-drain-power'), 'ko',
 $$배터리 소모율 예측$$,
 $$휴대폰 배터리가 매 시간마다 일정한 배율 `base`만큼 줄어듭니다. `step` 시간 뒤에 얼마나 남는지 알아보려면 `base`의 `step` 제곱을 계산하면 됩니다.

지수 `step`이 음수면 `1 / base^|step|`을 의미합니다(예: `2.0^-3 = 0.125`). 결과는 소수점 다섯째 자리까지 반올림해서 반환하세요. `|step|`이 매우 커질 수 있으므로 단순 반복문으로는 시간 초과가 납니다.

**예시 1:**
```
입력: base = 3.00000, step = 4
출력: 81.00000
```

**예시 2:**
```
입력: base = 2.00000, step = -3
출력: 0.12500
설명: 2.0^-3 = 1 / (2.0^3) = 1/8 = 0.125 입니다.
```$$,
 $$- `-100.0 < base < 100.0`
- `-2 * 10^8 <= step <= 2 * 10^8`
- `step`은 정수입니다
- `base`가 0이 아니거나 `step > 0` 입니다
- `|base^step| <= 8 * 10^4`$$),

-- 3. multiply-as-text
((SELECT id FROM problems WHERE slug = 'multiply-as-text'), 'ko',
 $$문자열로 곱셈$$,
 $$아주 큰 음이 아닌 두 수가 숫자 문자열 `left`와 `right`로 주어집니다. 일반 `int`로는 담을 수 없을 만큼 길어요. 두 수의 곱을 십진 문자열로 반환하세요.

두 입력을 숫자 타입으로 변환하거나, 빅 정수 라이브러리를 쓰거나, 임의 길이 곱셈을 해주는 내장 함수를 호출하면 안 됩니다. 자릿수별로 길이곱셈을 직접 흉내 내야 합니다.

**예시 1:**
```
입력: left = "12", right = "34"
출력: "408"
```

**예시 2:**
```
입력: left = "25", right = "13"
출력: "325"
```$$,
 $$- `1 <= left.length, right.length <= 200`
- `left`와 `right`는 십진 숫자만으로 이루어집니다
- 값이 `0`인 경우를 제외하면 `left`와 `right` 모두 앞자리에 0이 오지 않습니다$$),

-- 4. calm-phone-number
((SELECT id FROM problems WHERE slug = 'calm-phone-number'), 'ko',
 $$평온한 전화번호$$,
 $$양의 정수 `reading`이 주어지면, 그 값을 각 자리 숫자의 제곱 합으로 반복해서 바꿉니다. 이 과정이 결국 `1`에 도달하면 그 수를 **평온하다**고 부르고, 영원히 순환하면 **평온하지 않다**고 합니다.

판정 대상 `reading`이 평온하면 `true`, 그렇지 않으면 `false`를 반환하세요.

**예시 1:**
```
입력: reading = 7
출력: true
설명: 7 -> 49 -> 97 -> 130 -> 10 -> 1 로 결국 1에 도달합니다.
```

**예시 2:**
```
입력: reading = 4
출력: false
설명: 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4 로 다시 4가 나오는 순환에 빠져 1에 도달하지 못합니다.
```$$,
 $$- `1 <= reading <= 2 * 10^8`$$),

-- 5. bump-takeout-number
((SELECT id FROM problems WHERE slug = 'bump-takeout-number'), 'ko',
 $$포장 번호 하나 올리기$$,
 $$포장 박스의 번호가 십진 자리들의 배열 `digits`로 저장돼 있고, `digits[0]`이 가장 큰 자리입니다. 이 수에 1을 더한 결과를 자리 배열로 반환하세요. 필요하면 자리올림도 수행해야 합니다(예: `9,9` 다음은 `1,0,0`).

값이 `0`(즉 `[0]`)인 경우를 제외하면 입력에 앞자리 0은 없습니다.

**예시 1:**
```
입력: digits = [4,5,6]
출력: [4,5,7]
설명: 456 + 1 = 457 입니다.
```

**예시 2:**
```
입력: digits = [2,9,9]
출력: [3,0,0]
설명: 299 + 1 = 300 으로, 길이는 같지만 뒤쪽 자리들이 자리올림으로 다시 쓰입니다.
```$$,
 $$- `1 <= digits.length <= 100`
- `0 <= digits[i] <= 9`
- 값이 `0`인 경우를 제외하면 입력 배열에 앞자리 0은 없습니다$$),

-- 6. fizz-buzz
((SELECT id FROM problems WHERE slug = 'fizz-buzz'), 'ko',
 $$피즈버즈$$,
 $$양의 정수 `n`이 주어지면 길이가 `n`인 배열 `answer`를 반환하세요. `1`부터 `n`까지의 각 정수 `i`에 대해:
- `i`가 3과 5 모두로 나누어떨어지면 `answer[i-1]`은 `"FizzBuzz"`,
- 3으로만 나누어떨어지면 `"Fizz"`,
- 5로만 나누어떨어지면 `"Buzz"`,
- 그 외에는 `i`의 십진 문자열 표현입니다.

**예시 1:**
```
입력: n = 3
출력: ["1","2","Fizz"]
```

**예시 2:**
```
입력: n = 5
출력: ["1","2","Fizz","4","Buzz"]
```

**예시 3:**
```
입력: n = 15
출력: ["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz"]
```$$,
 $$- `1 <= n <= 10^4`$$),

-- 7. palindrome-episode-number
((SELECT id FROM problems WHERE slug = 'palindrome-episode-number'), 'ko',
 $$뒤집어도 같은 에피소드 번호$$,
 $$정수 `code`가 주어지면, 앞에서 읽으나 뒤에서 읽으나 같은 수면 `true`, 아니면 `false`를 반환하세요. 음수인 `code`는 회문이 아닙니다 — 마이너스 부호는 오른쪽에 짝이 없기 때문입니다.

**예시 1:**
```
입력: code = 929
출력: true
설명: 929를 뒤집어도 그대로 929입니다.
```

**예시 2:**
```
입력: code = 20
출력: false
설명: 20을 뒤집으면 02가 되어 원래 값 20과 일치하지 않습니다.
```$$,
 $$- `-2 * 10^8 <= code <= 2 * 10^8`$$),

-- 8. decode-roman-floor
((SELECT id FROM problems WHERE slug = 'decode-roman-floor'), 'ko',
 $$던전 층수 해독하기$$,
 $$레트로 RPG는 던전 층 이름을 로마 숫자로 표시합니다. 층 표기를 정수 값으로 변환하세요.

기호별 값은 다음과 같습니다.

- `I` = 1, `V` = 5, `X` = 10, `L` = 50, `C` = 100, `D` = 500, `M` = 1000

기호는 왼쪽에서 오른쪽으로 큰 값에서 작은 값 순으로 읽습니다. 작은 기호가 더 큰 기호 바로 앞에 오면 그 쌍은 빼는 의미가 됩니다(즉 `IV` = 4, `IX` = 9). 빼기 쌍으로 허용되는 조합은 `IV`, `IX`, `XL`, `XC`, `CD`, `CM` 뿐입니다.

로마 숫자 문자열 `numeral`이 주어지면 그 정수 값을 반환하세요.

**예시 1:**
```
입력: numeral = "XIV"
출력: 14
설명: X + IV = 10 + 4 = 14 입니다.
```

**예시 2:**
```
입력: numeral = "CDXLII"
출력: 442
설명: CD + XL + II = 400 + 40 + 2 = 442 입니다.
```$$,
 $$- `1 <= numeral.length <= 15`
- `numeral`은 `I`, `V`, `X`, `L`, `C`, `D`, `M` 문자만 포함합니다
- `numeral`은 `[1, 3999]` 범위의 유효한 로마 숫자임이 보장됩니다$$),

-- 9. count-flag-bits
((SELECT id FROM problems WHERE slug = 'count-flag-bits'), 'ko',
 $$비트 플래그 개수 세기$$,
 $$레트로 게임에서 `0`부터 `upperId`까지 각 레벨에는 클리어 비트마스크가 있고, 각 레벨이 몇 개의 업적(켜진 비트)을 주는지 알고 싶습니다.

음이 아닌 정수 `upperId`가 주어지면, 길이가 `upperId + 1`인 배열 `flagCounts`를 반환하세요. 여기서 `flagCounts[i]`는 정수 `i`의 이진 표현에서 켜진 비트 개수입니다.

**예시 1:**
```
입력: upperId = 4
출력: [0,1,1,2,1]
설명: 0=0b0, 1=0b1, 2=0b10, 3=0b11, 4=0b100 이라 켜진 비트 수가 0,1,1,2,1 입니다.
```

**예시 2:**
```
입력: upperId = 7
출력: [0,1,1,2,1,2,2,3]
설명: 0부터 7까지의 이진 표현은 0, 1, 10, 11, 100, 101, 110, 111 입니다.
```$$,
 $$- `0 <= upperId <= 8 * 10^4`$$),

-- 10. reverse-savefile-flags
((SELECT id FROM problems WHERE slug = 'reverse-savefile-flags'), 'ko',
 $$세이브 파일 플래그 뒤집기$$,
 $$휴대용 콘솔이 세이브 파일 플래그를 PC 에뮬레이터와 정반대 비트 순서로 읽습니다. 그래서 비교하기 전에 32비트 상태 워드의 비트 순서를 뒤집어야 합니다.

32비트 부호 없는 정수 `statusWord`가 주어지면, 32비트를 모두 뒤집은 값을 반환하세요. 즉 0번 비트는 31번 자리로, 1번 비트는 30번 자리로 옮겨집니다. 결과는 `[0, 2^32 - 1]` 범위의 `long`으로 반환합니다.

**예시 1:**
```
입력: statusWord = 8
출력: 268435456
설명: 8은 3번 비트가 켜져 있습니다. 뒤집으면 그 비트가 28번 자리로 가서 2^28 = 268435456 이 됩니다.
```

**예시 2:**
```
입력: statusWord = 6
출력: 1610612736
설명: 6은 1번과 2번 비트가 켜져 있습니다. 뒤집으면 각각 30번, 29번 자리로 가서 2^30 + 2^29 = 1610612736 이 됩니다.
```$$,
 $$- `statusWord`는 32비트 부호 없는 정수입니다 (`0 <= statusWord <= 4294967295`)$$);
