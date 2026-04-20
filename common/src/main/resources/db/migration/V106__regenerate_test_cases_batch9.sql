-- Regenerate hidden test cases for batch 9 problems
-- Problems: largest-square, largest-subarray, last-stone, level-traversal,
--           lone-element, longest-ascending, longest-chain-count, longest-climb,
--           longest-common-subseq, longest-palindrome

------------------------------------------------------------
-- largest-square
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-square')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-square')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","1"],["1","1"]]', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["0","0","0"],["0","0","0"],["0","0","0"]]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","0","1","1","1"],["0","1","1","1","1"],["1","1","1","1","1"],["0","1","1","1","0"]]', '9', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1"]]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["0"]]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","1","1","1","1"],["1","1","1","1","1"],["1","1","1","1","1"],["1","1","1","1","1"],["1","1","1","1","1"]]', '25', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","0","1","0","1"],["0","1","0","1","0"],["1","0","1","0","1"]]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","1","1","0"],["1","1","1","0"],["1","1","1","0"]]', '9', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["0","1","1","1","1"],["0","1","1","1","1"],["0","1","1","1","1"],["0","1","1","1","1"]]', '16', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'largest-square'), '[["1","1","0","0","0"],["1","1","0","0","0"],["0","0","1","1","1"],["0","0","1","1","1"],["0","0","1","1","1"]]', '9', FALSE, 13);

------------------------------------------------------------
-- largest-subarray
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-subarray')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'largest-subarray')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-1]', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-2,-1]', '-1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[1,2,3,4,5]', '15', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-3,1,2,-1,4,-2]', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[0,0,0,0]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-1,-2,-3,-4]', '-1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[100,-1,100]', '199', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[1,-1,1,-1,1,-1,1]', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[-2,1]', '1', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'largest-subarray'), '[3,-2,5,-1]', '6', FALSE, 13);

------------------------------------------------------------
-- last-stone
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'last-stone')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'last-stone')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[3,7,2]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[2,2]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[10]', '10', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[1,1,1,1]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[5,5,5]', '5', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[10,4,2,10]', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[1,2,3,4,5]', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[31,26,33,21,40]', '9', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[9,3,2,10]', '0', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'last-stone'), '[1,1]', '0', FALSE, 12);

------------------------------------------------------------
-- level-traversal
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'level-traversal')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'level-traversal')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[1,2,3,4,5]', '[[1],[2,3],[4,5]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[1,null,2,null,3]', '[[1],[2],[3]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[1,2,null,3,null,4]', '[[1],[2],[3],[4]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[5,4,7,3,null,2,null,-1,null,9]', '[[5],[4,7],[3,2],[-1,9]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[1,2,3,4,5,6,7]', '[[1],[2,3],[4,5,6,7]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[0]', '[[0]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[1,2,3,null,null,4,5]', '[[1],[2,3],[4,5]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[1,2,3,4,null,null,5]', '[[1],[2,3],[4,5]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'level-traversal'), '[10,5,15,3,7,null,18]', '[[10],[5,15],[3,7,18]]', FALSE, 12);

------------------------------------------------------------
-- lone-element
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lone-element')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'lone-element')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[-1,1,1]', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[0,1,0]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[3,3,5,5,7]', '7', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[100]', '100', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[10,20,10,30,30]', '20', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[-5,-5,0,0,42]', '42', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[1,2,3,1,2]', '3', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[999,1,999]', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[0,0,1,1,2]', '2', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'lone-element'), '[-100,100,-100]', '100', FALSE, 13);

------------------------------------------------------------
-- longest-ascending
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-ascending')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-ascending')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[1,2,3,4,5]', '5', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[5,4,3,2,1]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[3,10,2,1,20]', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[1,3,6,7,9,4,10,5,6]', '6', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[2,2]', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[1,2,3,1,2,3,4]', '4', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[10,22,9,33,21,50,41,60]', '5', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[4,10,4,3,8,9]', '3', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'longest-ascending'), '[0,-1,3,2,5]', '3', FALSE, 13);

------------------------------------------------------------
-- longest-chain-count
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-chain-count')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-chain-count')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,2,4,3,5,4,7,2]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[3,1,2]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,1,1,2,2,2,3,3,3]', '27', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[5,4,3,2,1]', '5', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,2]', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,5,2,3,4]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[10,9,2,5,3,7,101,18]', '4', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[3,3,3]', '3', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'longest-chain-count'), '[1,2,3,4,5]', '1', FALSE, 13);

------------------------------------------------------------
-- longest-climb
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-climb')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-climb')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,2,3],[8,9,4],[7,6,5]]', '9', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,2],[4,3]]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[7,8,9],[9,7,6],[7,2,3]]', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,1,1],[1,1,1],[1,1,1]]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1]]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1,2,3,4,5]]', '5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[1],[2],[3],[4],[5]]', '5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[3,2,1],[4,5,6],[9,8,7]]', '9', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[5,4,3],[6,1,2],[7,8,9]]', '9', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'longest-climb'), '[[10,6,8],[9,5,7],[4,3,1]]', '5', FALSE, 13);

------------------------------------------------------------
-- longest-common-subseq
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-common-subseq')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-common-subseq')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'oxcpqrsvwf\nshmtulqrypy', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'abcba\nabcbcba', '5', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'a\na', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'a\nb', '0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'abcdefg\naceg', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'aaaa\naa', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'abcde\nedcba', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'programming\ncontest', '2', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'abc\nxyz', '0', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'longest-common-subseq'), E'horse\nros', '2', FALSE, 13);

------------------------------------------------------------
-- longest-palindrome
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-palindrome')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-palindrome')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'aacabdkacaa', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'racecar', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'aaaa', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'abcde', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'abacabad', '7', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'aabbcc', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'abba', '4', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'abcba', '5', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'aabaab', '5', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'longest-palindrome'), 'xyzzy', '4', FALSE, 13);
