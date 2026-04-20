-- Regenerate hidden test cases for batch 11 problems
-- Problems: mirror-tree, move-zeroes, next-arrangement, non-overlapping,
--           nth-ugly, numeral-converter, overlap-merge, pacific-atlantic,
--           pair-sum, palindrome-checker

------------------------------------------------------------
-- mirror-tree
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-tree')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-tree')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[1]', '[1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[1,2]', '[1,null,2]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[1,null,2]', '[1,2]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[1,2,3,4,5,6,7]', '[1,3,2,7,6,5,4]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[5,3,8,1,4,7,9]', '[5,8,3,9,7,4,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[1,2,null,3]', '[1,null,2,null,3]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[1,null,2,null,3]', '[1,2,null,3]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'mirror-tree'), '[10,5,15,3,7,12,20]', '[10,15,5,20,12,7,3]', FALSE, 11);

------------------------------------------------------------
-- move-zeroes
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'move-zeroes')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'move-zeroes')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[1]', '[1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[0,0,0]', '[0,0,0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[1,2,3]', '[1,2,3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[0,0,1]', '[1,0,0]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[2,1]', '[2,1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[0,1,0,3,12,0,0,5]', '[1,3,12,5,0,0,0,0]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[-1,0,0,3,-2,0]', '[-1,3,-2,0,0,0]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'move-zeroes'), '[0]', '[0]', FALSE, 10);

------------------------------------------------------------
-- next-arrangement
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-arrangement')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'next-arrangement')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[2,3,1]', '[3,1,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1,1]', '[1,1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1,2,3,4]', '[1,2,4,3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[4,3,2,1]', '[1,2,3,4]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[2,1,3]', '[2,3,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1,5,1]', '[5,1,1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[5,4,7,5,3,2]', '[5,5,2,3,4,7]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'next-arrangement'), '[1]', '[1]', FALSE, 11);

------------------------------------------------------------
-- non-overlapping
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'non-overlapping')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'non-overlapping')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,2]]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,3],[2,4],[3,5]]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[0,2],[1,3],[2,4],[3,5],[4,6]]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,10],[2,3],[4,5],[6,7]]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[-100,-50],[0,50],[50,100]]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,2],[1,3],[1,4]]', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[1,5],[2,3],[3,4],[4,6]]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'non-overlapping'), '[[0,1],[0,1],[0,1],[0,1]]', '3', FALSE, 11);

------------------------------------------------------------
-- nth-ugly
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-ugly')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'nth-ugly')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '5', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '20', '36', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '50', '243', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '150', '5832', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '500', '937500', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '1000', '51200000', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '2', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'nth-ugly'), '3', '3', FALSE, 11);

------------------------------------------------------------
-- numeral-converter
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'numeral-converter')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'numeral-converter')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'I', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'XLII', '42', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'XCIX', '99', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'CD', '400', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'CDXLIV', '444', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'DCCCLXXXVIII', '888', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'MMM', '3000', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'numeral-converter'), 'MMMDCCCLXXXVIII', '3888', FALSE, 11);

------------------------------------------------------------
-- overlap-merge
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'overlap-merge')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'overlap-merge')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[1,3]]', '[[1,3]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[1,4],[0,4]]', '[[0,4]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[1,4],[2,3]]', '[[1,4]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[1,10],[2,3],[4,5],[6,7]]', '[[1,10]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[1,2],[3,4],[5,6]]', '[[1,2],[3,4],[5,6]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[2,3],[4,5],[6,7],[8,9],[1,10]]', '[[1,10]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[0,0],[1,1]]', '[[0,0],[1,1]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'overlap-merge'), '[[1,5],[2,3],[4,8],[9,10]]', '[[1,8],[9,10]]', FALSE, 10);

------------------------------------------------------------
-- pacific-atlantic
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pacific-atlantic')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pacific-atlantic')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1,2],[3,4]]', '[[0,1],[1,0],[1,1]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[5]]', '[[0,0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1,2,3],[4,5,6],[7,8,9]]', '[[0,2],[1,2],[2,0],[2,1],[2,2]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[3,3,3],[3,1,3],[3,3,3]]', '[[0,0],[0,1],[0,2],[1,0],[1,2],[2,0],[2,1],[2,2]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1,1],[1,1],[1,1]]', '[[0,0],[0,1],[1,0],[1,1],[2,0],[2,1]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[10,1],[1,10]]', '[[0,0],[0,1],[1,0],[1,1]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[1,2,3,4],[12,13,14,5],[11,16,15,6],[10,9,8,7]]', '[[0,3],[1,0],[1,1],[1,2],[1,3],[2,0],[2,1],[2,2],[2,3],[3,0],[3,1],[3,2],[3,3]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'pacific-atlantic'), '[[2,1],[1,2]]', '[[0,0],[0,1],[1,0],[1,1]]', FALSE, 10);

------------------------------------------------------------
-- pair-sum
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pair-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[3,3]\n6', '[0,1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[0,4,3,0]\n0', '[0,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[-1,-2,-3,-4,-5]\n-8', '[2,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[1,2,3,4,5,6,7,8,9,10]\n19', '[8,9]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[100,200,300,400]\n700', '[2,3]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[2,5,5,11]\n10', '[1,2]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[1,3]\n4', '[0,1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'pair-sum'), E'[1000000000,-1000000000]\n0', '[0,1]', FALSE, 10);

------------------------------------------------------------
-- palindrome-checker
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-checker')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-checker')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), '.,!?', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'a', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'ab', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'aba', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'Was it a car or a cat I saw?', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'No lemon, no melon', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), 'hello', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'palindrome-checker'), '12321', 'true', FALSE, 11);
