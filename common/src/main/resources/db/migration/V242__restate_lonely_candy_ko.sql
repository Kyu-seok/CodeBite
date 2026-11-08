-- V242: restate lonely-candy (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`frames.length <= 3 * 10^4` for `8 * 10^4`,
-- `|frames[i]| <= 3 * 10^4` for `10^8`), and never named `frames` in the last bullet; the
-- Korean bullets keep their prose and carry the English constraints' code spans exactly. Only
-- the Korean constraints change; Slug, title, description, English text, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= frames.length <= 8 * 10^4`
- `|frames[i]| <= 10^8`
- `frames`의 모든 값은 정확히 두 번씩 등장하며, 정확히 한 번만 등장하는 값이 하나 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lonely-candy$$);
