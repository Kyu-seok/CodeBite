-- V462: list-bracket-pairings restated, title unchanged. Starter method listSlateSequences
-- ("slate", left over from an earlier theme) -> listBracketPairings in all 4 Starter Codes and
-- Drivers. The Korean definition of well-formed was garbled ("no ) before (") and now says no
-- ) comes before its matching (; both examples are explained. Examples match the sample test
-- cases, which are unchanged.

UPDATE problems SET
    description = $$Given an integer `pairCount`, return every well-formed string built from `pairCount` pairs of brackets `(` and `)`.

A string is well-formed when its brackets can be matched in pairs, each `(` with a `)` that comes after it. Equivalently, reading from left to right, the number of `)` seen never exceeds the number of `(` seen, and the two counts are equal at the end.

Return the strings in any order: the grader sorts them before comparing.

**Example 1:**
```
Input: pairCount = 2
Output: ["(())","()()"]
Explanation: Two pairs either nest, (()), or sit side by side, ()().
```

**Example 2:**
```
Input: pairCount = 4
Output: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
Explanation: Four pairs make 14 well-formed strings. A string such as ())(() is not one of them: its third bracket ) has no ( left to match.
```$$
WHERE slug = $$list-bracket-pairings$$;

UPDATE problem_translations SET
    description = $$정수 `pairCount`가 주어질 때, 괄호 `(`와 `)` `pairCount`쌍으로 만들 수 있는 올바른 문자열을 모두 반환하세요.

괄호를 둘씩 짝지을 수 있고, 각 `(`의 짝인 `)`가 그 `(`보다 뒤에 있으면 올바른 문자열입니다. 다시 말해 왼쪽부터 읽을 때 지금까지 나온 `)`의 개수가 `(`의 개수를 넘는 순간이 없고, 끝에서 두 개수가 같아야 합니다.

문자열은 어떤 순서로 반환해도 됩니다. 채점기가 비교 전에 정렬합니다.

**예시 1:**
```
입력: pairCount = 2
출력: ["(())","()()"]
설명: 두 쌍은 (())처럼 겹치거나 ()()처럼 나란히 놓입니다.
```

**예시 2:**
```
입력: pairCount = 4
출력: ["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]
설명: 네 쌍으로는 올바른 문자열 14개를 만들 수 있습니다. ())(()는 여기에 들지 않습니다. 세 번째 괄호 )와 짝지을 (가 남아 있지 않기 때문입니다.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$list-bracket-pairings$$);
