-- =============================================
-- Batch 7: Regenerate hidden test cases
-- Problems: hash-table, height-check, height-queue, house-thief,
--           house-thief-ii, identical-trees, increment-digits,
--           insert-interval, ip-builder, island-counter
-- =============================================

-- hash-table (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'hash-table')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","get","put","get","remove","get"]\n[[],[0,0],[0],[0,999999],[0],[0],[0]]', '[null,null,0,null,999999,null,-1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","remove","get","get","put","get"]\n[[],[1,1],[2,2],[3,3],[2],[1],[2],[1,100],[1]]', '[null,null,null,null,null,1,-1,null,100]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","put","get","get","get","get","remove","remove","get","get"]\n[[],[100,1],[200,2],[300,3],[400,4],[100],[200],[300],[400],[200],[400],[200],[400]]', '[null,null,null,null,null,1,2,3,4,null,null,-1,-1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","get","remove","get","put","get"]\n[[],[1000,1],[1000,2],[1000],[1000],[1000],[1000,3],[1000]]', '[null,null,null,2,null,-1,null,3]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","put","put","get","get","get","get","get"]\n[[],[1,10],[2,20],[3,30],[4,40],[5,50],[1],[2],[3],[4],[5]]', '[null,null,null,null,null,null,10,20,30,40,50]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","remove","get","put","get","remove","get"]\n[[],[1],[1],[1,42],[1],[1],[1]]', '[null,null,-1,null,42,null,-1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","put","put","get","get","get","remove","remove","remove","get","get","get"]\n[[],[10,100],[20,200],[30,300],[10],[20],[30],[10],[20],[30],[10],[20],[30]]', '[null,null,null,null,100,200,300,null,null,null,-1,-1,-1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'hash-table'), E'["SimpleHashMap","put","get","put","get","put","get"]\n[[],[999999,1],[999999],[0,999999],[0],[500000,500000],[500000]]', '[null,null,1,null,999999,null,500000]', FALSE, 11);

-- height-check (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-check')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-check')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,3,4,5,6,null,8]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,null,3,null,4,null]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,2,3,null,null,3,4,null,null,4]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,null,2,null,3]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[5,3,8,1,4,7,9]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'height-check'), '[1,2,3,null,null,null,null]', 'true', FALSE, 11);

-- height-queue (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-queue')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'height-queue')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[5,0]]', '[[5,0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[9,0],[7,0],[1,2],[3,1],[2,3],[5,1]]', '[[7,0],[3,1],[1,2],[5,1],[2,3],[9,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[2,0],[1,0],[3,0],[4,0]]', '[[1,0],[2,0],[3,0],[4,0]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[1,0],[1,1],[1,2]]', '[[1,0],[1,1],[1,2]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[8,0],[6,0],[4,0],[2,0],[7,1],[5,2],[3,3],[1,4]]', '[[2,0],[4,0],[6,0],[8,0],[1,4],[3,3],[5,2],[7,1]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[10,0],[9,0],[8,0],[7,0],[6,0]]', '[[6,0],[7,0],[8,0],[9,0],[10,0]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[5,0],[5,1],[5,2],[6,0]]', '[[5,0],[5,1],[5,2],[6,0]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'height-queue'), '[[7,0],[7,1],[6,0],[6,1],[5,0],[5,1]]', '[[5,0],[5,1],[6,0],[6,1],[7,0],[7,1]]', FALSE, 11);

-- house-thief (2 samples, order_index 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[0]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[2,1,1,2]', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[100]', '100', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[1,2]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[2,1]', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[1,3,1,3,100]', '103', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[10,1,1,10,1,1,10]', '30', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[0,0,0,0,0]', '0', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'house-thief'), '[100,1,100,1,100]', '300', FALSE, 11);

-- house-thief-ii (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief-ii')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'house-thief-ii')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[200,3,140,20,10]', '340', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[1,2]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[1,1,1,1]', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[6,6,4,8,4,3,3,10]', '27', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[0,0,0,0,0]', '0', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[100,50,100,50,100]', '200', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'house-thief-ii'), '[10,1,10,1,10,1]', '30', FALSE, 11);

-- identical-trees (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'identical-trees')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'identical-trees')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[]\n[]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[1]\n[1]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[1]\n[2]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[]\n[1]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[1,2,3,4,5]\n[1,2,3,4,5]', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[1,2,3,4,5]\n[1,2,3,4,6]', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[1,null,2,null,3]\n[1,null,2,null,3]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'identical-trees'), E'[1,2]\n[1,null,2]', 'false', FALSE, 11);

-- increment-digits (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'increment-digits')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'increment-digits')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[4,3,2,1]', '[4,3,2,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[9,9,9,9]', '[1,0,0,0,0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[1,0,9]', '[1,1,0]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[9]', '[1,0]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[1,0,0,0]', '[1,0,0,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[8,9,9,9]', '[9,0,0,0]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[2,9]', '[3,0]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'increment-digits'), '[5,0,0,0,0]', '[5,0,0,0,1]', FALSE, 11);

-- insert-interval (2 samples, order_index 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'insert-interval')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'insert-interval')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[]\n[5,7]', '[[5,7]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,5]]\n[2,3]', '[[1,5]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,5]]\n[6,8]', '[[1,5],[6,8]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[3,5],[6,9]]\n[1,2]', '[[1,2],[3,5],[6,9]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,2],[3,5],[6,7],[8,10],[12,16]]\n[0,20]', '[[0,20]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,3],[4,6],[7,9]]\n[2,8]', '[[1,9]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,2]]\n[0,0]', '[[0,0],[1,2]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,2],[5,6],[9,10]]\n[3,4]', '[[1,2],[3,4],[5,6],[9,10]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'insert-interval'), E'[[1,3],[6,9]]\n[4,5]', '[[1,3],[4,5],[6,9]]', FALSE, 11);

-- ip-builder (3 samples, order_index 1-3)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ip-builder')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'ip-builder')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '1111', '["1.1.1.1"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '010010', '["0.10.0.10","0.100.1.0"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '256256256256', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '12', '[]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '11111111', '["1.1.111.111","1.11.11.111","1.11.111.11","1.111.1.111","1.111.11.11","1.111.111.1","11.1.11.111","11.1.111.11","11.11.1.111","11.11.11.11","11.11.111.1","11.111.1.11","11.111.11.1","111.1.1.111","111.1.11.11","111.1.111.1","111.11.1.11","111.11.11.1","111.111.1.1"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '000', '[]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '111111111111', '["111.111.111.111"]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'ip-builder'), '19216811', '["1.92.168.11","19.2.168.11","19.21.68.11","19.216.8.11","19.216.81.1","192.1.68.11","192.16.8.11","192.16.81.1","192.168.1.1"]', FALSE, 11);

-- island-counter (2 samples, order_index 1-2)
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'island-counter')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'island-counter')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1"]]', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["0","0"],["0","0"]]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["0"]]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","0","1","0","1"]]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","1","1"],["0","0","0"],["1","1","1"]]', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","0","0","0"],["0","0","0","0"],["0","0","0","0"],["0","0","0","1"]]', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","1","0","0","0"],["1","0","0","0","1"],["0","0","0","1","1"]]', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","0","1"],["0","1","0"],["1","0","1"]]', '5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'island-counter'), '[["1","1","1","1"],["1","1","1","1"],["1","1","1","1"]]', '1', FALSE, 11);
