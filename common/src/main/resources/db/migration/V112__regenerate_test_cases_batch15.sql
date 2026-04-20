-- =============================================================
-- Batch 15: Regenerate hidden test cases
-- Problems: room-checker, room-explorer, root-sum, rotate-grid,
--           rotated-array-min, rotting-oranges, running-median,
--           search-rotated-array, ship-capacity, shortest-cover
-- =============================================================

-------------------------------------------------------------
-- room-checker
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-checker')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-checker')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[5,10]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[0,5],[5,10],[10,15],[15,20]]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[1,3],[4,6],[7,9],[8,11]]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[1,5],[1,5],[1,5]]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[10,20],[1,5],[6,9]]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[0,1],[100,200],[300,400],[500,600],[1000,2000]]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[1,100],[2,3]]', 'false', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[0,10],[5,15],[20,25]]', 'false', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'room-checker'), '[[0,1],[1,2],[2,3],[3,4],[4,5],[5,6],[6,7],[7,8]]', 'true', FALSE, 13);

-------------------------------------------------------------
-- room-explorer
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-explorer')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'room-explorer')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1,2,3],[],[],[]]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[],[2],[]]', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1],[2],[0]]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1,2],[3],[3],[]]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[]]', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1],[]]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[],[0]]', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1,2,3,4],[],[],[],[]]', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1],[2],[3],[4],[5],[6],[7],[]]', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'room-explorer'), '[[1],[0],[3],[2]]', 'false', FALSE, 13);

-------------------------------------------------------------
-- root-sum
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'root-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'root-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[0]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,2,null,3]', '123', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,null,2,null,3]', '123', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,2,3,4,5,6,7]', '522', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[0,0,0]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[5,3,null,2,null,1]', '5321', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[3,9,8,null,null,6,7]', '812', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[9,1,2]', '183', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[1,0,1,0,1,0,1]', '422', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'root-sum'), '[2,null,3,null,4,null,5]', '2345', FALSE, 13);

-------------------------------------------------------------
-- rotate-grid
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotate-grid')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotate-grid')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1]]', '[[1]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1,2],[3,4]]', '[[3,1],[4,2]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1,0,0],[0,1,0],[0,0,1]]', '[[0,0,1],[0,1,0],[1,0,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1,2,3,4,5],[6,7,8,9,10],[11,12,13,14,15],[16,17,18,19,20],[21,22,23,24,25]]', '[[21,16,11,6,1],[22,17,12,7,2],[23,18,13,8,3],[24,19,14,9,4],[25,20,15,10,5]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[5,5],[5,5]]', '[[5,5],[5,5]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[-1,-2],[-3,-4]]', '[[-3,-1],[-4,-2]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[1,-2,3,-4],[5,-6,7,-8],[9,-10,11,-12],[13,-14,15,-16]]', '[[13,9,5,1],[-14,-10,-6,-2],[15,11,7,3],[-16,-12,-8,-4]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'rotate-grid'), '[[0,0,0],[0,0,0],[0,0,0]]', '[[0,0,0],[0,0,0],[0,0,0]]', FALSE, 10);

-------------------------------------------------------------
-- rotated-array-min
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotated-array-min')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotated-array-min')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[2,1]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[1,2,3,4,5]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[5,1,2,3,4]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[2,3,4,5,1]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[-3,-2,-1,0,1]', '-3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[7,8,9,10,1,2,3,4,5,6]', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[6,7,1,2,3,4,5]', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[1,2]', '1', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'rotated-array-min'), '[3,4,5,-5,-4,-3,-2,-1,0,1,2]', '-5', FALSE, 13);

-------------------------------------------------------------
-- rotting-oranges
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotting-oranges')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rotting-oranges')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[0]]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,2],[2,2]]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1]]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1,1,1,1]]', '4', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,0,1]]', '-1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1,1],[1,1,1],[1,1,1]]', '4', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1,1],[1,1,1],[1,1,2]]', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[1]]', '-1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[0,2,0],[0,0,0],[0,2,0]]', '0', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'rotting-oranges'), '[[2,1,0,1]]', '-1', FALSE, 13);

-------------------------------------------------------------
-- running-median
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'running-median')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","findMedian"]\n[[],[42],[]]', '[null,null,42.0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","findMedian"]\n[[],[5],[3],[1],[]]', '[null,null,null,null,3.0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","findMedian"]\n[[],[7],[7],[7],[]]', '[null,null,null,null,7.0]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","findMedian"]\n[[],[1],[2],[]]', '[null,null,null,1.5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","findMedian"]\n[[],[100000],[1],[50000],[]]', '[null,null,null,null,50000.0]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","addNum","findMedian"]\n[[],[-5],[-10],[-3],[]]', '[null,null,null,null,-5.0]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","findMedian","addNum","findMedian","addNum","findMedian","addNum","findMedian"]\n[[],[6],[],[3],[],[9],[],[1],[]]', '[null,null,6.0,null,4.5,null,6.0,null,4.5]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'running-median'), E'["MedianTracker","addNum","addNum","findMedian"]\n[[],[5],[5],[]]', '[null,null,null,5.0]', FALSE, 11);

-------------------------------------------------------------
-- search-rotated-array
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'search-rotated-array')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'search-rotated-array')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[5]\n5', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[5]\n3', '-1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[4,5,6,7,0,1,2]\n4', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[4,5,6,7,0,1,2]\n2', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[3,1]\n3', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[1,2,3,4,5]\n1', '0', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[6,7,8,9,1,2,3,4,5]\n3', '6', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[10,11,12,1,2,3,4,5,6,7,8,9]\n13', '-1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[3,4,5,6,7,1,2]\n1', '5', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'search-rotated-array'), E'[0,1,2,-5,-4,-3,-2,-1]\n-3', '5', FALSE, 13);

-------------------------------------------------------------
-- ship-capacity
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ship-capacity')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ship-capacity')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[10]\n1', '10', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,1,1,1,1]\n5', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,1,1,1,1]\n1', '5', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[500,500,500,500]\n2', '1000', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[7,2,5,10,8]\n2', '18', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[3,3,3,3]\n2', '6', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,2,3,4,5]\n1', '15', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[1,2,3,4,5]\n5', '5', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[100,1,1,1,1]\n2', '100', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'ship-capacity'), E'[10,8,6,4,2]\n3', '12', FALSE, 13);

-------------------------------------------------------------
-- shortest-cover
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-cover')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-cover')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,2,3,4,5]\n15', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[10]\n5', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,1,1]\n10', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,1,1,1,7]\n7', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[5,1,3,5,10,7,4,9,2,8]\n15', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[3,3,3,3,3]\n9', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,1,1,1,8,8]\n15', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[1,2,3,4,5,6,7,8,9,10]\n55', '10', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[4,2,1,5,3]\n5', '1', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'shortest-cover'), E'[10,2,3]\n10', '1', FALSE, 13);
