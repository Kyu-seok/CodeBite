-- Batch 4: Regenerate hidden test cases for 10 problems
-- Problems: click-counter, coin-picker, color-sort, connected-components,
--           copy-random-list, count-bits, course-order, course-planner,
--           cycle-detection, decode-ways
-- All test cases validated against Judge0 (Python, language_id=71)

------------------------------------------------------------
-- click-counter (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'click-counter')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","getHits"]\n[[],[1],[1]]', '[null,null,1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","hit","getHits"]\n[[],[5],[5],[5],[5],[5]]', '[null,null,null,null,null,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","getHits","getHits"]\n[[],[1],[2],[300],[301]]', '[null,null,null,2,1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","getHits"]\n[[],[100]]', '[null,0]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","getHits","hit","getHits"]\n[[],[1],[1000],[1001],[1001]]', '[null,null,0,null,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","hit","hit","hit","getHits","getHits"]\n[[],[1],[2],[3],[100],[200],[300],[300],[301]]', '[null,null,null,null,null,null,null,6,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","getHits","getHits","getHits"]\n[[],[1],[150],[299],[299],[300],[301]]', '[null,null,null,null,3,3,2]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'click-counter'), E'["HitCounter","hit","hit","hit","getHits"]\n[[],[1],[2],[3],[500]]', '[null,null,null,null,0]', FALSE, 11);

------------------------------------------------------------
-- coin-picker (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'coin-picker')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'coin-picker')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[1]\n1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[1]\n100', '100', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[5,10,25]\n30', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[3,7]\n11', '-1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[2]\n1', '-1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[1,3,4]\n6', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[2,5,10,1]\n27', '4', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[7,13]\n91', '7', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'coin-picker'), E'[1,2,5]\n100', '20', FALSE, 12);

------------------------------------------------------------
-- color-sort (2 sample test cases, hidden starts at order_index 3)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'color-sort')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'color-sort')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[0,0,0]', '[0,0,0]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[2,2,2]', '[2,2,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[1,1,1]', '[1,1,1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[1,0]', '[0,1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[2,1,0]', '[0,1,2]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[0,1,2,0,1,2,0,1,2]', '[0,0,0,1,1,1,2,2,2]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[2,2,1,1,0,0]', '[0,0,1,1,2,2]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'color-sort'), '[0,2,0,2,1,1,0,2]', '[0,0,0,1,1,2,2,2]', FALSE, 10);

------------------------------------------------------------
-- connected-components (2 sample test cases, hidden starts at order_index 3)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'connected-components')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'connected-components')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'1\n[]', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'3\n[[0,1]]', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'6\n[[0,1],[2,3],[4,5]]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'4\n[[0,1],[1,2],[2,3],[0,3]]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'7\n[[0,1],[1,2],[3,4],[5,6]]', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'3\n[[0,1],[1,2],[0,2]]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'10\n[]', '10', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'connected-components'), E'5\n[[0,1],[0,2],[0,3],[0,4]]', '1', FALSE, 10);

------------------------------------------------------------
-- copy-random-list (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'copy-random-list')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'copy-random-list')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,null]]', '[[1,null]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[5,0]]', '[[5,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,1],[2,0]]', '[[1,1],[2,0]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,null],[2,null],[3,null]]', '[[1,null],[2,null],[3,null]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[10,null],[20,0],[30,1],[40,3]]', '[[10,null],[20,0],[30,1],[40,3]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,0],[2,1],[3,2],[4,3],[5,4]]', '[[1,0],[2,1],[3,2],[4,3],[5,4]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[100,null],[200,null],[300,0]]', '[[100,null],[200,null],[300,0]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'copy-random-list'), '[[1,2],[2,2],[3,null]]', '[[1,2],[2,2],[3,null]]', FALSE, 11);

------------------------------------------------------------
-- count-bits (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-bits')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'count-bits')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '0', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '1', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '2', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '7', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '1023', '10', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '2147483648', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '4294967295', '32', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '16', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'count-bits'), '1431655765', '16', FALSE, 12);

------------------------------------------------------------
-- course-order (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-order')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-order')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'3\n[]', '[0,1,2]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'2\n[[0,1]]', '[1,0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'3\n[[1,0],[2,1]]', '[0,1,2]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'3\n[[0,1],[1,2],[2,0]]', '[]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'4\n[[1,0],[2,1],[3,2]]', '[0,1,2,3]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'5\n[[1,0],[2,0],[3,1],[4,2]]', '[0,1,2,3,4]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'6\n[[1,0],[2,0],[3,1],[3,2],[4,3],[5,3]]', '[0,1,2,3,4,5]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'course-order'), E'4\n[[1,0],[2,0],[3,1],[3,2],[1,2]]', '[0,2,1,3]', FALSE, 11);

------------------------------------------------------------
-- course-planner (2 sample test cases, hidden starts at order_index 3)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-planner')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'course-planner')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'1\n[]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'3\n[[1,0],[2,1]]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'3\n[[0,1],[1,2],[2,0]]', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'4\n[[1,0],[2,0],[3,1],[3,2]]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'2\n[[0,1]]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'4\n[[0,1],[1,2],[2,3],[3,0]]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'5\n[[1,0],[2,0],[3,1],[4,3]]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'course-planner'), E'6\n[[1,0],[2,1],[3,2],[4,3],[5,4],[0,5]]', 'false', FALSE, 10);

------------------------------------------------------------
-- cycle-detection (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cycle-detection')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'cycle-detection')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[1]\n0', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[1,2,3,4,5]\n-1', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[1,2,3,4,5]\n4', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[1,2,3,4,5]\n0', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[1,2]\n-1', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[10,20,30,40]\n2', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[1,2,3]\n1', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'cycle-detection'), E'[5]\n-1', 'false', FALSE, 11);

------------------------------------------------------------
-- decode-ways (3 sample test cases, hidden starts at order_index 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-ways')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'decode-ways')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '0', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '10', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '27', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '2101', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '1111111', '21', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '2626', '4', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '101010', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'decode-ways'), '123456', '3', FALSE, 12);
