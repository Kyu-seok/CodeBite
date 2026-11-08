-- V213: restate largest-rectangle-histogram (#174, part of #168). The English constraints named
-- `lockers` -> `heights`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= heights.length <= 2 * 10^5`
- `0 <= heights[i] <= 2 * 10^3`$$
WHERE slug = $$largest-rectangle-histogram$$;
