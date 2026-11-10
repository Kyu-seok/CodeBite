-- V304: restate lru-cache (#237). Both languages' constraints named the operations
-- `lookup` and `store` (set by the casual retheme, V133, and copied into the Korean by
-- V246), but the description, Starter Code and Drivers use `get` and `put`.
-- Only the constraints change, every bound kept; Slug, title, description, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- At most `2 * 10^5` combined calls to `get` and `put`$$
WHERE slug = $$lru-cache$$;

UPDATE problem_translations SET
    constraints = $$- `1 <= capacity <= 3000`
- `0 <= key <= 8000`
- `0 <= value <= 80000`
- 합쳐서 최대 `2 * 10^5`번까지 `get`과 `put`이 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$lru-cache$$);
