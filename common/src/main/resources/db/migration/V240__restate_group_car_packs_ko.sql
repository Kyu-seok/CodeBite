-- V240: restate group-car-packs (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`position.length <= 10^5` for `2 * 10^5`, `target
-- <= 10^6` for `10^8`, `speed[i] <= 10^6` for `2 * 10^5`), in LeetCode's bullets; the Korean
-- bullets keep their prose and carry the English constraints' code spans exactly. Only the
-- Korean constraints change; Slug, title, description, English text, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `n == position.length == speed.length`
- `1 <= n <= 2 * 10^5`
- `0 <= position[i] < target <= 10^8`
- `1 <= speed[i] <= 2 * 10^5`
- `position`의 모든 값은 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-car-packs$$);
