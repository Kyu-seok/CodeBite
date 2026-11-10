-- V305: restate queue-from-stacks (#238). The constraints bounded x to 1..9 (LeetCode's
-- bound), but six of the eleven Test Cases push larger order numbers (up to 300), Example 2
-- among them; both languages now bound x to 1..1000. Only the constraints change; Slug,
-- title, description, Test Cases, Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `1 <= x <= 1000`
- At most `100` combined calls to `push`, `pop`, `peek`, and `empty`
- `pop` and `peek` are only invoked when the line is non-empty$$
WHERE slug = $$queue-from-stacks$$;

UPDATE problem_translations SET
    constraints = $$- `1 <= x <= 1000`
- 합쳐서 최대 `100`번까지 `push`, `pop`, `peek`, `empty`가 호출됩니다.
- `pop`과 `peek`은 큐가 비어 있지 않을 때만 호출됩니다.$$
WHERE locale = 'ko'
  AND problem_id = (SELECT id FROM problems WHERE slug = $$queue-from-stacks$$);
