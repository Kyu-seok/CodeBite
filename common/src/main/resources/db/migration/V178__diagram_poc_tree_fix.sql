-- V177 fix: the original POC migration targeted slug `invert-binary-tree`,
-- but the slug was renamed to `mirror-menu-tree` in V134 and the example
-- values were rewritten in V137. As a result V177 matched zero rows in
-- both UPDATEs and is now a historical no-op.
--
-- This migration redoes the embed against the current slug/description.
-- The KO description uses "출력:" instead of "Output:" so the two REPLACE
-- targets differ.

-- English description
UPDATE problems
SET description = REPLACE(
    description,
    E'Output: [5,8,3,9,7,4,2]\n```',
    E'Output: [5,8,3,9,7,4,2]\n```\n\n```diagram-tree\nnodes: [5, 3, 8, 2, 4, 7, 9]\n```'
)
WHERE slug = 'mirror-menu-tree';

-- Korean translation
UPDATE problem_translations
SET description = REPLACE(
    description,
    E'출력: [5,8,3,9,7,4,2]\n```',
    E'출력: [5,8,3,9,7,4,2]\n```\n\n```diagram-tree\nnodes: [5, 3, 8, 2, 4, 7, 9]\n```'
)
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-menu-tree')
  AND locale = 'ko';
