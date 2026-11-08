-- V217: restate walls-and-gates (#181, part of #168). The English constraints named
-- `grid[i][j]`, which the Starter Code (wallsAndGates(rooms)), the description and the
-- Korean constraints call `rooms`. Only the English constraints change; Slug, title,
-- description, Korean text, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= m, n <= 250`
- `rooms[i][j]` is `-1`, `0`, or `2147483647`.$$
WHERE slug = $$walls-and-gates$$;
