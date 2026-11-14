-- V372: count-cipher-decodings, text restated. The statement spoke of cards and "groups"
-- it never defined, and Example 2 didn't say why "100" has no decoding. Starter method
-- countScanDecodings (num_decodings in Python) -> countDecodings, parameter scan ->
-- digits, the statement's words. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A cipher writes each letter as a number, `A` as `1` up to `Z` as `26`, and joins the numbers into one string of digits. Given such a string `digits`, return the number of ways to split it, left to right, into numbers from `1` to `26`.

Each number is written without a leading zero: a part such as `05`, `00` or a lone `0` is not allowed. If no split works, return `0`. The answer fits in a 32-bit signed integer.

**Example 1:**
```
Input: digits = "1234"
Output: 3
Explanation: The splits are 1,2,3,4 and 12,3,4 and 1,23,4. Any split with 34 fails, since 34 > 26.
```

**Example 2:**
```
Input: digits = "100"
Output: 0
Explanation: The first part is 1 or 10, since 100 > 26. After 10, a lone 0 is left. After 1, 00 is left, and neither 00 nor 0,0 is allowed.
```$$,
    constraints = $$- `1 <= digits.length <= 120`
- `digits` consists only of the characters `0` to `9`, and may start with `0`.$$
WHERE slug = $$count-cipher-decodings$$;

UPDATE problem_translations SET
    title = $$암호 해독 방법 세기$$,
    description = $$어떤 암호는 각 글자를 수로 적습니다. `A`는 `1`, …, `Z`는 `26`이며, 이 수들을 이어 붙여 숫자 문자열 하나를 만듭니다. 그런 문자열 `digits`가 주어질 때, 이를 왼쪽부터 `1`에서 `26` 사이의 수들로 나누는 방법의 개수를 반환하세요.

각 수는 앞에 0을 붙이지 않고 적습니다. 즉 `05`, `00` 같은 조각이나 `0` 하나만으로 된 조각은 허용되지 않습니다. 가능한 분할이 없으면 `0`을 반환합니다. 답은 32비트 부호 있는 정수 범위 안에 들어옵니다.

**예시 1:**
```
입력: digits = "1234"
출력: 3
설명: 가능한 분할은 1,2,3,4와 12,3,4와 1,23,4입니다. 34가 들어간 분할은 34 > 26이라 안 됩니다.
```

**예시 2:**
```
입력: digits = "100"
출력: 0
설명: 100 > 26이므로 첫 조각은 1 또는 10입니다. 10 뒤에는 0 하나가 남고, 1 뒤에는 00이 남는데 00도 0,0도 허용되지 않습니다.
```$$,
    constraints = $$- `1 <= digits.length <= 120`
- `digits`는 `0`부터 `9`까지의 문자로만 이루어지며, `0`으로 시작할 수도 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-cipher-decodings$$);
