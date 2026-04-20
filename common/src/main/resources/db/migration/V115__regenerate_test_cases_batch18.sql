-- Regenerate hidden test cases for batch 18 problems
-- Problems: swap-pairs, symbol-order, tallest-bar, target-combinations, target-path,
--           target-subarray, temperature-wait, three-sum, time-map, tree-ancestor

-- swap-pairs
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-pairs')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'swap-pairs')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1]', '[1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[]', '[]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3,4,5]', '[2,1,4,3,5]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3,4,5,6]', '[2,1,4,3,6,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[10,20]', '[20,10]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[100,200,300]', '[200,100,300]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3,4,5,6,7,8]', '[2,1,4,3,6,5,8,7]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[5,5,5,5]', '[5,5,5,5]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'swap-pairs'), '[1,2,3,4,5,6,7,8,9,10]', '[2,1,4,3,6,5,8,7,10,9]', FALSE, 12);

-- symbol-order
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'symbol-order')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'symbol-order')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["a"]', 'a', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["z","z"]', 'z', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["xy","xz","yz"]', 'xyz', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["ba","bc","ac","cab"]', 'bac', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["a","b","a"]', '', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["abc","ab"]', '', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'symbol-order'), '["x","y","z"]', 'xyz', FALSE, 10);

-- tallest-bar
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tallest-bar')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tallest-bar')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[1]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[5]', '5', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[1,1]', '2', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[3,3,3,3]', '12', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[1,2,3,4,5]', '9', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[5,4,3,2,1]', '9', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[2,1,2]', '3', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[1,3,2,1,2]', '5', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[0,9]', '9', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'tallest-bar'), '[4,2,0,3,2,5]', '6', FALSE, 13);

-- target-combinations
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-combinations')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-combinations')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[2]\n1', '[]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[1]\n2', '[[1,1]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[1]\n1', '[[1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[2,3]\n6', '[[2,2,2],[3,3]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[7,3,2]\n18', '[[2,2,2,2,2,2,2,2,2],[2,2,2,2,2,2,3,3],[2,2,2,2,3,7],[2,2,2,3,3,3,3],[2,2,7,7],[2,3,3,3,7],[3,3,3,3,3,3]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[5,10,8,3]\n8', '[[3,5],[8]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[4]\n4', '[[4]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[2,4,6,8]\n8', '[[2,2,2,2],[2,2,4],[2,6],[4,4],[8]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'target-combinations'), E'[3,5,7]\n10', '[[3,7],[5,5]]', FALSE, 11);

-- target-path
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-path')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-path')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[]\n0', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1]\n1', '[[1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1]\n2', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1,2,3]\n3', '[[1,2]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1,2,3]\n4', '[[1,3]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[10,5,15,3,7,12,18]\n18', '[[10,5,3]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[10,5,15,3,7,12,18]\n22', '[[10,5,7]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[10,5,15,3,7,12,18]\n37', '[[10,15,12]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'target-path'), E'[1,2,3,4,5,6,7]\n7', '[[1,2,4]]', FALSE, 12);

-- target-subarray
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-subarray')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'target-subarray')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1]\n1', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1]\n0', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[0,0,0]\n0', '6', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1,-1,1,-1]\n0', '4', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[3,4,7,2,-3,1,4,2]\n7', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1,2,3,4,5]\n9', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[-1,-1,1]\n0', '1', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[1,2,1,2,1]\n3', '4', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'target-subarray'), E'[100,-100,100,-100]\n0', '4', FALSE, 12);

-- temperature-wait
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'temperature-wait')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'temperature-wait')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[90,80,70,60]', '[0,0,0,0]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[50]', '[0]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[50,50,50]', '[0,0,0]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[30,40,50,60]', '[1,1,1,0]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[70,71,72,73,74,75]', '[1,1,1,1,1,0]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[73,72,71,70,69,68,76]', '[6,5,4,3,2,1,0]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[55,38,53,81,61,93,97,32,43,78]', '[3,1,1,2,1,1,0,1,1,0]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'temperature-wait'), '[34,80,80,34,34,80,80,80,80,34]', '[1,0,0,2,1,0,0,0,0,0]', FALSE, 11);

-- three-sum
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'three-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'three-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[0,0,0,0]', '[[0,0,0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[1,2,-3]', '[[-3,1,2]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[1,1,1]', '[]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[-2,0,1,1,2]', '[[-2,0,2],[-2,1,1]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[-1,-1,-1,2,2,2]', '[[-1,-1,2]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[-4,-2,-1,0,1,2,3]', '[[-4,1,3],[-2,-1,3],[-2,0,2],[-1,0,1]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[0,0,0,0,0]', '[[0,0,0]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[-5,-4,-3,-2,-1,0,1,2,3,4,5]', '[[-5,0,5],[-5,1,4],[-5,2,3],[-4,-1,5],[-4,0,4],[-4,1,3],[-3,-2,5],[-3,-1,4],[-3,0,3],[-3,1,2],[-2,-1,3],[-2,0,2],[-1,0,1]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'three-sum'), '[3,-1,2,-1,0]', '[[-1,-1,2]]', FALSE, 12);

-- time-map
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'time-map')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","set","get","get","get","get"]\n[[],["a","v1",1],["a","v2",5],["a","v3",10],["a",1],["a",4],["a",7],["a",15]]', '[null,null,null,null,"v1","v1","v2","v3"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","get"]\n[[],["missing",1]]', '[null,""]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","get","get"]\n[[],["k","val",10],["k",5],["k",10]]', '[null,null,"","val"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","set","get","get"]\n[[],["x","a",1],["x","b",2],["x","c",3],["x",2],["x",4]]', '[null,null,null,null,"b","c"]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","get","get","get"]\n[[],["a","one",1],["b","two",2],["a",1],["b",1],["b",2]]', '[null,null,null,"one","","two"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","set","get","get","get"]\n[[],["k","first",1],["k","second",2],["k","third",3],["k",1],["k",2],["k",3]]', '[null,null,null,null,"first","second","third"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'time-map'), E'["TimeMap","set","set","set","set","get","get","get","get"]\n[[],["a","1",100],["a","2",200],["a","3",300],["a","4",400],["a",50],["a",150],["a",250],["a",500]]', '[null,null,null,null,null,"","1","2","4"]', FALSE, 10);

-- tree-ancestor
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-ancestor')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'tree-ancestor')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2]\n1\n2', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,4,5]\n4\n5', '2', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,4,5]\n2\n3', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,null,4,null,5]\n4\n5', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,4,5,6,7]\n4\n7', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,4,5,6,7]\n6\n7', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,4,5,6,7]\n4\n5', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[1,2,3,4,5,6,7]\n2\n4', '2', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'tree-ancestor'), E'[3,5,1,6,2,0,8,null,null,7,4]\n6\n4', '5', FALSE, 12);
