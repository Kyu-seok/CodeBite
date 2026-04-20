-- Regenerate hidden test cases for Batch 17 problems
-- Problems: staircase, state-snapshots, stock-cooldown, stock-profit, string-codec,
--           string-multiply, string-weave, subsequence-count, substring-permutation, sudoku-validator

-- staircase (samples: order 1-2, existing hidden: 3-5, new hidden: 6-13)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'staircase')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'staircase')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'staircase'), '4', '5', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '6', '13', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '7', '21', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '15', '987', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '20', '10946', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '30', '1346269', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '35', '14930352', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'staircase'), '45', '1836311903', FALSE, 10);

-- state-snapshots (samples: order 1-3, new hidden: 4-11)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'state-snapshots')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","set","set","snap","set","get","get"]\n[[5],[0,10],[0,20],[],[0,30],[0,0],[0,1]]', '[null,null,null,0,null,20,30]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","set","set","snap","get","get","get"]\n[[10],[3,42],[7,99],[],[3,0],[7,0],[0,0]]', '[null,null,null,0,42,99,0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","set","snap","snap","snap","get","get","get"]\n[[3],[1,5],[],[],[],[1,0],[1,1],[1,2]]', '[null,null,0,1,2,5,5,5]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","snap","set","snap","get","get"]\n[[2],[],[1,100],[],[1,0],[1,1]]', '[null,0,null,1,0,100]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","set","set","snap","set","set","snap","get","get","get","get"]\n[[2],[0,1],[1,2],[],[0,3],[1,4],[],[0,0],[1,0],[0,1],[1,1]]', '[null,null,null,0,null,null,1,1,2,3,4]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","set","snap","set","snap","set","snap","set","snap","get","get","get","get"]\n[[1],[0,10],[],[0,20],[],[0,30],[],[0,40],[],[0,0],[0,1],[0,2],[0,3]]', '[null,null,0,null,1,null,2,null,3,10,20,30,40]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","snap","snap","get","get"]\n[[3],[],[],[0,0],[2,1]]', '[null,0,1,0,0]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'state-snapshots'), E'["SnapshotArray","set","set","set","snap","get"]\n[[1],[0,1],[0,2],[0,3],[],[0,0]]', '[null,null,null,null,0,3]', FALSE, 11);

-- stock-cooldown (samples: order 1-3, new hidden: 4-11)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-cooldown')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-cooldown')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,2,3,4,5]', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[5,4,3,2,1]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[3,3,3,3,3]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,3,5,4,3,2,8]', '10', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[2,1,4,5,2,9,7]', '10', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,2,3,0,2,5,0,1,4]', '9', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[10,1,10,1,10]', '9', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'stock-cooldown'), '[1,100]', '99', FALSE, 11);

-- stock-profit (samples: order 1-2, new hidden: 3-10)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-profit')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stock-profit')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[2,1,2,1,0,1,2]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[3,3,3,3,3]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[1,2]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[2,1]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[10,8,2,9]', '7', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[5,11,3,50,60,90]', '87', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[1,2,3,4,5]', '4', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'stock-profit'), '[100,90,80,70,60,50]', '0', FALSE, 10);

-- string-codec (samples: order 1-3, new hidden: 4-11)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-codec')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["a"]', '["a"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["hello#world","test"]', '["hello#world","test"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["123","456","789"]', '["123","456","789"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["","a","","b",""]', '["","a","","b",""]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["a very long string with spaces and special chars!@#$%"]', '["a very long string with spaces and special chars!@#$%"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["one","two","three","four","five","six","seven"]', '["one","two","three","four","five","six","seven"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["\\n","\\t","\\r"]', '["\\n","\\t","\\r"]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'string-codec'), '["aaa","aaa","aaa"]', '["aaa","aaa","aaa"]', FALSE, 11);

-- string-multiply (samples: order 1-3, new hidden: 4-11)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-multiply')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-multiply')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'9\n9', '81', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'12345\n1', '12345', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'1\n12345', '12345', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'10\n10', '100', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'111\n111', '12321', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'9999999\n9999999', '99999980000001', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'50\n50', '2500', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'string-multiply'), E'123456789\n987654321', '121932631112635269', FALSE, 11);

-- string-weave (samples: order 1-3, new hidden: 4-11)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-weave')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'string-weave')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'ab\ncd\nacbd', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'ab\ncd\nacdb', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'abc\n\nabc', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'aaa\nbbb\naaabbb', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'aaa\nbbb\nababab', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'ab\nab\naabb', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'ab\ncd\ndcba', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'string-weave'), E'ab\ncd\nabcde', 'false', FALSE, 11);

-- subsequence-count (samples: order 1-3, new hidden: 4-11)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'subsequence-count')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'subsequence-count')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'aabb\nab', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'aaaa\naa', '6', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'abcde\nace', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'abcde\nabcde', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'abcde\nf', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'aaabaa\naa', '10', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'aabdbaabeeadcbbdedacbbeecbabebaeeecaeabaedadcbdbcdaabebdceaaaaebaadbcearab\nbed', '591', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'subsequence-count'), E'xxxyyyzzz\nxyz', '27', FALSE, 11);

-- substring-permutation (samples: order 1-2, new hidden: 3-10)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'substring-permutation')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'substring-permutation')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'a\na', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'abc\ncba', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'abc\nabcd', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'aab\naab', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'ab\na', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'abcabc\nabc', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'aaaa\naaaa', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'substring-permutation'), E'abc\ndefghijklmnop', 'false', FALSE, 10);

-- sudoku-validator (samples: order 1-2, new hidden: 3-10)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sudoku-validator')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sudoku-validator')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."]]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["1",".",".",".",".",".",".",".","."],["1",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."]]', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["1",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".","1",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["1","1",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."]]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["5","3","4","6","7","8","9","1","2"],["6","7","2","1","9","5","3","4","8"],["1","9","8","3","4","2","5","6","7"],["8","5","9","7","6","1","4","2","3"],["4","2","6","8","5","3","7","9","1"],["7","1","3","9","2","4","8","5","6"],["9","6","1","5","3","7","2","8","4"],["2","8","7","4","1","9","6","3","5"],["3","4","5","2","8","6","1","7","9"]]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["5","3",".",".","7",".",".",".","."],["6",".",".","1","9","5",".",".","."],[".","9","8",".",".",".",".","6","."],["8",".",".",".","6",".",".",".","3"],["4",".",".","8",".","3",".",".","1"],["7",".",".",".","2",".",".",".","6"],[".","6",".",".",".",".","2","8","."],[".",".",".","4","1","9",".",".","5"],[".",".",".",".","8",".",".","7","8"]]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["1",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".","1",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."]]', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'sudoku-validator'), '[["1",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".","1",".",".",".","."],[".",".",".",".",".",".",".",".","."],[".",".",".",".",".",".",".",".","."]]', 'true', FALSE, 10);
