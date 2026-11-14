-- V373: count-doodle-palindromes, text restated. The statement coined "mirror span" for the
-- palindromic substring the title names, and the Korean title dropped "palindrome". Starter
-- method countMirrorSpans (count_substrings in Python) -> countPalindromicSubstrings,
-- parameter code -> doodle, the statement's words. Examples match the sample test cases,
-- which are unchanged.

UPDATE problems SET
    description = $$You doodle a string of letters, `doodle`. Return the number of **palindromic substrings** in `doodle`: contiguous substrings that read the same forwards and backwards.

Every single letter is a palindrome. Substrings at different positions count separately, even when their letters are the same.

**Example 1:**
```
Input: doodle = "klmn"
Output: 4
Explanation: All four letters differ, so only the 4 single letters are palindromes.
```

**Example 2:**
```
Input: doodle = "rrrr"
Output: 10
Explanation: Every substring of "rrrr" is a palindrome: 4 of length 1, 3 of length 2, 2 of length 3 and 1 of length 4, so 4 + 3 + 2 + 1 = 10.
```$$,
    constraints = $$- `1 <= doodle.length <= 1500`
- `doodle` consists of lowercase English letters.$$
WHERE slug = $$count-doodle-palindromes$$;

UPDATE problem_translations SET
    title = $$낙서 회문 세기$$,
    description = $$글자를 끄적여 만든 문자열 `doodle`이 있습니다. `doodle`에 들어 있는 **회문 부분 문자열**, 즉 앞에서 읽어도 뒤에서 읽어도 같은 연속 부분 문자열의 개수를 반환하세요.

한 글자짜리도 모두 회문입니다. 위치가 다른 부분 문자열은 글자가 같아도 따로 셉니다.

**예시 1:**
```
입력: doodle = "klmn"
출력: 4
설명: 네 글자가 모두 다르므로 한 글자짜리 4개만 회문입니다.
```

**예시 2:**
```
입력: doodle = "rrrr"
출력: 10
설명: "rrrr"의 부분 문자열은 모두 회문입니다. 길이 1이 4개, 길이 2가 3개, 길이 3이 2개, 길이 4가 1개로 4 + 3 + 2 + 1 = 10입니다.
```$$,
    constraints = $$- `1 <= doodle.length <= 1500`
- `doodle`은 영어 소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-doodle-palindromes$$);
