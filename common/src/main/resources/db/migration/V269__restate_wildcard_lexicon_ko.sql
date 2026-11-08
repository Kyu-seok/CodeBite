-- V269: restate wildcard-lexicon (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`10^4` calls for `8000`), and put each method
-- before its `word` and the methods before the call limit, so the two languages' code spans
-- ran in different orders; the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= word.length <= 25`
- `word`는 `enroll`에서 영어 소문자로만 이루어져 있습니다.
- `word`는 `match`에서 영어 소문자와/또는 와일드카드 문자 `.`로 이루어져 있습니다.
- 합쳐서 최대 `8000`번까지 `enroll`과 `match`가 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$wildcard-lexicon$$);
