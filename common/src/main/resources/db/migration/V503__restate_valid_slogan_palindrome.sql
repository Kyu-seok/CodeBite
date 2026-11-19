-- V503: valid-slogan-palindrome restated, title unchanged. The explanations said "mirrors
-- itself" and "counts as a mirror"; they now say palindrome throughout, and the task comes
-- first. The constraint names the ASCII codes. Starter method verifyMirrorCode -> isPalindrome
-- in all 4 Starter Codes and Drivers. Examples match the sample test cases, which are
-- unchanged.

UPDATE problems SET
    description = $$Given a slogan `phrase`, return `true` if it is a palindrome once cleaned up, and `false` otherwise.

To clean it up, lowercase every letter and remove every character that is not a letter or a digit. A palindrome reads the same forwards and backwards; an empty string counts as one.

**Example 1:**
```
Input: phrase = "Step on no pets"
Output: true
Explanation: Cleaned up, the phrase is "steponnopets", which reads the same backwards, so it is a palindrome.
```

**Example 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: Cleaned up, the phrase is "shelf7anotmirrored", which reads "derorrimtona7flehs" backwards, so it is not a palindrome.
```

**Example 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: Cleaned up, the phrase is empty, and an empty string is a palindrome.
```$$,
    constraints = $$- `1 <= phrase.length <= 2 * 10^5`
- `phrase` consists only of printable ASCII characters (codes 32 to 126).$$
WHERE slug = $$valid-slogan-palindrome$$;

UPDATE problem_translations SET
    description = $$슬로건 문자열 `phrase`가 주어집니다. 정리한 결과가 회문이면 `true`, 아니면 `false`를 반환하세요.

정리할 때는 알파벳을 모두 소문자로 바꾸고, 알파벳이나 숫자가 아닌 문자를 전부 제거합니다. 회문은 앞에서 읽어도 뒤에서 읽어도 똑같은 문자열이며, 빈 문자열도 회문으로 봅니다.

**예시 1:**
```
입력: phrase = "Step on no pets"
출력: true
설명: 정리하면 "steponnopets"가 되고, 뒤에서 읽어도 같으므로 회문입니다.
```

**예시 2:**
```
입력: phrase = "Shelf 7A not mirrored"
출력: false
설명: 정리하면 "shelf7anotmirrored"가 되고, 뒤에서 읽으면 "derorrimtona7flehs"이므로 회문이 아닙니다.
```

**예시 3:**
```
입력: phrase = ",,,"
출력: true
설명: 정리하면 빈 문자열이 남고, 빈 문자열은 회문입니다.
```$$,
    constraints = $$- `1 <= phrase.length <= 2 * 10^5`
- `phrase`는 출력 가능한 ASCII 문자(코드 32 ~ 126)로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$valid-slogan-palindrome$$);
