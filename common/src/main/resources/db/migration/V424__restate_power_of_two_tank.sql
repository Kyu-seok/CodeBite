-- V424: power-of-two-tank restated, title unchanged. The brood-splitting story didn't fit
-- the zero and negative counts in the hidden cases, so it is cut to one line and the task
-- stated directly, including that zero and negatives are not powers of two. The constraint
-- `<= 2.1 * 10^9` was false for hidden case 7 (2147483647): now the 32-bit integer range.
-- Starter method isSoloSpecies -> isPowerOfTwo, parameter specimenCount -> n, in all 4
-- Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$A fish shop keeps a tank only when its fish count is a power of two.

Given an integer `n`, return `true` if `n` is a power of two, that is, `n == 2^k` for some integer `k >= 0` (`1`, `2`, `4`, `8`, ...), and `false` otherwise. Zero and negative numbers are not powers of two.

**Example 1:**
```
Input: n = 32
Output: true
Explanation: 32 = 2^5.
```

**Example 2:**
```
Input: n = 12
Output: false
Explanation: 12 lies between 2^3 = 8 and 2^4 = 16, so it is not a power of two.
```

**Example 3:**
```
Input: n = 6
Output: false
Explanation: 6 = 2 * 3 has an odd factor other than 1.
```$$,
    constraints = $$- `-2^31 <= n <= 2^31 - 1`$$
WHERE slug = $$power-of-two-tank$$;

UPDATE problem_translations SET
    description = $$어느 수족관 가게는 물고기 마릿수가 2의 거듭제곱일 때만 수조를 유지합니다.

정수 `n`이 주어질 때, `n`이 2의 거듭제곱이면, 즉 어떤 정수 `k >= 0`에 대해 `n == 2^k`이면(`1`, `2`, `4`, `8`, ...) `true`를, 아니면 `false`를 반환하세요. `0`과 음수는 2의 거듭제곱이 아닙니다.

**예시 1:**
```
입력: n = 32
출력: true
설명: 32 = 2^5 입니다.
```

**예시 2:**
```
입력: n = 12
출력: false
설명: 12는 2^3 = 8과 2^4 = 16 사이에 있으므로 2의 거듭제곱이 아닙니다.
```

**예시 3:**
```
입력: n = 6
출력: false
설명: 6 = 2 * 3으로, 1이 아닌 홀수 인수를 가집니다.
```$$,
    constraints = $$- `-2^31 <= n <= 2^31 - 1`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$power-of-two-tank$$);
