-- V210: restate sort-colors (#171, part of #168). The English constraints named
-- `supplies` -> `nums`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= nums.length <= 2 * 10^3`
- `nums[i]` is `0`, `1`, or `2`.$$
WHERE slug = $$sort-colors$$;
