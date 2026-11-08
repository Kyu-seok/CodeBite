-- V216: restate longest-palindromic-substring (#177, part of #168). The English constraints named
-- `word` -> `s`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= s.length <= 1200`
- `s` consists of only lowercase English letters.$$
WHERE slug = $$longest-palindromic-substring$$;
