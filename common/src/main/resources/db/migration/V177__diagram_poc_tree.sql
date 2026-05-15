-- Stage 1 POC for the diagram system: embed a `diagram-tree` directive after
-- Example 1 of "Invert Binary Tree" so the tree input renders as a visual
-- alongside the textual `[4,2,7,1,3,6,9]`. Updates both en (problems.description)
-- and ko (problem_translations.description) since the directive body is
-- language-neutral.

UPDATE problems
SET description = REPLACE(
    description,
    E'Output: [4,7,2,9,6,3,1]\n```',
    E'Output: [4,7,2,9,6,3,1]\n```\n\n```diagram-tree\nnodes: [4, 2, 7, 1, 3, 6, 9]\n```'
)
WHERE slug = 'invert-binary-tree';

UPDATE problem_translations
SET description = REPLACE(
    description,
    E'Output: [4,7,2,9,6,3,1]\n```',
    E'Output: [4,7,2,9,6,3,1]\n```\n\n```diagram-tree\nnodes: [4, 2, 7, 1, 3, 6, 9]\n```'
)
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'invert-binary-tree')
  AND locale = 'ko';
