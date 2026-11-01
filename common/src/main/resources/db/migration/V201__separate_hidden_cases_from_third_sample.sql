-- V201: two-menu-sum, shortest-book-span and queue-from-stacks each gained a third sample at
-- order_index 3 on top of their first hidden case, so the two ran in no fixed order and a Failing
-- Case's position was ambiguous. Each hidden case from 3 up moves one place; no case changes.

UPDATE test_cases SET order_index = order_index + 1
WHERE problem_id IN (SELECT id FROM problems
                     WHERE slug IN ('two-menu-sum', 'shortest-book-span', 'queue-from-stacks'))
  AND is_sample = FALSE
  AND order_index >= 3;
