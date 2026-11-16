-- V582: snack-drawer-pair hidden case 10 used ±10^9, ten times the stated bound
-- (-10^8 <= snacks[i] <= 10^8, in English and Korean). Found by the statement cold-read
-- (#350). The values shrink to ±10^8, the boundary the case was meant to test; the
-- pair and so the expected output [0,1] stay. SnackDrawerPairGuarantee checks it.

UPDATE test_cases SET input = E'[100000000,-100000000]\n0', expected_output = '[0,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'snack-drawer-pair')
  AND is_sample = FALSE AND order_index = 10 AND input = E'[1000000000,-1000000000]\n0';
