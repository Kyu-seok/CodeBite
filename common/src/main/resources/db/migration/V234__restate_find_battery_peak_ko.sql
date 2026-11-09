-- V234: restate find-battery-peak (#192, part of #168). The Korean constraints put `i` before
-- `readings[i] != readings[i + 1]`, so the two languages' code spans ran in different orders;
-- the Korean bullets keep their prose and carry the English constraints' code spans exactly.
-- Only the Korean constraints change; Slug, title, description, English text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= readings.length <= 2 * 10^3`
- `|readings[i]| <= 10^8`
- `readings[i] != readings[i + 1]` (모든 유효한 `i`에 대해)$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$find-battery-peak$$);
