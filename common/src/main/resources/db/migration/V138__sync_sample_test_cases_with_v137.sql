-- V138: Sync sample test_cases with V137's new description examples.
--
-- V137 rewrote 27 example blocks across 20 problems to drop LC-verbatim
-- values. But the existing is_sample=TRUE rows in test_cases still held
-- the pre-rewrite LC-verbatim inputs/outputs — meaning the description
-- and the 'Run' button disagreed. This migration updates those 27 sample
-- rows so each description Example N matches test_cases order_index N.
--
-- One extra UPDATE (flip-phone-codes order_index=3): after V137 replaced
-- description Example 2 with digits="2" -> ["a","b","c"], that
-- would have duplicated the existing sample 3 (which was LC Example 3
-- verbatim). Rewrite sample 3 to digits="7" -> ["p","q","r","s"]
-- so the two samples stay distinct and neither is LC-verbatim.

-- balance-print-queue sample 2
UPDATE test_cases SET
    input = '((',
    expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balance-print-queue')
  AND is_sample = TRUE
  AND order_index = 2;

-- balanced-hamster-tree sample 3
UPDATE test_cases SET
    input = '[1,2]',
    expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balanced-hamster-tree')
  AND is_sample = TRUE
  AND order_index = 3;

-- drop-conflicting-classes sample 1
UPDATE test_cases SET
    input = '[[10,20],[12,18],[22,30]]',
    expected_output = '1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-conflicting-classes')
  AND is_sample = TRUE
  AND order_index = 1;

-- drop-conflicting-classes sample 2
UPDATE test_cases SET
    input = '[[1,4],[1,4],[1,4],[1,4]]',
    expected_output = '3'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-conflicting-classes')
  AND is_sample = TRUE
  AND order_index = 2;

-- drop-conflicting-classes sample 3
UPDATE test_cases SET
    input = '[[1,5],[6,10]]',
    expected_output = '0'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'drop-conflicting-classes')
  AND is_sample = TRUE
  AND order_index = 3;

-- flatten-agenda-tree sample 2
UPDATE test_cases SET
    input = '[1]',
    expected_output = '[1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flatten-agenda-tree')
  AND is_sample = TRUE
  AND order_index = 2;

-- flip-phone-codes sample 2
UPDATE test_cases SET
    input = '2',
    expected_output = '["a","b","c"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-phone-codes')
  AND is_sample = TRUE
  AND order_index = 2;

-- flip-phone-codes sample 3
UPDATE test_cases SET
    input = '7',
    expected_output = '["p","q","r","s"]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-phone-codes')
  AND is_sample = TRUE
  AND order_index = 3;

-- grocery-bag-triple sample 1
UPDATE test_cases SET
    input = E'[[1,2,3],[4,2,1],[1,5,3],[2,1,4]]\n[4,5,4]',
    expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'grocery-bag-triple')
  AND is_sample = TRUE
  AND order_index = 1;

-- grocery-bag-triple sample 2
UPDATE test_cases SET
    input = E'[[1,2,3],[4,5,6]]\n[3,4,5]',
    expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'grocery-bag-triple')
  AND is_sample = TRUE
  AND order_index = 2;

-- group-study-cards sample 1
UPDATE test_cases SET
    input = E'[1,2,3,4,5,6,7,8]\n2',
    expected_output = 'true'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-study-cards')
  AND is_sample = TRUE
  AND order_index = 1;

-- group-study-cards sample 2
UPDATE test_cases SET
    input = E'[1,2,3,4]\n3',
    expected_output = 'false'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-study-cards')
  AND is_sample = TRUE
  AND order_index = 2;

-- group-tree-by-level sample 3
UPDATE test_cases SET
    input = '[7]',
    expected_output = '[[7]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'group-tree-by-level')
  AND is_sample = TRUE
  AND order_index = 3;

-- kth-top-score-stream sample 1
UPDATE test_cases SET
    input = E'["TopKStream","record","record","record"]\n[[2,[100,50]],[75],[120],[60]]',
    expected_output = '[null,75,100,100]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-top-score-stream')
  AND is_sample = TRUE
  AND order_index = 1;

-- merge-cafe-queues sample 2
UPDATE test_cases SET
    input = '[[1,3,5],[2,4,6]]',
    expected_output = '[1,2,3,4,5,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-cafe-queues')
  AND is_sample = TRUE
  AND order_index = 2;

-- merge-cafe-queues sample 3
UPDATE test_cases SET
    input = '[[1,4],[2,5],[3,6]]',
    expected_output = '[1,2,3,4,5,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-cafe-queues')
  AND is_sample = TRUE
  AND order_index = 3;

-- merge-leaderboard-runs sample 2
UPDATE test_cases SET
    input = E'[]\n[2,4,6]',
    expected_output = '[2,4,6]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-leaderboard-runs')
  AND is_sample = TRUE
  AND order_index = 2;

-- mirror-menu-tree sample 3
UPDATE test_cases SET
    input = '[5]',
    expected_output = '[5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-menu-tree')
  AND is_sample = TRUE
  AND order_index = 3;

-- nearest-cat-feeder sample 1
UPDATE test_cases SET
    input = '[[2147483647,0],[2147483647,2147483647]]',
    expected_output = '[[1,0],[2,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nearest-cat-feeder')
  AND is_sample = TRUE
  AND order_index = 1;

-- rebuild-tournament-line sample 1
UPDATE test_cases SET
    input = '[[3,0],[6,0],[6,1],[4,1]]',
    expected_output = '[[3,0],[6,0],[4,1],[6,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rebuild-tournament-line')
  AND is_sample = TRUE
  AND order_index = 1;

-- rebuild-tournament-line sample 2
UPDATE test_cases SET
    input = '[[2,0],[5,0],[2,1],[5,1]]',
    expected_output = '[[2,0],[2,1],[5,0],[5,1]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rebuild-tournament-line')
  AND is_sample = TRUE
  AND order_index = 2;

-- redundant-friendship sample 1
UPDATE test_cases SET
    input = '[[1,2],[1,3],[2,3]]',
    expected_output = '[2,3]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'redundant-friendship')
  AND is_sample = TRUE
  AND order_index = 1;

-- reverse-playlist sample 3
UPDATE test_cases SET
    input = '[1]',
    expected_output = '[1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reverse-playlist')
  AND is_sample = TRUE
  AND order_index = 3;

-- right-side-skill-view sample 3
UPDATE test_cases SET
    input = '[1,null,2]',
    expected_output = '[1,2]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'right-side-skill-view')
  AND is_sample = TRUE
  AND order_index = 3;

-- rotting-donuts sample 3
UPDATE test_cases SET
    input = '[[2,0],[0,1]]',
    expected_output = '-1'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotting-donuts')
  AND is_sample = TRUE
  AND order_index = 3;

-- split-sticker-runs sample 1
UPDATE test_cases SET
    input = 'abacbcd',
    expected_output = '[6,1]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-sticker-runs')
  AND is_sample = TRUE
  AND order_index = 1;

-- split-sticker-runs sample 2
UPDATE test_cases SET
    input = 'rsrsr',
    expected_output = '[5]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'split-sticker-runs')
  AND is_sample = TRUE
  AND order_index = 2;

-- username-trie sample 1
UPDATE test_cases SET
    input = E'["PrefixIndex","insert","insert","search","search","startsWith","search","startsWith"]\n[[],["cat"],["car"],["cat"],["ca"],["ca"],["car"],["dog"]]',
    expected_output = '[null,null,null,true,false,true,true,false]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'username-trie')
  AND is_sample = TRUE
  AND order_index = 1;

