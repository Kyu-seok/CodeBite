-- V423: battery-drain-power -> fast-exponentiation, retitled "Fast Exponentiation". The
-- battery story contradicted the math (base 3 grows the battery; negative bases and hours mean
-- nothing), so it is dropped. Two constraints were false for hidden cases: case 13 has step
-- 2147483647 (above 2 * 10^8) and case 4 has 0^0, which "base is not zero or step > 0" ruled
-- out; both are loosened, and 0^0 = 1 is stated. Starter method raiseForecastFactor -> power,
-- parameter step -> exponent, in all 4 Starter Codes and Drivers, whose directories are
-- renamed in the same commit. Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$battery-drain-power$$, id FROM problems WHERE slug = $$battery-drain-power$$;

UPDATE problems SET
    slug = $$fast-exponentiation$$,
    title = $$Fast Exponentiation$$,
    description = $$Given a number `base` and an integer `exponent`, return `base` raised to the power `exponent`.

A negative `exponent` means `1 / base^|exponent|`, and any `base` raised to `0` is `1`, including `0^0`. Your answer is printed rounded to 5 decimal places. `|exponent|` can be above two billion, so multiplying `base` in a loop `|exponent|` times is too slow: use fast exponentiation (repeated squaring).

**Example 1:**
```
Input: base = 3.00000, exponent = 4
Output: 81.00000
Explanation: 3^4 = 3 * 3 * 3 * 3 = 81.
```

**Example 2:**
```
Input: base = 2.00000, exponent = -3
Output: 0.12500
Explanation: 2^-3 = 1 / 2^3 = 1/8 = 0.125.
```

**Example 3:**
```
Input: base = 2.00000, exponent = -2
Output: 0.25000
Explanation: 2^-2 = 1 / 2^2 = 1/4 = 0.25.
```$$,
    constraints = $$- `-100.0 < base < 100.0`
- `-2^31 <= exponent <= 2^31 - 1`
- `base != 0` or `exponent >= 0`
- `|base^exponent| <= 8 * 10^4`$$
WHERE slug = $$battery-drain-power$$;

UPDATE problem_translations SET
    title = $$빠른 거듭제곱$$,
    description = $$수 `base`와 정수 `exponent`가 주어질 때, `base`의 `exponent` 제곱을 반환하세요.

`exponent`가 음수면 `1 / base^|exponent|`를 뜻하고, 어떤 `base`든 `0` 제곱은 `1`입니다(`0^0`도 포함). 답은 소수점 다섯째 자리까지 반올림해 출력됩니다. `|exponent|`는 20억을 넘을 수 있으므로 반복문으로 `base`를 `|exponent|`번 곱하면 너무 느립니다. 빠른 거듭제곱(제곱을 반복하는 방법)을 사용하세요.

**예시 1:**
```
입력: base = 3.00000, exponent = 4
출력: 81.00000
설명: 3^4 = 3 * 3 * 3 * 3 = 81 입니다.
```

**예시 2:**
```
입력: base = 2.00000, exponent = -3
출력: 0.12500
설명: 2^-3 = 1 / 2^3 = 1/8 = 0.125 입니다.
```

**예시 3:**
```
입력: base = 2.00000, exponent = -2
출력: 0.25000
설명: 2^-2 = 1 / 2^2 = 1/4 = 0.25 입니다.
```$$,
    constraints = $$- `-100.0 < base < 100.0`
- `-2^31 <= exponent <= 2^31 - 1`
- `base != 0`이거나 `exponent >= 0`입니다.
- `|base^exponent| <= 8 * 10^4`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$fast-exponentiation$$);
