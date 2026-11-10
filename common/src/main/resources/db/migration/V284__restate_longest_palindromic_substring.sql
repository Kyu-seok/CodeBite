-- V284: restate longest-palindromic-substring (#216, part of #193). The Examples showed
-- LeetCode's data ("babad", "cbbd", "a"), which is no sample Test Case; they now show
-- samples 1, 2 and 3 ("levelled", "barrel", "q"), with the explanations rewritten for
-- the new data. Slug, title, constraints, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problems SET
    description = $$Given a string `s`, return the **length** of the longest palindromic substring of `s`. A palindromic substring reads the same forward and backward.

**Example 1:**
```
Input: s = "levelled"
Output: 5
Explanation: "level" is a palindromic substring of length 5. "elle" is one too, but it has length 4, and no palindromic substring is longer than 5.
```

**Example 2:**
```
Input: s = "barrel"
Output: 2
Explanation: "rr" has length 2; no longer palindromic substring exists.
```

**Example 3:**
```
Input: s = "q"
Output: 1
Explanation: A single character is always a palindrome.
```$$
WHERE slug = $$longest-palindromic-substring$$;

UPDATE problem_translations SET
    description = $$문자열 `s`가 주어졌을 때, `s`의 가장 긴 회문 부분 문자열의 **길이**를 반환하세요. 회문 부분 문자열이란 앞에서 읽으나 뒤에서 읽으나 같은 부분 문자열을 말합니다.

**예시 1:**
```
입력: s = "levelled"
출력: 5
설명: "level"은 길이 5인 회문 부분 문자열입니다. "elle"도 회문이지만 길이가 4이고, 길이가 5보다 긴 회문 부분 문자열은 없습니다.
```

**예시 2:**
```
입력: s = "barrel"
출력: 2
설명: "rr"의 길이는 2이고, 그보다 긴 회문 부분 문자열은 존재하지 않습니다.
```

**예시 3:**
```
입력: s = "q"
출력: 1
설명: 글자 하나는 항상 회문입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-palindromic-substring$$);
