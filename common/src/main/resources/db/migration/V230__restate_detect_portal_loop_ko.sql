-- V230: restate detect-portal-loop (#192, part of #168). The Korean constraints named
-- `Node.val` where the English constraints name `Room.val`; the Korean bullets keep their
-- prose and carry the English constraints' code spans exactly. Only the Korean constraints
-- change; Slug, title, description, English text, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problem_translations SET
    constraints = $$- 방의 개수는 `[0, 2 * 10^3]` 범위 안에 있습니다.
- `-8 * 10^4 <= Room.val <= 8 * 10^4`
- `pos`는 `-1`이거나 체인 안의 유효한 0-based 인덱스입니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$detect-portal-loop$$);
