-- V202: Test Case Correction for two-menu-sum, whose statement promises exactly one pair.
-- The hidden case [1,3,5,7,9] / 10 had two (1+9 and 3+7), so a hash-map solution printing [2,4]
-- was judged Wrong Answer. 7 becomes 6, leaving only 1+9; the expected output stays [1,5].
-- Edited in place, past verdicts stand (docs/adr/0010). Checked by TwoMenuSumGuarantee.

UPDATE test_cases SET input = E'[1,3,5,6,9]\n10', expected_output = '[1,5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'two-menu-sum')
  AND is_sample = FALSE
  AND order_index = 8
  AND input = E'[1,3,5,7,9]\n10';
