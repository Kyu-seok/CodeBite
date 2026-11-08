-- V214: restate graph-valid-tree (#175, part of #168). The English constraints named
-- `lanes` -> `edges`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= n <= 2 * 10^3`
- `0 <= edges.length <= 4500`
- `edges[i].length == 2`
- `0 <= edges[i][0], edges[i][1] < n`
- No self-loops and no duplicate edges$$
WHERE slug = $$graph-valid-tree$$;
