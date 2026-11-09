-- V255: restate queue-from-stacks (#192, part of #168). The Korean constraints listed the
-- methods before their combined call limit, so the two languages' code spans ran in different
-- orders; the Korean bullets keep their prose and carry the English constraints' code spans
-- exactly. Only the Korean constraints change; Slug, title, description, English text, Test
-- Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= x <= 9`
- 합쳐서 최대 `100`번까지 `push`, `pop`, `peek`, `empty`가 호출됩니다.
- `pop`과 `peek`은 큐가 비어 있지 않을 때만 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$queue-from-stacks$$);
