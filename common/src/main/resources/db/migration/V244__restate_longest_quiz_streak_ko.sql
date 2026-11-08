-- V244: restate longest-quiz-streak (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`scores.length <= 2500` for `2 *
-- 10^3`, `|scores[i]| <= 10^4` for `5000`); the Korean bullets keep their prose and carry the
-- English constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= scores.length <= 2 * 10^3`
- `-5000 <= scores[i] <= 5000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-quiz-streak$$);
