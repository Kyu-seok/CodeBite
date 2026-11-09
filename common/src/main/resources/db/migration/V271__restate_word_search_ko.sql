-- V271: restate word-search (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`m, n <= 6` for `8`, `word.length <= 15` for
-- `20`); the Korean bullets keep their prose and carry the English constraints' code spans
-- exactly. Only the Korean constraints change; Slug, title, description, English text, Test
-- Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 8`
- `1 <= word.length <= 20`
- `board`와 `word`는 영어 대소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search$$);
