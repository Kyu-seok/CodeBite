-- =============================================
-- Batch 16: Regenerate hidden test cases
-- Problems: shortest-grid-path, sign-assignments, signal-time,
--           smallest-window, sorted-median, sorted-pair-sum,
--           sorted-squares, space-rocks, spiral-matrix, stack-queue
-- =============================================

-- shortest-grid-path (3 sample tests, order 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-grid-path')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'shortest-grid-path')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0,0],[0,0,0],[0,0,0]]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0,0,0],[0,1,1,0],[0,1,1,0],[0,0,0,0]]', '6', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,1,0],[1,0,1],[0,1,0]]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0],[0,0]]', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,1,1,1,1],[0,0,1,1,1],[1,0,0,1,1],[1,1,0,0,1],[1,1,1,0,0]]', '5', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[1,0],[0,0]]', '-1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,0,1],[1,0,1],[1,1,0]]', '3', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'shortest-grid-path'), '[[0,1,1,0],[0,1,0,0],[0,0,0,1],[1,1,0,0]]', '5', FALSE, 11);

-- sign-assignments (3 sample tests, order 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sign-assignments')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sign-assignments')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[0,0,0,0,0]\n0', '32', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,3,4,5]\n3', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,1,1]\n1', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[5]\n5', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,3,4,5]\n15', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,1,1,1,1]\n5', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,1]\n2', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,1,1,1]\n0', '6', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[2,2,2]\n6', '1', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'sign-assignments'), E'[1,2,3]\n7', '0', FALSE, 13);

-- signal-time (3 sample tests, order 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'signal-time')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'signal-time')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1],[2,1,1]]\n2\n1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[]\n1\n1', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,5],[1,3,2],[3,2,1]]\n3\n1', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1],[2,3,2],[3,4,3],[4,5,4]]\n5\n1', '10', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1],[1,3,1],[2,4,1],[3,4,1]]\n4\n1', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,10],[1,3,1],[3,2,1]]\n3\n1', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,1],[3,4,1]]\n4\n1', '-1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'signal-time'), E'[[1,2,3],[2,3,4],[3,1,5]]\n3\n1', '7', FALSE, 11);

-- smallest-window (2 sample tests, order 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-window')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'smallest-window')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'a\naa', '', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'abcdef\nxyz', '', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'aaaaaaa\na', 'a', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'ab\nb', 'b', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'abcda\nad', 'da', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'bba\nab', 'ba', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'cabwefgewcwaefgcf\ncae', 'cwae', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'aa\naa', 'aa', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'bdab\nab', 'ab', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'smallest-window'), E'ADOBECODEBANC\nABC', 'BANC', FALSE, 12);

-- sorted-median (3 sample tests, order 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-median')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-median')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1]\n[1]', '1.0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,2,3]\n[]', '2.0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[]\n[1,2,3,4]', '2.5', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,1,1]\n[1,1,1]', '1.0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[100]\n[200]', '150.0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[-5,-3,-1]\n[0,2,4]', '-0.5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1,2]\n[1,2]', '1.5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'sorted-median'), E'[1]\n[2,3,4,5,6]', '3.5', FALSE, 11);

-- sorted-pair-sum (2 sample tests, order 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-pair-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-pair-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[-1,0]\n-1', '[1,2]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[1,2,3,4,5,6,7,8,9,10]\n19', '[9,10]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[1,2,3,4,4,9,56,90]\n8', '[4,5]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[5,25,75]\n100', '[2,3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[1,3,5,7,9]\n10', '[1,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[0,0,3,4]\n0', '[1,2]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[-3,-1,0,2,5]\n4', '[2,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'sorted-pair-sum'), E'[1,2,3,4,5]\n9', '[4,5]', FALSE, 10);

-- sorted-squares (3 sample tests, order 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-squares')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'sorted-squares')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[0]', '[0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-1]', '[1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-10,-5,0,5,10]', '[0,25,25,100,100]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[1]', '[1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-3,-2,-1,0,1,2,3]', '[0,1,1,4,4,9,9]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-100,100]', '[10000,10000]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-2,-1,0,1,2,3,4]', '[0,1,1,4,4,9,16]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'sorted-squares'), '[-10,-9,-8,-7]', '[49,64,81,100]', FALSE, 11);

-- space-rocks (3 sample tests, order 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-rocks')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'space-rocks')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[1,2,3]', '[1,2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[-1,-2,-3]', '[-1,-2,-3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[5,-5,5,-5]', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[1,-2,3,-4]', '[-2,-4]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[10,-1,-2,-3]', '[10]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[-1,1]', '[-1,1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[3,5,-3,-5]', '[3]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[1,2,-1]', '[1,2]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[-3,3,-3]', '[-3]', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'space-rocks'), '[5,-10,10,-5]', '[-10,10]', FALSE, 13);

-- spiral-matrix (2 sample tests, order 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spiral-matrix')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'spiral-matrix')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2,3,4]]', '[1,2,3,4]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1],[2],[3],[4]]', '[1,2,3,4]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2],[3,4],[5,6]]', '[1,2,4,6,5,3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2,3],[4,5,6]]', '[1,2,3,6,5,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]]', '[1,2,3,4,8,12,16,15,14,13,9,5,6,7,11,10]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[-1,-2],[-3,-4]]', '[-1,-2,-4,-3]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[1,2,3,4,5]]', '[1,2,3,4,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'spiral-matrix'), '[[7]]', '[7]', FALSE, 10);

-- stack-queue (2 sample tests, order 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stack-queue')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'stack-queue')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","pop"]\n[[],[42],[]]', '[null,null,42]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","empty","push","empty","pop","empty"]\n[[],[],[1],[],[],[]]', '[null,true,null,false,1,true]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","push","push","pop","pop","pop"]\n[[],[1],[2],[3],[],[],[]]', '[null,null,null,null,1,2,3]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","peek","push","peek","pop","peek"]\n[[],[5],[],[10],[],[],[]]', '[null,null,5,null,5,5,10]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","push","pop","push","pop","pop"]\n[[],[1],[2],[],[3],[],[]]', '[null,null,null,1,null,2,3]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","push","push","push","pop","pop","pop","pop","empty"]\n[[],[10],[20],[30],[40],[],[],[],[],[]]', '[null,null,null,null,null,10,20,30,40,true]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","pop","push","pop","push","pop"]\n[[],[100],[],[200],[],[300],[]]', '[null,null,100,null,200,null,300]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'stack-queue'), E'["StackQueue","push","push","peek","pop","push","peek","pop","pop","empty"]\n[[],[1],[2],[],[],[3],[],[],[],[]]', '[null,null,null,1,1,null,2,2,3,true]', FALSE, 10);
