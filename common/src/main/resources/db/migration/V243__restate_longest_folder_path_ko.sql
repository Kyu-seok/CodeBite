-- V243: restate longest-folder-path (#192, part of #168). The Korean constraints kept
-- LeetCode's bounds where the English state CodeBite's (`[1, 10^4]` nodes for `[1, 8000]`);
-- the Korean bullets keep their prose and carry the English constraints' code spans exactly.
-- Only the Korean constraints change; Slug, title, description, English text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- 트리의 노드 개수는 `[1, 8000]` 범위입니다.
- `-100 <= Node.val <= 100`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$longest-folder-path$$);
