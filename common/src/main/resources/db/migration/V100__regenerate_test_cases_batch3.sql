-- ============================================================
-- V100: Regenerate hidden test cases for batch 3 problems
-- Problems: break-integer, bst-ancestor, bst-validator,
--           budget-flights, build-tree, car-convoy,
--           change-maker, character-swap, cheap-stairs,
--           cheapest-path
-- ============================================================

------------------------------------------------------------
-- break-integer
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'break-integer')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'break-integer')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '5', '6', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '6', '9', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '9', '27', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '11', '54', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '12', '81', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '15', '243', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '30', '59049', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '40', '2125764', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'break-integer'), '50', '86093442', FALSE, 12);

------------------------------------------------------------
-- bst-ancestor
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-ancestor')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-ancestor')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[20,10,30,5,15,25,35]\n5\n35', '20', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[20,10,30,5,15,25,35]\n5\n15', '10', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[20,10,30,5,15,25,35]\n25\n35', '30', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[20,10,30,5,15,25,35]\n10\n25', '20', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[6,2,8,0,4,7,9,null,null,3,5]\n0\n5', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[6,2,8,0,4,7,9,null,null,3,5]\n7\n9', '8', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[6,2,8,0,4,7,9,null,null,3,5]\n0\n8', '6', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[4,2]\n2\n4', '4', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'bst-ancestor'), E'[50,30,70,20,40,60,80,10,25,35,45,55,65,75,90]\n10\n45', '30', FALSE, 12);

------------------------------------------------------------
-- bst-validator
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-validator')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'bst-validator')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[10,5,15,3,7,12,20]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[10,5,15,null,null,6,20]', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[2147483647]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[0,-1]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[3,1,5,0,2,4,6]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[10,5,15,null,null,10,20]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[1,null,2,null,3,null,4]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[4,2,6,1,3,5,7]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'bst-validator'), '[120,70,140,50,100,130,160,20,55,75,110,null,null,150,200]', 'true', FALSE, 11);

------------------------------------------------------------
-- budget-flights
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'budget-flights')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'budget-flights')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'4\n[[0,1,1],[0,2,5],[1,2,1],[2,3,1]]\n0\n3\n1', '6', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'4\n[[0,1,1],[0,2,5],[1,2,1],[2,3,1]]\n0\n3\n0', '-1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'1\n[]\n0\n0\n0', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'5\n[[0,1,100],[0,2,500],[1,2,100],[2,3,100],[3,4,100]]\n0\n4\n3', '400', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'3\n[[0,1,100],[1,2,100],[0,2,300]]\n0\n2\n1', '200', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'4\n[[0,1,10],[1,2,10],[2,3,10],[0,3,100]]\n0\n3\n1', '100', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'6\n[[0,1,10],[1,2,10],[2,5,10],[0,3,1],[3,4,1],[4,5,1]]\n0\n5\n3', '3', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'budget-flights'), E'4\n[[0,1,1],[0,2,5],[1,2,1],[2,3,1]]\n0\n3\n2', '3', FALSE, 11);

------------------------------------------------------------
-- build-tree
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-tree')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'build-tree')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[1,2,4,5,3,6,7]\n[4,2,5,1,6,3,7]', '[1,2,3,4,5,6,7]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[1,2,3]\n[2,1,3]', '[1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[1,2,4,3,5]\n[4,2,1,3,5]', '[1,2,3,4,null,null,5]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[7,3,1,2,5,4,6]\n[1,3,2,7,4,5,6]', '[7,3,5,1,2,4,6]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[10,20,30]\n[20,10,30]', '[10,20,30]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[1,2]\n[1,2]', '[1,null,2]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[2,1]\n[2,1]', '[2,null,1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[5,10,20,15]\n[20,10,5,15]', '[5,10,15,20]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'build-tree'), E'[1,2,4,5,3]\n[4,2,5,1,3]', '[1,2,3,4,5]', FALSE, 11);

------------------------------------------------------------
-- car-convoy
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'car-convoy')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'car-convoy')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'30\n[0,10,20]\n[10,10,10]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'15\n[0,5,10,14]\n[5,4,3,1]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'100\n[0,50]\n[1,1]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'10\n[0,2,4,6,8]\n[5,4,3,2,1]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'20\n[5,15]\n[5,1]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'100\n[10,20,30]\n[30,20,10]', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'50\n[0,25,49]\n[50,25,1]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'car-convoy'), E'10\n[0,5,8]\n[10,5,2]', '1', FALSE, 11);

------------------------------------------------------------
-- change-maker
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'change-maker')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'change-maker')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'7\n[1,2,3]', '8', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'0\n[5]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'5\n[3,7]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'15\n[1,5,10]', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'20\n[1,2,5,10]', '40', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'50\n[1,2,5,10,25]', '406', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'3\n[5]', '0', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'change-maker'), E'100\n[3,7]', '5', FALSE, 11);

------------------------------------------------------------
-- character-swap
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'character-swap')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'character-swap')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'AAAA\n0', '4', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'ABCDE\n2', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'A\n0', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'AABABBA\n2', '5', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'BBBBBBA\n0', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'ABCABC\n3', '5', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'AAABBBCCC\n3', '6', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'ZZZZZ\n0', '5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'character-swap'), E'ABABABAB\n3', '7', FALSE, 11);

------------------------------------------------------------
-- cheap-stairs
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheap-stairs')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheap-stairs')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[10,15]', '10', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[1,2,3,4,5,6,7,8,9,10]', '25', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[100,1,100,1,100]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[0,0,0,0,0]', '0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[1,1,1,1,1,1,1,1,1,1]', '5', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[10,1,10,1,10,1]', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'cheap-stairs'), '[1000,1,1,1000,1,1,1000,1]', '5', FALSE, 10);

------------------------------------------------------------
-- cheapest-path
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheapest-path')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cheapest-path')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,1,1,1],[1,1,1,1],[1,1,1,1]]', '6', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,2],[3,4]]', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[100]]', '100', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,99,99,99],[1,1,99,99],[99,1,1,1]]', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1,2,3,4,5]]', '15', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[1],[2],[3],[4],[5]]', '15', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'cheapest-path'), '[[9,1,4,8],[2,3,6,1],[1,7,2,4]]', '24', FALSE, 10);
