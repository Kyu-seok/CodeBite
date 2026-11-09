-- V258: restate running-median-timer (#192, part of #168). The Korean constraints listed the
-- methods before their combined call limit, so the two languages' code spans ran in different
-- orders; the Korean bullets keep their prose and carry the English constraints' code spans
-- exactly. Only the Korean constraints change; Slug, title, description, English text, Test
-- Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `-80000 <= num <= 80000`
- 합쳐서 최대 `40000`번까지 `record`와 `median`이 호출됩니다.
- `median`은 첫 번째 `record` 이전에는 호출되지 않습니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$running-median-timer$$);
