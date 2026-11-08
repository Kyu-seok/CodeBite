-- V222: restate word-search-ii (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`words.length <= 3 * 10^4` for `8 * 10^4`); the
-- Korean bullets keep their prose and carry the English constraints' code spans exactly. Only
-- the Korean constraints change; Slug, title, description, English text, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `m == board.length`
- `n == board[i].length`
- `1 <= m, n <= 12`
- `board[i][j]`는 영어 소문자입니다.
- `1 <= words.length <= 8 * 10^4`
- `1 <= words[i].length <= 10`
- `words[i]`는 영어 소문자로 이루어져 있습니다.
- `words`의 모든 문자열은 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$word-search-ii$$);
