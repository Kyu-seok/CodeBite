-- V226: restate brawler-lane-collision (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`1 <= fighters.length <= 10^4` for `2
-- <= fighters.length <= 2 * 10^3`, `|fighters[i]| <= 1000` for `1200`); the Korean bullets
-- keep their prose and carry the English constraints' code spans exactly. Only the Korean
-- constraints change; Slug, title, description, English text, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `2 <= fighters.length <= 2 * 10^3`
- `-1200 <= fighters[i] <= 1200`
- `fighters[i] != 0`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$brawler-lane-collision$$);
