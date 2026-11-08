-- V211: restate trapping-rain-water (#172, part of #168). The English constraints named
-- `wallHeight` -> `height`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `n == height.length`
- `1 <= n <= 2 * 10^5`
- `0 <= height[i] <= 10^8`$$
WHERE slug = $$trapping-rain-water$$;
