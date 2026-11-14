-- V354: eval-postfix-tape restated, title unchanged. The Starter names baleTape and
-- foldBaleOps meant nothing here, and the operand order of - and / was only implied: the
-- statement now says the number pushed earlier is the left operand. Starter method
-- foldBaleOps -> evalPostfix, parameter baleTape -> tokens, in all 4 Starter Codes and
-- Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$`tokens` is an arithmetic expression from the teacher's board, written in postfix order: each token is an integer or one of the operators `+`, `-`, `*`, `/`. Evaluate it and return the result.

Read the tokens left to right with a stack. Push each number. For an operator, pop the top number `b`, then the number under it `a`, and push `a op b`: the number pushed earlier is the left operand, so `["5","3","-"]` is `5 - 3 = 2`. Division truncates toward zero.

The expression is valid: it leaves exactly one number on the stack, and never divides by zero.

**Example 1:**
```
Input: tokens = ["5","3","-","2","*"]
Output: 4
Explanation: 5 - 3 = 2, then 2 * 2 = 4.
```

**Example 2:**
```
Input: tokens = ["8","2","/","7","+","3","*"]
Output: 33
Explanation: 8 / 2 = 4, then 4 + 7 = 11, then 11 * 3 = 33.
```$$,
    constraints = $$- `1 <= tokens.length <= 2 * 10^3`
- `tokens[i]` is an operator in `{"+", "-", "*", "/"}` or an integer with `|tokens[i]| <= 250`.
- The result and every intermediate value fit in a 32-bit signed integer.$$
WHERE slug = $$eval-postfix-tape$$;

UPDATE problem_translations SET
    description = $$`tokens`는 선생님이 칠판에 적은 산술식을 후위 표기 순서로 담고 있습니다. 각 토큰은 정수이거나 연산자 `+`, `-`, `*`, `/` 중 하나입니다. 식을 계산해 결과를 반환하세요.

토큰을 왼쪽부터 읽으며 스택을 씁니다. 수는 스택에 넣습니다. 연산자를 만나면 맨 위의 수 `b`를 꺼내고, 그 아래 수 `a`를 꺼낸 뒤 `a op b`를 넣습니다. 먼저 넣은 수가 왼쪽 피연산자이므로 `["5","3","-"]`는 `5 - 3 = 2`입니다. 나눗셈은 0 쪽으로 버림합니다.

식은 올바르게 주어집니다. 계산을 마치면 스택에 수가 정확히 하나 남고, 0으로 나누는 경우는 없습니다.

**예시 1:**
```
입력: tokens = ["5","3","-","2","*"]
출력: 4
설명: 5 - 3 = 2, 그다음 2 * 2 = 4입니다.
```

**예시 2:**
```
입력: tokens = ["8","2","/","7","+","3","*"]
출력: 33
설명: 8 / 2 = 4, 4 + 7 = 11, 11 * 3 = 33입니다.
```$$,
    constraints = $$- `1 <= tokens.length <= 2 * 10^3`
- `tokens[i]`는 `{"+", "-", "*", "/"}` 중 하나의 연산자이거나 `|tokens[i]| <= 250`인 정수입니다.
- 결과와 계산 중의 모든 값은 32비트 부호 있는 정수 범위에 들어갑니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$eval-postfix-tape$$);
