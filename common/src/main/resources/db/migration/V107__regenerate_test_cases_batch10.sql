-- Regenerate hidden test cases for batch 10 problems
-- Problems: longest-streak, matrix-search, matrix-search-ii, max-path-sum,
--           max-product-subarray, meeting-rooms, merge-k-lists, merge-sorted-lists,
--           minimum-stack, mirror-number

------------------------------------------------------------
-- longest-streak
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-streak')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'longest-streak')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[1,2,0,1]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[9,1,4,7,3,-1,0,5,8,-1,6]', '7', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[1,1,1,1]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[10,5,12,3,55,30,22]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[100,101,102,103,104]', '5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'longest-streak'), '[1,3,5,7,9,2,4,6,8,10]', '10', FALSE, 10);

------------------------------------------------------------
-- matrix-search
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1]]\n1', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1]]\n2', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1,3]]\n3', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1,3,5,7],[10,11,16,20],[23,30,34,60]]\n60', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1,3,5,7],[10,11,16,20],[23,30,34,60]]\n1', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1,3,5,7],[10,11,16,20],[23,30,34,60]]\n11', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1,3,5,7],[10,11,16,20],[23,30,34,60]]\n15', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'matrix-search'), E'[[1,2,3],[4,5,6],[7,8,9]]\n9', 'true', FALSE, 10);

------------------------------------------------------------
-- matrix-search-ii
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search-ii')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'matrix-search-ii')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1]]\n1', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1]]\n2', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15],[16,17,18,19,20],[21,22,23,24,25]]\n15', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,3,5],[2,4,6],[3,5,7]]\n0', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]\n30', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]\n18', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]\n25', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'matrix-search-ii'), E'[[1,2],[3,4]]\n0', 'false', FALSE, 11);

------------------------------------------------------------
-- max-path-sum
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-path-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-path-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[2,-1]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[-3]', '-3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[5,4,8,11,null,13,4,7,2,null,null,null,1]', '48', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[1,2,3,4,5]', '11', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[-1,-2,-3]', '-1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[1,-2,3]', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[10,2,10,20,1,null,-25,null,null,null,null,3,4]', '42', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'max-path-sum'), '[1,null,2,null,3,null,4,null,5]', '15', FALSE, 10);

------------------------------------------------------------
-- max-product-subarray
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-product-subarray')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'max-product-subarray')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-2,3,-4]', '24', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[0,2]', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-2]', '-2', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[2,-5,-2,-4,3]', '24', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[1,2,3,4]', '24', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[0,0,0]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-1,-2,-3,-4]', '24', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'max-product-subarray'), '[-3,0,1,-2]', '1', FALSE, 10);

------------------------------------------------------------
-- meeting-rooms
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'meeting-rooms')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'meeting-rooms')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[1,5],[2,3],[3,4],[4,6]]', '2', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[0,1],[1,2],[2,3]]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[1,10],[2,7],[3,19],[8,12],[10,20],[11,30]]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[5,8],[6,8]]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[]', '0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[1,2]]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[1,3],[2,6],[8,10],[15,18]]', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'meeting-rooms'), '[[0,5],[0,5],[0,5]]', '3', FALSE, 10);

------------------------------------------------------------
-- merge-k-lists
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-k-lists')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-k-lists')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[1],[2],[3]]', '[1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[5,10],[1,2,3],[4,6,8]]', '[1,2,3,4,5,6,8,10]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[],[],[]]', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[1,2,3]]', '[1,2,3]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[-5,0,5],[-3,1,4]]', '[-5,-3,0,1,4,5]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[1,1,1],[1,1,1]]', '[1,1,1,1,1,1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[2,4,6],[1,3,5],[0,7,8,9]]', '[0,1,2,3,4,5,6,7,8,9]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'merge-k-lists'), '[[100],[1,50],[25,75]]', '[1,25,50,75,100]', FALSE, 11);

------------------------------------------------------------
-- merge-sorted-lists
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-sorted-lists')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'merge-sorted-lists')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[1]\n[2]', '[1,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[5]\n[1,2,4]', '[1,2,4,5]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[1,3,5,7]\n[2,4,6,8]', '[1,2,3,4,5,6,7,8]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[-3,-1,0]\n[-2,2,4]', '[-3,-2,-1,0,2,4]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[1,1,1]\n[1,1,1]', '[1,1,1,1,1,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[1,2,3]\n[]', '[1,2,3]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[]\n[1]', '[1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'merge-sorted-lists'), E'[10]\n[10]', '[10,10]', FALSE, 11);

------------------------------------------------------------
-- minimum-stack
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'minimum-stack')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'minimum-stack')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","getMin","top","pop","getMin"]\n[[],[1],[2],[],[],[],[]]', '[null,null,null,1,2,null,1]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","push","top","getMin","pop","getMin"]\n[[],[3],[1],[2],[],[],[],[]]', '[null,null,null,null,2,1,null,1]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","getMin","push","getMin","push","getMin","pop","getMin","pop","getMin"]\n[[],[5],[],[3],[],[7],[],[],[],[],[]]', '[null,null,5,null,3,null,3,null,3,null,5]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","push","push","getMin","pop","getMin","pop","getMin"]\n[[],[2],[0],[3],[0],[],[],[],[],[]]', '[null,null,null,null,null,0,null,0,null,0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","push","pop","top","getMin"]\n[[],[-1],[0],[-2],[],[],[]]', '[null,null,null,null,null,0,-1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","pop","push","getMin"]\n[[],[10],[20],[],[5],[]]', '[null,null,null,null,null,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","push","push","push","getMin","pop","pop","pop","getMin"]\n[[],[1],[2],[3],[4],[5],[],[],[],[],[]]', '[null,null,null,null,null,null,1,null,null,null,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","getMin","top"]\n[[],[42],[],[]]', '[null,null,42,42]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'minimum-stack'), E'["MinStack","push","push","push","getMin","pop","getMin","pop","getMin"]\n[[],[-1],[-1],[-1],[],[],[],[],[]]', '[null,null,null,null,-1,null,-1,null,-1]', FALSE, 10);

------------------------------------------------------------
-- mirror-number
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-number')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'mirror-number')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '0', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '1234321', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '12321', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '1000021', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '11', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '-121', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '1', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '9', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '100', 'false', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'mirror-number'), '12344321', 'true', FALSE, 13);
