-- V309: longest-combo-run -> longest-same-letter-run, retitled "Longest Same-Letter Run".
-- The rhythm-game framing (button hits, combos) had nothing to do with the task, so the
-- statement now says it directly: replace up to k letters to make the longest run of one
-- letter. The method shiftLetters becomes longestSameLetterRun and the parameter code
-- becomes s. Drivers and Starter Code directories are renamed in the same commit.
-- Examples match the sample test cases, which are unchanged.

INSERT INTO problem_former_slugs (slug, problem_id)
SELECT $$longest-combo-run$$, id FROM problems WHERE slug = $$longest-combo-run$$;

UPDATE problems SET
    slug = $$longest-same-letter-run$$,
    title = $$Longest Same-Letter Run$$,
    description = $$You are given a string `s` of uppercase English letters and an integer `k`. You may replace at most `k` characters of `s`, each with any uppercase letter.

Return the length of the longest substring that consists of a single repeated letter after the replacements.

**Example 1:**
```
Input: s = "PQPQ", k = 2
Output: 4
Explanation: Replace both P's with Q to get "QQQQ", a run of length 4.
```

**Example 2:**
```
Input: s = "XXYXYYX", k = 1
Output: 4
Explanation: Replace the Y at index 2 with X; indices 0..3 become "XXXX", a run of length 4.
```$$,
    constraints = $$- `1 <= s.length <= 2 * 10^5`
- `s` consists of only uppercase English letters.
- `0 <= k <= s.length`$$
WHERE slug = $$longest-combo-run$$;

UPDATE problem_translations SET
    title = $$같은 글자 최장 구간$$,
    description = $$영어 대문자로 이루어진 문자열 `s`와 정수 `k`가 주어집니다. `s`의 문자를 최대 `k`개까지 골라 각각 원하는 대문자로 바꿀 수 있습니다.

바꾼 뒤 한 글자만 반복되는 부분 문자열 중 가장 긴 것의 길이를 반환하세요.

**예시 1:**
```
입력: s = "PQPQ", k = 2
출력: 4
설명: 두 P를 모두 Q로 바꾸면 "QQQQ"가 되어 길이 4인 구간이 만들어집니다.
```

**예시 2:**
```
입력: s = "XXYXYYX", k = 1
출력: 4
설명: 인덱스 2의 Y를 X로 바꾸면 인덱스 0..3이 "XXXX"가 되어 길이 4인 구간이 만들어집니다.
```$$,
    constraints = $$- `1 <= s.length <= 2 * 10^5`
- `s`는 영어 대문자로만 이루어져 있습니다.
- `0 <= k <= s.length`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-same-letter-run$$);
