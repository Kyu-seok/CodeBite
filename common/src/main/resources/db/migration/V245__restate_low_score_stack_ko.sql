-- V245: restate low-score-stack (#192, part of #168). The Korean constraints listed the
-- methods before their combined call limit, so the two languages' code spans ran in different
-- orders, and set `push` in backticks where the English say pushed; the Korean bullets keep
-- their prose and carry the English constraints' code spans exactly. Only the Korean
-- constraints change; Slug, title, description, English text, Test Cases, Starter Code and
-- Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `-10^8 <= val <= 10^8`
- `pop`, `top`, `getMin`은 원소가 적어도 하나 push된 후에만 호출됩니다.
- 합쳐서 최대 `20000`번까지 `push`, `pop`, `top`, `getMin`이 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$low-score-stack$$);
