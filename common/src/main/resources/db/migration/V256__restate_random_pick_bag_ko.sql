-- V256: restate random-pick-bag (#192, part of #168). The Korean constraints listed the
-- methods before their combined call limit, so the two languages' code spans ran in different
-- orders; the Korean bullets keep their prose and carry the English constraints' code spans
-- exactly. Only the Korean constraints change; Slug, title, description, English text, Test
-- Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `-10^8 <= val <= 10^8`
- 합쳐서 최대 `2 * 10^5`번까지 `insert`, `remove`, `drawRandom`이 호출됩니다.
- `drawRandom`은 가방이 비어 있지 않을 때만 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$random-pick-bag$$);
