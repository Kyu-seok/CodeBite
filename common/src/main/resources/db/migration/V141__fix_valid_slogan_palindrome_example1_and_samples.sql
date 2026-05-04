-- V141: Fix valid-slogan-palindrome description Example 1 (which was not
-- actually a palindrome) and sync the three sample test_cases rows so each
-- description Example N matches order_index N.
--
-- V135's Example 1 used phrase = "Stacks: Level 2 level stack S", which
-- filters to "stackslevel2levelstacks". At position pair (1, 21) the chars
-- are 't' vs 'k', so the string is NOT a palindrome — the stated
-- Output: true was wrong. Replace Example 1 with "Step on no pets", which
-- filters to "steponnopets" (verified palindrome on every pair).
--
-- V137/V138 (the description-sample sync pass) missed this slug, so the
-- three is_sample=TRUE rows still held the original LC-verbatim
-- ("A man, a plan, a canal: Panama" / "race a car" / " ") values from V24.
-- Update them so each example matches the corresponding sample row.
--
-- The Korean translation in V136 mirrored the same wrong Example 1, so it
-- gets the same fix here.

-- English description
UPDATE problems SET
    description = $$Given a bumper-sticker slogan `phrase`, lowercase all letters and drop every non-alphanumeric character. Return `true` if the result reads the same forwards and backwards, else `false`. An empty string counts as a palindrome.

**Example 1:**
```
Input: phrase = "Step on no pets"
Output: true
Explanation: After filtering, the phrase becomes "steponnopets", which mirrors itself.
```

**Example 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**Example 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$$
WHERE slug = 'valid-slogan-palindrome';

-- Korean translation
UPDATE problem_translations SET
    description = $$범퍼 스티커 슬로건 `phrase`가 주어집니다. 알파벳을 모두 소문자로 바꾸고 알파벳·숫자가 아닌 문자를 전부 제거했을 때, 남은 문자열이 앞에서 읽어도 뒤에서 읽어도 똑같으면 `true`, 아니면 `false`를 반환하세요. 빈 문자열도 회문으로 간주합니다.

**예시 1:**
```
Input: phrase = "Step on no pets"
Output: true
Explanation: After filtering, the phrase becomes "steponnopets", which mirrors itself.
```

**예시 2:**
```
Input: phrase = "Shelf 7A not mirrored"
Output: false
Explanation: After filtering the phrase becomes "shelf7anotmirrored", which is not a mirror.
```

**예시 3:**
```
Input: phrase = ",,,"
Output: true
Explanation: After removing non-alphanumeric characters the phrase is empty, which counts as a mirror.
```$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = 'valid-slogan-palindrome');

-- Sample test cases (is_sample = TRUE) — sync to description examples
UPDATE test_cases SET
    input = 'Step on no pets',
    expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-slogan-palindrome')
  AND is_sample = TRUE
  AND order_index = 1;

UPDATE test_cases SET
    input = 'Shelf 7A not mirrored',
    expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-slogan-palindrome')
  AND is_sample = TRUE
  AND order_index = 2;

UPDATE test_cases SET
    input = ',,,',
    expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-slogan-palindrome')
  AND is_sample = TRUE
  AND order_index = 3;
