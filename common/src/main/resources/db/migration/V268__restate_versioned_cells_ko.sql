-- V268: restate versioned-cells (#192, part of #168). The Korean constraints listed the
-- methods before their combined call limit, so the two languages' code spans ran in different
-- orders; the Korean bullets keep their prose and carry the English constraints' code spans
-- exactly. Only the Korean constraints change; Slug, title, description, English text, Test
-- Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= length <= 50000`
- `0 <= index < length`
- `0 <= val <= 10^8`
- `0 <= snapId`이며 `snapId`는 지금까지 호출된 `commit` 횟수보다 반드시 작습니다.
- 합쳐서 최대 `50000`번까지 `set`, `commit`, `readAt`이 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$versioned-cells$$);
