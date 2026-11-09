-- V249: restate merged-price-median (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`m, n <= 1000` for `1500`, `m + n <=
-- 2000` for `3000`, `|zonesA[i]| <= 10^6` for `10^7`), in LeetCode's bullets; the Korean
-- bullets keep their prose and carry the English constraints' code spans exactly. Only the
-- Korean constraints change; Slug, title, description, English text, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `0 <= zonesA.length, zonesB.length <= 1500`
- `1 <= zonesA.length + zonesB.length <= 3000`
- `|zonesA[i]|, |zonesB[i]| <= 10^7`
- 두 리스트 모두 비내림차순으로 정렬되어 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$merged-price-median$$);
