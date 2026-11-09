-- V229: restate count-task-orderings (#192, part of #168). The Korean constraints put the
-- condition `i >= 1` before `0 <= parent[i] < n`, so the two languages' code spans ran in
-- different orders; the Korean bullets keep their prose and carry the English constraints'
-- code spans exactly. Only the Korean constraints change; Slug, title, description, English
-- text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- `1 <= n <= 2 * 10^5`
- `parent.length == n`
- `parent[0] == -1`
- `0 <= parent[i] < n` (`i >= 1`인 경우)
- 입력은 항상 유효한 루트 트리를 나타냄이 보장됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$count-task-orderings$$);
