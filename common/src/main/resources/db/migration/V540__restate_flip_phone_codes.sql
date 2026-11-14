-- V540: flip-phone-codes restated, title unchanged. The statement named mapKeypadCodes
-- while the Python Starter Code had letter_combinations; both become letterCombinations,
-- the words the statement uses for the result. The task now comes first and Example 1's
-- explanation no longer talks of "slots".
-- Starter method mapKeypadCodes / letter_combinations -> letterCombinations in all 4
-- Starter Codes and Drivers. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given a string `digits` of keys `2` to `9` pressed on an old flip phone, return every letter combination the keys could spell. Each key stands for several letters:

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

A combination takes one letter for each digit, in the order of the digits. Return the combinations in any order, and an empty list when `digits` is empty.

**Example 1:**
```
Input: digits = "45"
Output: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
Explanation: 4 stands for "ghi" and 5 for "jkl"; each of the 3 letters of 4 pairs with each of the 3 letters of 5, giving 9 combinations.
```

**Example 2:**
```
Input: digits = "2"
Output: ["a","b","c"]
Explanation: One digit gives one combination per letter it stands for.
```$$,
    constraints = $$- `0 <= digits.length <= 4`
- Every character of `digits` is a digit from `'2'` to `'9'`.$$
WHERE slug = $$flip-phone-codes$$;

UPDATE problem_translations SET
    description = $$옛날 폴더폰에서 누른 `2`~`9` 키를 나타내는 문자열 `digits`가 주어질 때, 그 키들로 만들 수 있는 모든 글자 조합을 반환하세요. 각 키는 여러 글자를 나타냅니다.

- `2`: `abc`
- `3`: `def`
- `4`: `ghi`
- `5`: `jkl`
- `6`: `mno`
- `7`: `pqrs`
- `8`: `tuv`
- `9`: `wxyz`

조합 하나는 각 숫자마다 글자를 하나씩, 숫자의 순서대로 골라 만듭니다. 조합의 순서는 상관없으며, `digits`가 비어 있으면 빈 리스트를 반환합니다.

**예시 1:**
```
입력: digits = "45"
출력: ["gj","gk","gl","hj","hk","hl","ij","ik","il"]
설명: 4는 "ghi", 5는 "jkl"을 나타냅니다. 4의 글자 3개가 각각 5의 글자 3개와 짝을 이루어 조합은 9개입니다.
```

**예시 2:**
```
입력: digits = "2"
출력: ["a","b","c"]
설명: 숫자가 하나면 그 숫자가 나타내는 글자마다 조합이 하나씩 나옵니다.
```$$,
    constraints = $$- `0 <= digits.length <= 4`
- `digits`의 모든 문자는 `'2'`부터 `'9'`까지의 숫자입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-phone-codes$$);
