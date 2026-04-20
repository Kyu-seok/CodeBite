-- V99: Regenerate hidden test cases for batch 2 (10 problems)
-- All test cases validated against Judge0 (Python 3.8.1, language_id=71)

-- ============================================================
-- array-product
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-product')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-product')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[0,0,0]', '[0,0,0]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[5,10]', '[10,5]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[-1,-1,-1,-1]', '[-1,-1,-1,-1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[1,0,3,0]', '[0,0,0,0]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[10,3,5,6,2]', '[180,600,360,300,900]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[-2,3,-4,5]', '[-60,40,-30,24]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[1,2,3,4,5,6]', '[720,360,240,180,144,120]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[0,1]', '[1,0]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'array-product'), '[30,-30,1,-1]', '[30,-30,900,-900]', FALSE, 11);

-- ============================================================
-- arrow-shooter
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'arrow-shooter')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'arrow-shooter')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,2]]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,3],[2,4],[3,5],[4,6]]', '2', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,10],[2,3],[4,5],[6,7]]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,1],[2,2],[3,3],[4,4],[5,5]]', '5', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[-1,5],[0,3],[2,8],[6,10]]', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,100],[50,150],[100,200]]', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,2],[3,4],[5,6],[7,8],[9,10]]', '5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'arrow-shooter'), '[[1,5],[2,6],[3,7],[4,8]]', '1', FALSE, 11);

-- ============================================================
-- balloon-popper
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balloon-popper')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'balloon-popper')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[5]', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[2,3]', '9', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[3,1,5]', '35', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[1,2,3,4]', '40', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[9,7,6,8]', '921', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[1,1,1,1,1]', '5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[10,1,10]', '210', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'balloon-popper'), '[5,4,3,2,1]', '110', FALSE, 11);

-- ============================================================
-- basic-binary-search
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'basic-binary-search')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'basic-binary-search')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[1]\n1', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[1]\n2', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[1,3,5,7,9,11,13]\n13', '6', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[1,3,5,7,9,11,13]\n1', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[1,3,5,7,9,11,13]\n7', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[2,4,6,8,10]\n5', '-1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[-10,-5,0,5,10,15,20]\n-10', '0', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[-10,-5,0,5,10,15,20]\n20', '6', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'basic-binary-search'), E'[1,2,3,4,5,6,7,8,9,10]\n6', '5', FALSE, 11);

-- ============================================================
-- bit-distance
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-distance')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-distance')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'0\n1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'255\n0', '8', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'7\n7', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'1\n2', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'100\n200', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'1023\n0', '10', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'2147483647\n2147483646', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'bit-distance'), E'123456\n654321', '8', FALSE, 11);

-- ============================================================
-- bit-tracker
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-tracker')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bit-tracker')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '3', '[0,1,1,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '7', '[0,1,1,2,1,2,2,3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '10', '[0,1,1,2,1,2,2,3,1,2,2]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '16', '[0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '20', '[0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '31', '[0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '50', '[0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'bit-tracker'), '100', '[0,1,1,2,1,2,2,3,1,2,2,3,2,3,3,4,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,1,2,2,3,2,3,3,4,2,3,3,4,3,4,4,5,2,3,3,4,3,4,4,5,3,4,4,5,4,5,5,6,2,3,3,4,3]', FALSE, 11);

-- ============================================================
-- bitwise-sum
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bitwise-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bitwise-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'100\n200', '300', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-1\n-1', '-2', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'999\n1', '1000', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-500\n500', '0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'0\n1000', '1000', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'123\n456', '579', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-999\n-1', '-1000', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'bitwise-sum'), E'-100\n50', '-50', FALSE, 11);

-- ============================================================
-- boat-loading
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'boat-loading')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'boat-loading')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[1]\n3', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[3,3,3,3]\n3', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[1,2,3,4,5]\n5', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[2,2,2,2,2,2]\n4', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[1,1,1,1,1,1,1]\n2', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[4,5,3,1,2]\n6', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[1,2,3,4,5,6,7,8,9,10]\n10', '6', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'boat-loading'), E'[5,5,5,5]\n10', '2', FALSE, 11);

-- ============================================================
-- border-capture
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'border-capture')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'border-capture')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["O"]]', '[["O"]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","X"],["X","X"]]', '[["X","X"],["X","X"]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["O","O","O"],["O","O","O"],["O","O","O"]]', '[["O","O","O"],["O","O","O"],["O","O","O"]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","X","X","X","X"],["X","O","O","O","X"],["X","X","X","O","X"],["X","O","O","O","X"],["X","X","X","X","X"]]', '[["X","X","X","X","X"],["X","X","X","X","X"],["X","X","X","X","X"],["X","X","X","X","X"],["X","X","X","X","X"]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["O","X","X","O"],["X","O","O","X"],["X","O","O","X"],["O","X","X","O"]]', '[["O","X","X","O"],["X","X","X","X"],["X","X","X","X"],["O","X","X","O"]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","O","X","O","X"],["O","X","O","X","O"],["X","O","X","O","X"],["O","X","O","X","O"]]', '[["X","O","X","O","X"],["O","X","X","X","O"],["X","X","X","X","X"],["O","X","O","X","O"]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["X","X","X"],["X","X","X"],["X","X","X"]]', '[["X","X","X"],["X","X","X"],["X","X","X"]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'border-capture'), '[["O","O","O","O"],["O","X","X","O"],["O","X","X","O"],["O","O","O","O"]]', '[["O","O","O","O"],["O","X","X","O"],["O","X","X","O"],["O","O","O","O"]]', FALSE, 11);

-- ============================================================
-- bracket-validator
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bracket-validator')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bracket-validator')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '{[]}', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '((()))', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), ']', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '([)]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '{', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '}{', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '((((((((((()))))))))))', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '[{()}]', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '(){}}{', 'false', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'bracket-validator'), '([]{})', 'true', FALSE, 13);
