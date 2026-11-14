-- V580: palindrome-episode-number restated, title and Slug unchanged. The title's
-- episode number never appeared in the statement, which read an integer `code`; the
-- statement now reads it as an episode number. Starter method isReversibleCode ->
-- isPalindrome and parameter code -> episode in all 4 Starter Codes and Drivers.
-- Examples match the sample test cases, which are unchanged.

UPDATE problems SET
    description = $$Given an episode number `episode`, return `true` if it is a palindrome, reading the same forwards and backwards, and `false` otherwise.

A negative number is never a palindrome, since its minus sign has no matching character on the right.

**Example 1:**
```
Input: episode = 929
Output: true
Explanation: 929 reversed is still 929.
```

**Example 2:**
```
Input: episode = 20
Output: false
Explanation: 20 reversed reads 02, which does not match 20.
```$$,
    constraints = $$- `-2 * 10^8 <= episode <= 2 * 10^8`$$
WHERE slug = $$palindrome-episode-number$$;

UPDATE problem_translations SET
    description = $$에피소드 번호 `episode`가 주어질 때, 앞에서 읽으나 뒤에서 읽으나 같은 회문이면 `true`, 아니면 `false`를 반환하세요.

음수는 회문이 아닙니다. 마이너스 부호는 오른쪽에 짝이 되는 문자가 없기 때문입니다.

**예시 1:**
```
입력: episode = 929
출력: true
설명: 929를 뒤집어도 그대로 929입니다.
```

**예시 2:**
```
입력: episode = 20
출력: false
설명: 20을 뒤집으면 02가 되어 원래 값 20과 일치하지 않습니다.
```$$,
    constraints = $$- `-2 * 10^8 <= episode <= 2 * 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$palindrome-episode-number$$);
