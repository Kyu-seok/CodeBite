-- V260: restate sort-latte-squared (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`|drifts[i]| <= 10^4` for `8 * 10^3`);
-- the Korean bullets keep their prose and carry the English constraints' code spans exactly.
-- Only the Korean constraints change; Slug, title, description, English text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= drifts.length <= 2 * 10^5`
- `-8 * 10^3 <= drifts[i] <= 8 * 10^3`
- `drifts`는 비내림차순으로 정렬되어 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$sort-latte-squared$$);
