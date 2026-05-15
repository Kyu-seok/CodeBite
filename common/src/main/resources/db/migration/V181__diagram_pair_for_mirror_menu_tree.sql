-- Upgrade the V180-inserted single-tree diagram into a before/after pair so
-- Example 1 shows input AND inverted output side-by-side (LeetCode style).
--
-- Plain REPLACE on V180's exact inserted text. Both H2 and Postgres replace
-- all occurrences with REPLACE, so any duplicates in local dev DBs from
-- earlier debugging get upgraded too.

-- English description
UPDATE problems
SET description = REPLACE(
    description,
    $$```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
```$$,
    $$```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
after: [5, 8, 3, 9, 7, 4, 2]
```$$
)
WHERE slug = 'mirror-menu-tree';

-- Korean translation (same diagram body — the spec is language-neutral)
UPDATE problem_translations
SET description = REPLACE(
    description,
    $$```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
```$$,
    $$```diagram-tree
nodes: [5, 3, 8, 2, 4, 7, 9]
after: [5, 8, 3, 9, 7, 4, 2]
```$$
)
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-menu-tree')
  AND locale = 'ko';
