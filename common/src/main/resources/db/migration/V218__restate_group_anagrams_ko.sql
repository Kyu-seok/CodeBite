-- V218: restate group-anagrams (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`strs.length <= 10^4` for `8 * 10^3`); the Korean
-- bullets keep their prose and carry the English constraints' code spans exactly. Only the
-- Korean constraints change; Slug, title, description, English text, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= strs.length <= 8 * 10^3`
- `0 <= strs[i].length <= 100`
- `strs[i]`는 영어 소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$group-anagrams$$);
