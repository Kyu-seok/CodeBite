-- V248: restate merge-reservation-slots (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`seatings.length <= 10^4` for `2 *
-- 10^5`, `end_i <= 10^4` for `10^8`); the Korean bullets keep their prose and carry the
-- English constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= seatings.length <= 2 * 10^5`
- `seatings[i].length == 2`
- `0 <= start_i <= end_i <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merge-reservation-slots$$);
