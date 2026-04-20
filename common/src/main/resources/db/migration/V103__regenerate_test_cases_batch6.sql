-- Regenerate hidden test cases for Batch 6 problems
-- Problems: flatten-tree, flexible-brackets, flip-bits, frequent-words, fruit-picker,
--           gas-station, gate-distance, good-node-count, graph-copy, hand-grouping

------------------------------------------------------------
-- flatten-tree (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flatten-tree')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flatten-tree')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,null,2,3]', '[1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,2,null,3,4]', '[1,2,3,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,null,2,null,3,null,4]', '[1,2,3,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[10,5,15,3,7,12,20]', '[10,5,3,7,15,12,20]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,2,3]', '[1,2,3]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[1,null,2]', '[1,2]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[2,1,3,null,null,null,4]', '[2,1,3,4]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'flatten-tree'), '[100,-50,200,-100,null,150,300]', '[100,-50,-100,200,150,300]', FALSE, 11);

------------------------------------------------------------
-- flexible-brackets (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flexible-brackets')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flexible-brackets')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '()', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '((*)', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(*)(', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(*()*', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '((*))', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), ')*', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(*', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '((((*)', 'false', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '()**()', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '((()))*)', 'true', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'flexible-brackets'), '(()*()*())', 'true', FALSE, 14);

------------------------------------------------------------
-- flip-bits (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-bits')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'flip-bits')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '2', '1073741824', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '3', '3221225472', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '256', '8388608', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '2147483648', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '4294967294', '2147483647', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '1431655765', '2863311530', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '10', '1342177280', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'flip-bits'), '255', '4278190080', FALSE, 11);

------------------------------------------------------------
-- frequent-words (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'frequent-words')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'frequent-words')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["a"]\n1', '["a"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["z","z","a","a","b"]\n2', '["a","z"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["one","two","three","one","two","one"]\n2', '["one","two"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["cat","dog","cat","dog","bird","bird","cat"]\n3', '["cat","bird","dog"]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["x","y","z"]\n3', '["x","y","z"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["aaa","bbb","aaa","ccc","bbb","aaa","bbb"]\n1', '["aaa"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["same","same","same"]\n1', '["same"]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'frequent-words'), E'["b","a","c","a","b","d"]\n4', '["a","b","c","d"]', FALSE, 11);

------------------------------------------------------------
-- fruit-picker (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fruit-picker')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fruit-picker')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,1,1,1,1]', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,2,3,2,2]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,2,3,4,5,6]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[4,4,4,3,3,4,4]', '7', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,2]', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[1,1,2,2,3,3,4,4]', '4', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'fruit-picker'), '[10,10,20,10,20,30]', '5', FALSE, 11);

------------------------------------------------------------
-- gas-station (2 samples, hidden starts at order_index 3)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gas-station')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gas-station')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[5]\n[4]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[1,1,1]\n[2,2,2]', '-1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[3,1,1]\n[1,1,3]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[0,0,0,0]\n[0,0,0,0]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[4,5,2,6,5,3]\n[3,2,7,3,2,9]', '-1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[10,0,0,0]\n[1,1,1,1]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[1,2,3,4,5,6]\n[2,3,4,5,6,1]', '5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'gas-station'), E'[5,8,2,8]\n[6,5,6,6]', '3', FALSE, 10);

------------------------------------------------------------
-- gate-distance (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gate-distance')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'gate-distance')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0,2147483647,2147483647,0]]', '[[0,1,1,0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0],[2147483647],[2147483647],[-1]]', '[[0],[1],[2],[-1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[-1]]', '[[-1]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[2147483647,2147483647],[2147483647,0]]', '[[2,1],[1,0]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0,-1,2147483647],[2147483647,-1,2147483647],[2147483647,2147483647,0]]', '[[0,-1,2],[1,-1,1],[2,1,0]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[0,2147483647,-1,0],[2147483647,2147483647,-1,2147483647],[2147483647,2147483647,2147483647,2147483647]]', '[[0,1,-1,0],[1,2,-1,1],[2,3,3,2]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[2147483647,0,2147483647],[0,2147483647,0],[2147483647,0,2147483647]]', '[[1,0,1],[0,1,0],[1,0,1]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'gate-distance'), '[[2147483647,2147483647,2147483647],[2147483647,2147483647,2147483647],[2147483647,2147483647,2147483647]]', '[[2147483647,2147483647,2147483647],[2147483647,2147483647,2147483647],[2147483647,2147483647,2147483647]]', FALSE, 11);

------------------------------------------------------------
-- good-node-count (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'good-node-count')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'good-node-count')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[10,5,15,3,7,13,20]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[1,1,1,1,1,1,1]', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[5,3,8,2,4,6,10,1]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[10]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[10,null,10,null,10]', '3', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[1,2,3,null,null,4,5]', '5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[-1,-2,-3]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'good-node-count'), '[3,1,4,3,null,1,5,null,null,null,null,null,null,6]', '4', FALSE, 11);

------------------------------------------------------------
-- graph-copy (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'graph-copy')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'graph-copy')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[]]', '[[]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[]', '[]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[2],[1]]', '[[2],[1]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[2,3],[1,3],[1,2]]', '[[2,3],[1,3],[1,2]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[2,3,4],[1],[1],[1]]', '[[2,3,4],[1],[1],[1]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[2],[1,3],[2,4],[3,5],[4]]', '[[2],[1,3],[2,4],[3,5],[4]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[2,5],[1,3],[2,4],[3,5],[4,1]]', '[[2,5],[1,3],[2,4],[3,5],[4,1]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'graph-copy'), '[[3],[3],[1,2]]', '[[3],[3],[1,2]]', FALSE, 11);

------------------------------------------------------------
-- hand-grouping (3 samples, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hand-grouping')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hand-grouping')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,3]\n3', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,3,4]\n2', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,3,5,7]\n2', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,3,4,5,6,7,8,9]\n3', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,2,4,5,6,7]\n3', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[2,2,2,3,3,3,4,4,4]\n3', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[1,1,1,2,2,3]\n3', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'hand-grouping'), E'[5,5,6,6,7,7,8,8]\n4', 'true', FALSE, 11);
