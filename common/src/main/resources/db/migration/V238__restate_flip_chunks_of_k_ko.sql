-- V238: restate flip-chunks-of-k (#192, part of #168). The Korean constraints kept LeetCode's
-- bounds where the English state CodeBite's (`n <= 5000` for `6000`), and split `1 <= k <= n
-- <= 6000` over two bullets; the Korean bullets keep their prose and carry the English
-- constraints' code spans exactly. Only the Korean constraints change; Slug, title,
-- description, English text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problem_translations SET
    constraints = $$- 리스트의 노드 수는 `n`입니다.
- `1 <= k <= n <= 6000`
- `0 <= Node.val <= 1000`$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$flip-chunks-of-k$$);
