-- V139: Switch order-group-tasks test cases to a canonical VALID/INVALID token.
--
-- The problem (LeetCode 210, topological sort) accepts any valid ordering, but
-- the judge does exact string comparison. The drivers were updated to validate
-- the user's output against the prereq graph and emit "VALID" / "INVALID";
-- update every test case row to expect "VALID" so any correct topological
-- ordering (including the correctly-empty answer for cycle inputs) passes.

UPDATE test_cases
SET expected_output = 'VALID'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'order-group-tasks');
