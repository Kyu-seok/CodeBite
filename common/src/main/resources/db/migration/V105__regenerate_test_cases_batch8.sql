-- Regenerate hidden test cases for batch 8 problems
-- Problems: job-scheduler, joyful-number, jump-game-ii, k-closest-points,
--           k-distinct-window, k-most-frequent, koko-bananas, kth-largest-stream,
--           kth-smallest-bst, label-splitter

------------------------------------------------------------
-- job-scheduler
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'job-scheduler')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'job-scheduler')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A"]\n0', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","A","A","A","B","C","D","E","F","G"]\n2', '16', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","B","C","D","E","F"]\n2', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","B","B","C","C"]\n2', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","B","B","B","C","C","C"]\n2', '9', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","A","B","B","B","B"]\n3', '14', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","A","A"]\n1', '9', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","B"]\n5', '2', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","B","B","C"]\n1', '6', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'job-scheduler'), E'["A","A","A","A","A","A","B","C","D","E","F","G"]\n1', '12', FALSE, 13);

------------------------------------------------------------
-- joyful-number
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'joyful-number')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'joyful-number')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '7', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '4', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '10', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '13', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '89', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '23', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '11', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '44', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '3', 'false', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '100', 'true', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '116', 'false', FALSE, 14),
    ((SELECT id FROM problems WHERE slug = 'joyful-number'), '1000000', 'true', FALSE, 15);

------------------------------------------------------------
-- jump-game-ii
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'jump-game-ii')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'jump-game-ii')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1,2,3]', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1,1,1,1,1]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[5,1,1,1,1,1]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1,2,1,1,1]', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[10,9,8,7,6,5,4,3,2,1,1,0]', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[2,3,1,1,4,2,1]', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'jump-game-ii'), '[1,1]', '1', FALSE, 10);

------------------------------------------------------------
-- k-closest-points
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-closest-points')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-closest-points')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[0,0]]\n1', '[[0,0]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[1,1],[2,2],[3,3],[4,4]]\n2', '[[1,1],[2,2]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[1,0],[0,1],[-1,0],[0,-1]]\n4', '[[-1,0],[0,-1],[0,1],[1,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[-5,4],[3,2],[1,-1],[2,3],[-1,-1]]\n3', '[[-1,-1],[1,-1],[3,2]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[10,10],[-10,-10],[5,5]]\n1', '[[5,5]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[0,1],[0,2],[0,3],[0,4],[0,5]]\n3', '[[0,1],[0,2],[0,3]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[1,1],[-1,-1],[2,2],[-2,-2]]\n2', '[[-1,-1],[1,1]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'k-closest-points'), E'[[3,4],[5,12],[0,1]]\n2', '[[0,1],[3,4]]', FALSE, 10);

------------------------------------------------------------
-- k-distinct-window
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-distinct-window')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-distinct-window')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'a\n1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abcabcabc\n3', '9', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'aabbcc\n1', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abcdef\n6', '6', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abcdef\n3', '3', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'aaabbbccc\n2', '6', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'eceba\n2', '3', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'abaccc\n2', '4', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'k-distinct-window'), E'aaaaaaaaaa\n1', '10', FALSE, 12);

------------------------------------------------------------
-- k-most-frequent
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-most-frequent')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'k-most-frequent')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[1,2,3,4,5]\n5', '[1,2,3,4,5]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[3,3,3,3,1,1,2,2,2]\n2', '[2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[5,5,5,5,5]\n1', '[5]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[1,2,2,3,3,3,4,4,4,4]\n3', '[2,3,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[-1,-1,0,0,0,2]\n2', '[-1,0]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[1,1,2,2,3,3]\n3', '[1,2,3]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[7,7,7,8,8,9]\n1', '[7]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'k-most-frequent'), E'[10,20,30,10,20,10]\n2', '[10,20]', FALSE, 10);

------------------------------------------------------------
-- koko-bananas
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'koko-bananas')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'koko-bananas')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[1]\n1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[1000000000]\n2', '500000000', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[2,2]\n2', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[1,1,1,1]\n4', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[312884470]\n312884469', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[10,15,20]\n7', '8', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[1,1,1,1,1,1,1,1]\n8', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[100]\n1', '100', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[5,10,15,20,25]\n8', '13', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'koko-bananas'), E'[3,6,7,11]\n4', '11', FALSE, 13);

------------------------------------------------------------
-- kth-largest-stream
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-largest-stream')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-largest-stream')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add","add","add"]\n[[1,[]],[1],[2],[3],[4],[5]]', '[null,1,2,3,4,5]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add"]\n[[3,[1,2,3,4,5]],[6],[7],[8]]', '[null,4,5,6]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add"]\n[[1,[1]],[1]]', '[null,1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add","add"]\n[[2,[3,1]],[2],[4],[5],[0]]', '[null,2,3,4,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add","add","add","add"]\n[[3,[]],[5],[1],[3],[2],[4],[6]]', '[null,5,1,1,2,3,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add"]\n[[1,[-1,-2,-3]],[0],[1],[2]]', '[null,0,1,2]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add","add"]\n[[4,[7,7,7,7,8,3]],[2],[10],[9],[9]]', '[null,7,7,7,8]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add","add","add","add"]\n[[2,[0,0,0]],[1],[2],[3],[4],[5]]', '[null,0,1,2,3,4]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'kth-largest-stream'), E'["KthLargest","add","add"]\n[[1,[5,5,5]],[5],[6]]', '[null,5,6]', FALSE, 10);

------------------------------------------------------------
-- kth-smallest-bst
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-smallest-bst')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'kth-smallest-bst')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[1]\n1', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[2,1,3]\n2', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[3,1,4,null,2]\n4', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[6,2,8,0,4,7,9,null,null,3,5]\n5', '5', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[6,2,8,0,4,7,9,null,null,3,5]\n1', '0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[6,2,8,0,4,7,9,null,null,3,5]\n9', '9', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[10,5,15,3,7,12,20]\n4', '10', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[10,5,15,3,7,12,20]\n7', '20', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[4,2,6,1,3,5,7]\n4', '4', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'kth-smallest-bst'), E'[50,30,70,20,40,60,80]\n3', '40', FALSE, 12);

------------------------------------------------------------
-- label-splitter
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-splitter')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'label-splitter')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'ababcbacadefegdehijhklij', '[9,7,8]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'a', '[1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'aaaaaa', '[6]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'abcdefghij', '[1,1,1,1,1,1,1,1,1,1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'eccbbbbdec', '[10]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'abcabc', '[6]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'aabbbccc', '[2,3,3]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'caedbdedda', '[1,9]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'abacbcdedf', '[6,3,1]', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'label-splitter'), 'zxyzw', '[4,1]', FALSE, 13);
