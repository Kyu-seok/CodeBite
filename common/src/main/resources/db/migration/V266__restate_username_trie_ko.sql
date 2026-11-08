-- V266: restate username-trie (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`3 * 10^4` calls for `20000`), and the Korean
-- constraints listed the methods before their combined call limit, so the two languages' code
-- spans ran in different orders; the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= word.length, prefix.length <= 2000`
- `word`와 `prefix`는 영어 소문자로만 이루어져 있습니다.
- 합쳐서 최대 `20000`번까지 `insert`, `search`, `startsWith`가 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$username-trie$$);
