-- V239: restate flip-phone-codes (#192, part of #168). The Korean constraints wrote
-- `digits[i]` where the English name `digits`; the Korean bullets keep their prose and carry
-- the English constraints' code spans exactly. Only the Korean constraints change; Slug,
-- title, description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `0 <= digits.length <= 4`
- `digits`의 모든 문자는 `'2'`부터 `'9'`까지의 숫자입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-phone-codes$$);
