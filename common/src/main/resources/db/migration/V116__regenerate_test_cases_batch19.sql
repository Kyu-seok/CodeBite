-- ============================================================
-- Batch 19: Regenerate hidden test cases
-- Problems: tree-codec, tree-depth, tree-diameter, tree-within-tree,
--           triplet-former, two-colorable, unique-combinations,
--           unique-paths, unique-subsets, unique-substring
-- ============================================================

-------------------------------------------------------------
-- tree-codec (3 samples, order_index 1-3, existing hidden 4-7)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-codec')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,3,4,5,6,7]', '[1,2,3,4,5,6,7]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,null,2,null,3,null,4]', '[1,null,2,null,3,null,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,null,3,null,4]', '[1,2,null,3,null,4]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[5,4,7,3,null,2,null,-1,null,9]', '[5,4,7,3,null,2,null,-1,null,9]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[-1,-2,-3]', '[-1,-2,-3]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,3,null,4,null,5]', '[1,2,3,null,4,null,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[100,50,150,25,75,125,175]', '[100,50,150,25,75,125,175]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,null,2,null,3]', '[1,null,2,null,3]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[0,0,0,0,0,0,0]', '[0,0,0,0,0,0,0]', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'tree-codec'), '[1,2,3,4,5,null,null,6,7]', '[1,2,3,4,5,null,null,6,7]', FALSE, 13);

-------------------------------------------------------------
-- tree-depth (2 samples, order_index 1-2, existing hidden 3-4)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-depth')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-depth')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[0]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,2,3,4,5]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,null,2,null,3,null,4,null,5]', '5', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,2,3,4,null,null,5,6]', '4', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,2,null,3,null,4,null,5]', '5', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,2,3,4,5,6,7,8]', '4', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[10,5,15]', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,2,3,null,null,4,null,5]', '4', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'tree-depth'), '[1,null,2,null,3]', '3', FALSE, 12);

-------------------------------------------------------------
-- tree-diameter (2 samples, order_index 1-2, existing hidden 3-4)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-diameter')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-diameter')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3,null,null,4,5]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,null,3,null,4]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3,4,5,null,null,6,null,null,7]', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3]', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,null,2,null,3,null,4]', '3', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3,4,5,6,7]', '4', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[4,2,null,1,3]', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,null,3,4,null,null,5]', '3', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'tree-diameter'), '[1,2,3,4,null,null,5,6,null,null,7]', '6', FALSE, 12);

-------------------------------------------------------------
-- tree-within-tree (2 samples, order_index 1-2, existing hidden 3-4)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-within-tree')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-within-tree')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,1]\n[1]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1]\n[1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,2,3,4,5]\n[2,4,5]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,2,3,4,5]\n[2,4]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,2,3,null,null,4,5]\n[3,4,5]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,2,3,null,null,4,5]\n[3,4]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,null,2,null,3]\n[2,null,3]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,null,2,null,3]\n[2,3]', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[3,4,5,1,2,null,null,null,null,0]\n[4,1,2]', 'false', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'tree-within-tree'), E'[1,2,3,4,5,6,7]\n[3,6,7]', 'true', FALSE, 12);

-------------------------------------------------------------
-- triplet-former (3 samples, order_index 1-3, existing hidden 4-7)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triplet-former')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'triplet-former')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,1,1]]\n[1,1,1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,2,3],[4,5,6],[7,8,9]]\n[7,8,9]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[3,5,1],[10,5,7]]\n[3,5,7]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,3,5],[2,1,5],[3,2,1]]\n[3,3,5]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,1,1],[2,2,2],[3,3,3]]\n[3,3,3]', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[5,5,5]]\n[5,5,5]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,2,3],[4,5,6]]\n[4,5,3]', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,2,3],[2,3,1],[3,1,2]]\n[3,3,3]', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[1,0,0],[0,1,0],[0,0,1]]\n[1,1,1]', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'triplet-former'), E'[[2,3,4],[2,3,4],[2,3,4]]\n[2,3,4]', 'true', FALSE, 13);

-------------------------------------------------------------
-- two-colorable (3 samples, order_index 1-3, existing hidden 4-8)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'two-colorable')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'two-colorable')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[]]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1],[0],[3],[2]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,2],[0,2],[0,1]]', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[3],[2],[1,3],[0,2]]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,2,3],[0],[0,3],[0,2]]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1],[0],[3],[2],[5],[4]]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,3],[0,2],[1,3],[0,2]]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[],[],[]]', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1,4],[0,2],[1,3],[2,4],[0,3]]', 'false', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'two-colorable'), '[[1],[0,2],[1,3],[2]]', 'true', FALSE, 13);

-------------------------------------------------------------
-- unique-combinations (3 samples, order_index 1-3, existing hidden 4-7)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-combinations')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-combinations')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[3,1,3,5,1,1]\n8', '[[1,1,1,5],[1,1,3,3],[3,5]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1]\n1', '[[1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1]\n2', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[2,2,2,2,2]\n4', '[[2,2]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1,2,3,4,5]\n5', '[[1,4],[2,3],[5]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1,1,1,1,1]\n3', '[[1,1,1]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[2,3,6,7]\n7', '[[7]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1,2,3,4,5,6,7,8]\n10', '[[1,2,3,4],[1,2,7],[1,3,6],[1,4,5],[2,3,5],[2,8],[3,7],[4,6]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[1,1,2,2]\n4', '[[1,1,2],[2,2]]', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'unique-combinations'), E'[5,5,5,5]\n10', '[[5,5]]', FALSE, 13);

-------------------------------------------------------------
-- unique-paths (2 samples, order_index 1-2, existing hidden 3-5)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-paths')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-paths')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'1\n1', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'7\n3', '28', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'10\n10', '48620', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'2\n2', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'1\n10', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'10\n1', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'4\n4', '20', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'5\n5', '70', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'3\n3', '6', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'unique-paths'), E'15\n15', '40116600', FALSE, 12);

-------------------------------------------------------------
-- unique-subsets (3 samples, order_index 1-3, existing hidden 4-6)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-subsets')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-subsets')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[1,1]', '[[],[1],[1,1]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[3,1,2,2]', '[[],[1],[1,2],[1,2,2],[1,2,2,3],[1,2,3],[1,3],[2],[2,2],[2,2,3],[2,3],[3]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[5,5,5,5]', '[[],[5],[5,5],[5,5,5],[5,5,5,5]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[1,2,3]', '[[],[1],[1,2],[1,2,3],[1,3],[2],[2,3],[3]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[0,0,0]', '[[],[0],[0,0],[0,0,0]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[1]', '[[],[1]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[2,1,2,1]', '[[],[1],[1,1],[1,1,2],[1,1,2,2],[1,2],[1,2,2],[2],[2,2]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[3,3,3,3,3]', '[[],[3],[3,3],[3,3,3],[3,3,3,3],[3,3,3,3,3]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'unique-subsets'), '[1,2,2,3,3]', '[[],[1],[1,2],[1,2,2],[1,2,2,3],[1,2,2,3,3],[1,2,3],[1,2,3,3],[1,3],[1,3,3],[2],[2,2],[2,2,3],[2,2,3,3],[2,3],[2,3,3],[3],[3,3]]', FALSE, 12);

-------------------------------------------------------------
-- unique-substring (3 samples, order_index 1-3, existing hidden 4-5)
-------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-substring')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'unique-substring')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'au', '2', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'a', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'abcdef', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'aab', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'dvdf', '3', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'anviaj', '5', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'tmmzuxt', '5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'abcabcabc', '3', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'unique-substring'), 'abcdefghij', '10', FALSE, 12);
