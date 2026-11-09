-- V235: restate find-menu-calorie (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`m, n <= 300` for `250`, `|menu[i][j]|` and
-- `|target|` within `10^9` for `10^8`); the Korean bullets keep their prose and carry the
-- English constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `m == menu.length`
- `n == menu[i].length`
- `1 <= m, n <= 250`
- `|menu[i][j]| <= 10^8`
- 각 행은 왼쪽에서 오른쪽으로 오름차순으로 정렬되어 있습니다.
- 각 열은 위에서 아래로 오름차순으로 정렬되어 있습니다.
- `|target| <= 10^8`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-menu-calorie$$);
