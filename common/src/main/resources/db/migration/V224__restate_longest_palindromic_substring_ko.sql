-- V224: restate longest-palindromic-substring (#192, part of #168). The Korean constraints
-- kept LeetCode's bounds where the English state CodeBite's (`s.length <= 1000` for `1200`);
-- the Korean bullets keep their prose and carry the English constraints' code spans exactly.
-- Only the Korean constraints change; Slug, title, description, English text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= s.length <= 1200`
- `s`는 영어 소문자로만 이루어져 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-palindromic-substring$$);
