-- V254: restate order-group-tasks (#192, part of #168). The Korean constraints put `prereqs`
-- before the pair `[a, b]`, so the two languages' code spans ran in different orders; the
-- Korean bullets keep their prose and carry the English constraints' code spans exactly. Only
-- the Korean constraints change; Slug, title, description, English text, Test Cases, Starter
-- Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= numSteps <= 2000`
- `0 <= prereqs.length <= numSteps * (numSteps - 1)`
- `prereqs[i].length == 2`
- `0 <= a, b < numSteps`
- `a != b`
- 모든 쌍 `[a, b]`는 `prereqs` 안에서 서로 다릅니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$order-group-tasks$$);
