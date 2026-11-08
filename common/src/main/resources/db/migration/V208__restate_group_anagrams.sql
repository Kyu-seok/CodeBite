-- V208: restate group-anagrams (#169, part of #168). The English constraints named
-- `labels` -> `strs`, which the Starter Code never mentions. Only the
-- English constraints change; Slug, title, description, Korean text, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= strs.length <= 8 * 10^3`
- `0 <= strs[i].length <= 100`
- `strs[i]` consists of lowercase English letters.$$
WHERE slug = $$group-anagrams$$;
