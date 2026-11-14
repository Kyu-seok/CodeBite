-- V374: desk-notes-overlap, text restated. "The longest stretch of letters" read as a
-- contiguous run, against the subsequence the cases count, and the "subject codes" had to be
-- translated back to letters. Starter method shelfOverlapLength -> longestCommonSubsequence,
-- the Python name. Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Return the length of the **longest common subsequence** of the strings `left` and `right`: your class notes and your desk-mate's.

A **subsequence** of a string is what remains after deleting any number of its letters, keeping the rest in their order: `"ace"` is a subsequence of `"abcde"`, but `"aec"` is not. A common subsequence is a subsequence of both strings. If the strings share no letter, return `0`.

**Example 1:**
```
Input: left = "history", right = "mystery"
Output: 4
Explanation: "stry" is a subsequence of both, and no common subsequence is longer.
```

**Example 2:**
```
Input: left = "ocean", right = "canoe"
Output: 3
Explanation: "can" is a subsequence of both: its letters sit at indices 1, 3 and 4 of left and 0, 1 and 2 of right.
```$$,
    constraints = $$- `1 <= left.length, right.length <= 1000`
- `left` and `right` consist of lowercase English letters.$$
WHERE slug = $$desk-notes-overlap$$;

UPDATE problem_translations SET
    description = $$나와 짝꿍의 수업 필기인 두 문자열 `left`와 `right`의 **가장 긴 공통 부분수열**의 길이를 반환하세요.

문자열의 **부분수열**이란 글자를 몇 개(0개도 가능) 지우고 남은 글자를 원래 순서대로 둔 문자열입니다. 예를 들어 `"ace"`는 `"abcde"`의 부분수열이지만 `"aec"`는 아닙니다. 공통 부분수열은 두 문자열 모두의 부분수열입니다. 두 문자열에 같은 글자가 하나도 없으면 `0`을 반환합니다.

**예시 1:**
```
입력: left = "history", right = "mystery"
출력: 4
설명: "stry"는 두 문자열 모두의 부분수열이며, 이보다 긴 공통 부분수열은 없습니다.
```

**예시 2:**
```
입력: left = "ocean", right = "canoe"
출력: 3
설명: "can"은 두 문자열 모두의 부분수열입니다. 그 글자들은 left의 인덱스 1, 3, 4와 right의 인덱스 0, 1, 2에 있습니다.
```$$,
    constraints = $$- `1 <= left.length, right.length <= 1000`
- `left`와 `right`는 영어 소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$desk-notes-overlap$$);
