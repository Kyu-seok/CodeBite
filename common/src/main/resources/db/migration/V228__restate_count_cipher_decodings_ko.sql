-- V228: restate count-cipher-decodings (#192, part of #168). The Korean constraints set the
-- zero in `scan` in backticks, a code span the English have no counterpart for; the Korean
-- bullets keep their prose and carry the English constraints' code spans exactly. Only the
-- Korean constraints change; Slug, title, description, English text, Test Cases, Starter Code
-- and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= scan.length <= 120`
- `scan`은 십진 숫자로만 구성되며 선행 혹은 중간 0을 포함할 수 있습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-cipher-decodings$$);
