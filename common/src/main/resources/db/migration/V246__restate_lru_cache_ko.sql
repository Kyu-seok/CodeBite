-- V246: restate lru-cache (#192, part of #168). The Korean constraints kept LeetCode's bounds
-- where the English state CodeBite's (`key <= 10^4` for `8000`, `value <= 10^5` for `80000`)
-- and LeetCode's method names `get` and `put` for `lookup` and `store`; the Korean bullets
-- keep their prose and carry the English constraints' code spans exactly. Only the Korean
-- constraints change; Slug, title, description, English text, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- 합쳐서 최대 `2 * 10^5`번까지 `lookup`과 `store`가 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);
