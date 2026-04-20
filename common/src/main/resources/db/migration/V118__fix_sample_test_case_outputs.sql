-- Correct expected outputs for two sample test cases that were wrong at seed time.
-- ip-builder TC#3: `101023` yields 7 IPs in the original seed, but only 5 are valid
-- under the no-leading-zero rule. label-splitter TC#2: `abcadefg` was seeded as [4,4]
-- but the correct partition is [4,1,1,1,1].
-- V47 and V51 were already applied in production, so we patch the rows with UPDATEs
-- rather than editing those migrations in place (which would trigger checksum mismatch).

UPDATE test_cases
SET expected_output = '["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","101.0.2.3"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ip-builder')
  AND input = '101023'
  AND is_sample = TRUE;

UPDATE test_cases
SET expected_output = '[4,1,1,1,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-splitter')
  AND input = 'abcadefg'
  AND is_sample = TRUE;
