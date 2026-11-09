-- V257: restate reverse-linked-list (#192, part of #168). The Korean constraints named
-- `Node.val` where the English constraints name `Song.val`; the Korean bullets keep their
-- prose and carry the English constraints' code spans exactly. Only the Korean constraints
-- change; Slug, title, description, English text, Test Cases, Starter Code and Drivers are
-- unchanged.

UPDATE problem_translations SET
    constraints = $$- 리스트의 노드 개수는 `[0, 6000]` 범위 안에 있습니다.
- `-6000 <= Song.val <= 6000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$reverse-linked-list$$);
