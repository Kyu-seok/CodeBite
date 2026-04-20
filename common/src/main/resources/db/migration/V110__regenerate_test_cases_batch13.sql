-- Regenerate hidden test cases for Batch 13 problems

-- power-function
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-function')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-function')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'0.00000\n0', '1.00000', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'1.00000\n-1', '1.00000', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'-1.00000\n3', '-1.00000', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'-1.00000\n4', '1.00000', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'2.00000\n-3', '0.12500', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'0.50000\n5', '0.03125', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'3.00000\n1', '3.00000', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'10.00000\n2', '100.00000', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'-2.00000\n-2', '0.25000', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'power-function'), E'0.00010\n2147483647', '0.00000', FALSE, 13);

-- prefix-tree
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'prefix-tree')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'prefix-tree')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","search","startsWith"]\n[[],["a"],["a"]]', '[null,false,false]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","search","startsWith","insert","search","startsWith"]\n[[],["a"],["a"],["a"],["b"],["b"],["a"]]', '[null,null,true,true,null,true,true]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","insert","insert","search","search","startsWith","startsWith"]\n[[],["abc"],["ab"],["abcd"],["ab"],["abc"],["a"],["abcde"]]', '[null,null,null,null,true,true,true,false]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","search","search","startsWith"]\n[[],["apple"],["app"],["apple"],["app"]]', '[null,null,false,true,true]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","insert","insert","insert","search","search","search","search","startsWith","startsWith"]\n[[],["cat"],["car"],["card"],["care"],["car"],["care"],["cat"],["ca"],["car"],["cas"]]', '[null,null,null,null,null,true,true,true,false,true,false]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","insert","search"]\n[[],["hello"],["hello"],["hello"]]', '[null,null,null,true]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","search","startsWith"]\n[[],["abcdefghijklmnop"],["abcdefghijklmnop"],["abcdefgh"]]', '[null,null,true,true]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'prefix-tree'), E'["Trie","insert","search","startsWith","search"]\n[[],["testing"],["test"],["test"],["testing"]]', '[null,null,false,true,true]', FALSE, 9);

-- quad-sum
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'quad-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[]\n0', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[1,2,3]\n6', '[]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[0,0,0,0]\n0', '[[0,0,0,0]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[-3,-2,-1,0,0,1,2,3]\n-2', '[[-3,-2,0,3],[-3,-2,1,2],[-3,-1,0,2],[-3,0,0,1],[-2,-1,0,1]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[5,5,5,5,5]\n20', '[[5,5,5,5]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[1000000000,1000000000,1000000000,1000000000]\n-294967296', '[]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[1,2,3,4]\n100', '[]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[-1,-1,-1,0,1,1,1]\n0', '[[-1,-1,1,1]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'quad-sum'), E'[-5,-4,-3,-2,-1,0,1,2,3,4,5]\n0', '[[-5,-4,4,5],[-5,-3,3,5],[-5,-2,2,5],[-5,-2,3,4],[-5,-1,1,5],[-5,-1,2,4],[-5,0,1,4],[-5,0,2,3],[-4,-3,2,5],[-4,-3,3,4],[-4,-2,1,5],[-4,-2,2,4],[-4,-1,0,5],[-4,-1,1,4],[-4,-1,2,3],[-4,0,1,3],[-3,-2,0,5],[-3,-2,1,4],[-3,-2,2,3],[-3,-1,0,4],[-3,-1,1,3],[-3,0,1,2],[-2,-1,0,3],[-2,-1,1,2]]', FALSE, 12);

-- queen-placement
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'queen-placement')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'queen-placement')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'queen-placement'), '2', '[]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'queen-placement'), '3', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'queen-placement'), '5', '[["....Q","..Q..","Q....","...Q.",".Q..."],["....Q",".Q...","...Q.","Q....","..Q.."],["...Q.",".Q...","....Q","..Q..","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["..Q..","....Q",".Q...","...Q.","Q...."],["..Q..","Q....","...Q.",".Q...","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],[".Q...","...Q.","Q....","..Q..","....Q"],["Q....","...Q.",".Q...","....Q","..Q.."],["Q....","..Q..","....Q",".Q...","...Q."]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'queen-placement'), '6', '[["....Q.","..Q...","Q.....",".....Q","...Q..",".Q...."],["...Q..","Q.....","....Q.",".Q....",".....Q","..Q..."],["..Q...",".....Q",".Q....","....Q.","Q.....","...Q.."],[".Q....","...Q..",".....Q","Q.....","..Q...","....Q."]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'queen-placement'), '7', '[["......Q","....Q..","..Q....","Q......",".....Q.","...Q...",".Q....."],["......Q","...Q...","Q......","....Q..",".Q.....",".....Q.","..Q...."],["......Q","..Q....",".....Q.",".Q.....","....Q..","Q......","...Q..."],["......Q",".Q.....","...Q...",".....Q.","Q......","..Q....","....Q.."],[".....Q.","...Q...","......Q","Q......","..Q....","....Q..",".Q....."],[".....Q.","...Q...",".Q.....","......Q","....Q..","..Q....","Q......"],[".....Q.","..Q....","......Q","...Q...","Q......","....Q..",".Q....."],[".....Q.","..Q....","....Q..","......Q","Q......","...Q...",".Q....."],[".....Q.","..Q....","Q......","...Q...","......Q","....Q..",".Q....."],[".....Q.",".Q.....","....Q..","Q......","...Q...","......Q","..Q...."],[".....Q.","Q......","..Q....","....Q..","......Q",".Q.....","...Q..."],["....Q..","......Q",".Q.....",".....Q.","..Q....","Q......","...Q..."],["....Q..","......Q",".Q.....","...Q...",".....Q.","Q......","..Q...."],["....Q..","..Q....","Q......",".....Q.","...Q...",".Q.....","......Q"],["....Q..",".Q.....",".....Q.","..Q....","......Q","...Q...","Q......"],["....Q..","Q......",".....Q.","...Q...",".Q.....","......Q","..Q...."],["....Q..","Q......","...Q...","......Q","..Q....",".....Q.",".Q....."],["...Q...","......Q","....Q..",".Q.....",".....Q.","Q......","..Q...."],["...Q...","......Q","..Q....",".....Q.",".Q.....","....Q..","Q......"],["...Q...",".....Q.","Q......","..Q....","....Q..","......Q",".Q....."],["...Q...",".Q.....","......Q","....Q..","..Q....","Q......",".....Q."],["...Q...","Q......","....Q..",".Q.....",".....Q.","..Q....","......Q"],["...Q...","Q......","..Q....",".....Q.",".Q.....","......Q","....Q.."],["..Q....","......Q","...Q...","Q......","....Q..",".Q.....",".....Q."],["..Q....","......Q",".Q.....","...Q...",".....Q.","Q......","....Q.."],["..Q....",".....Q.",".Q.....","....Q..","Q......","...Q...","......Q"],["..Q....","....Q..","......Q",".Q.....","...Q...",".....Q.","Q......"],["..Q....","Q......",".....Q.","...Q...",".Q.....","......Q","....Q.."],["..Q....","Q......",".....Q.",".Q.....","....Q..","......Q","...Q..."],[".Q.....","......Q","....Q..","..Q....","Q......",".....Q.","...Q..."],[".Q.....",".....Q.","..Q....","......Q","...Q...","Q......","....Q.."],[".Q.....","....Q..","......Q","...Q...","Q......","..Q....",".....Q."],[".Q.....","....Q..","..Q....","Q......","......Q","...Q...",".....Q."],[".Q.....","....Q..","Q......","...Q...","......Q","..Q....",".....Q."],[".Q.....","...Q...",".....Q.","Q......","..Q....","....Q..","......Q"],[".Q.....","...Q...","Q......","......Q","....Q..","..Q....",".....Q."],["Q......",".....Q.","...Q...",".Q.....","......Q","....Q..","..Q...."],["Q......","....Q..",".Q.....",".....Q.","..Q....","......Q","...Q..."],["Q......","...Q...","......Q","..Q....",".....Q.",".Q.....","....Q.."],["Q......","..Q....","....Q..","......Q",".Q.....","...Q...",".....Q."]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'queen-placement'), '8', '[[".......Q","...Q....","Q.......","..Q.....",".....Q..",".Q......","......Q.","....Q..."],[".......Q","..Q.....","Q.......",".....Q..",".Q......","....Q...","......Q.","...Q...."],[".......Q",".Q......","....Q...","..Q.....","Q.......","......Q.","...Q....",".....Q.."],[".......Q",".Q......","...Q....","Q.......","......Q.","....Q...","..Q.....",".....Q.."],["......Q.","....Q...","..Q.....","Q.......",".....Q..",".......Q",".Q......","...Q...."],["......Q.","...Q....",".Q......",".......Q",".....Q..","Q.......","..Q.....","....Q..."],["......Q.","...Q....",".Q......","....Q...",".......Q","Q.......","..Q.....",".....Q.."],["......Q.","..Q.....",".......Q",".Q......","....Q...","Q.......",".....Q..","...Q...."],["......Q.","..Q.....","Q.......",".....Q..",".......Q","....Q...",".Q......","...Q...."],["......Q.",".Q......",".....Q..","..Q.....","Q.......","...Q....",".......Q","....Q..."],["......Q.",".Q......","...Q....","Q.......",".......Q","....Q...","..Q.....",".....Q.."],["......Q.","Q.......","..Q.....",".......Q",".....Q..","...Q....",".Q......","....Q..."],[".....Q..",".......Q",".Q......","...Q....","Q.......","......Q.","....Q...","..Q....."],[".....Q..","...Q....","......Q.","Q.......",".......Q",".Q......","....Q...","..Q....."],[".....Q..","...Q....","......Q.","Q.......","..Q.....","....Q...",".Q......",".......Q"],[".....Q..","...Q....",".Q......",".......Q","....Q...","......Q.","Q.......","..Q....."],[".....Q..","...Q....","Q.......","....Q...",".......Q",".Q......","......Q.","..Q....."],[".....Q..","..Q.....","......Q.","...Q....","Q.......",".......Q",".Q......","....Q..."],[".....Q..","..Q.....","......Q.",".Q......",".......Q","....Q...","Q.......","...Q...."],[".....Q..","..Q.....","......Q.",".Q......","...Q....",".......Q","Q.......","....Q..."],[".....Q..","..Q.....","....Q...",".......Q","Q.......","...Q....",".Q......","......Q."],[".....Q..","..Q.....","....Q...","......Q.","Q.......","...Q....",".Q......",".......Q"],[".....Q..","..Q.....","Q.......",".......Q","....Q...",".Q......","...Q....","......Q."],[".....Q..","..Q.....","Q.......",".......Q","...Q....",".Q......","......Q.","....Q..."],[".....Q..","..Q.....","Q.......","......Q.","....Q...",".......Q",".Q......","...Q...."],[".....Q..",".Q......","......Q.","Q.......","...Q....",".......Q","....Q...","..Q....."],[".....Q..",".Q......","......Q.","Q.......","..Q.....","....Q...",".......Q","...Q...."],[".....Q..","Q.......","....Q...",".Q......",".......Q","..Q.....","......Q.","...Q...."],["....Q...",".......Q","...Q....","Q.......","......Q.",".Q......",".....Q..","..Q....."],["....Q...",".......Q","...Q....","Q.......","..Q.....",".....Q..",".Q......","......Q."],["....Q...","......Q.","...Q....","Q.......","..Q.....",".......Q",".....Q..",".Q......"],["....Q...","......Q.",".Q......",".....Q..","..Q.....","Q.......",".......Q","...Q...."],["....Q...","......Q.",".Q......",".....Q..","..Q.....","Q.......","...Q....",".......Q"],["....Q...","......Q.",".Q......","...Q....",".......Q","Q.......","..Q.....",".....Q.."],["....Q...","......Q.","Q.......","...Q....",".Q......",".......Q",".....Q..","..Q....."],["....Q...","......Q.","Q.......","..Q.....",".......Q",".....Q..","...Q....",".Q......"],["....Q...","..Q.....",".......Q","...Q....","......Q.","Q.......",".....Q..",".Q......"],["....Q...","..Q.....","Q.......","......Q.",".Q......",".......Q",".....Q..","...Q...."],["....Q...","..Q.....","Q.......",".....Q..",".......Q",".Q......","...Q....","......Q."],["....Q...",".Q......",".......Q","Q.......","...Q....","......Q.","..Q.....",".....Q.."],["....Q...",".Q......",".....Q..","Q.......","......Q.","...Q....",".......Q","..Q....."],["....Q...",".Q......","...Q....","......Q.","..Q.....",".......Q",".....Q..","Q......."],["....Q...",".Q......","...Q....",".....Q..",".......Q","..Q.....","Q.......","......Q."],["....Q...","Q.......",".......Q",".....Q..","..Q.....","......Q.",".Q......","...Q...."],["....Q...","Q.......",".......Q","...Q....",".Q......","......Q.","..Q.....",".....Q.."],["....Q...","Q.......","...Q....",".....Q..",".......Q",".Q......","......Q.","..Q....."],["...Q....",".......Q","....Q...","..Q.....","Q.......","......Q.",".Q......",".....Q.."],["...Q....",".......Q","Q.......","....Q...","......Q.",".Q......",".....Q..","..Q....."],["...Q....",".......Q","Q.......","..Q.....",".....Q..",".Q......","......Q.","....Q..."],["...Q....","......Q.","....Q...","..Q.....","Q.......",".....Q..",".......Q",".Q......"],["...Q....","......Q.","....Q...",".Q......",".....Q..","Q.......","..Q.....",".......Q"],["...Q....","......Q.","..Q.....",".......Q",".Q......","....Q...","Q.......",".....Q.."],["...Q....","......Q.","Q.......",".......Q","....Q...",".Q......",".....Q..","..Q....."],["...Q....",".....Q..",".......Q","..Q.....","Q.......","......Q.","....Q...",".Q......"],["...Q....",".....Q..",".......Q",".Q......","......Q.","Q.......","..Q.....","....Q..."],["...Q....",".....Q..","Q.......","....Q...",".Q......",".......Q","..Q.....","......Q."],["...Q....",".Q......",".......Q",".....Q..","Q.......","..Q.....","....Q...","......Q."],["...Q....",".Q......",".......Q","....Q...","......Q.","Q.......","..Q.....",".....Q.."],["...Q....",".Q......","......Q.","....Q...","Q.......",".......Q",".....Q..","..Q....."],["...Q....",".Q......","......Q.","..Q.....",".....Q..",".......Q","....Q...","Q......."],["...Q....",".Q......","......Q.","..Q.....",".....Q..",".......Q","Q.......","....Q..."],["...Q....",".Q......","....Q...",".......Q",".....Q..","Q.......","..Q.....","......Q."],["...Q....","Q.......","....Q...",".......Q",".....Q..","..Q.....","......Q.",".Q......"],["...Q....","Q.......","....Q...",".......Q",".Q......","......Q.","..Q.....",".....Q.."],["..Q.....",".......Q","...Q....","......Q.","Q.......",".....Q..",".Q......","....Q..."],["..Q.....","......Q.",".Q......",".......Q",".....Q..","...Q....","Q.......","....Q..."],["..Q.....","......Q.",".Q......",".......Q","....Q...","Q.......","...Q....",".....Q.."],["..Q.....",".....Q..",".......Q",".Q......","...Q....","Q.......","......Q.","....Q..."],["..Q.....",".....Q..",".......Q","Q.......","....Q...","......Q.",".Q......","...Q...."],["..Q.....",".....Q..",".......Q","Q.......","...Q....","......Q.","....Q...",".Q......"],["..Q.....",".....Q..","...Q....",".Q......",".......Q","....Q...","......Q.","Q......."],["..Q.....",".....Q..","...Q....","Q.......",".......Q","....Q...","......Q.",".Q......"],["..Q.....",".....Q..",".Q......","......Q.","....Q...","Q.......",".......Q","...Q...."],["..Q.....",".....Q..",".Q......","......Q.","Q.......","...Q....",".......Q","....Q..."],["..Q.....",".....Q..",".Q......","....Q...",".......Q","Q.......","......Q.","...Q...."],["..Q.....","....Q...",".......Q","...Q....","Q.......","......Q.",".Q......",".....Q.."],["..Q.....","....Q...","......Q.","Q.......","...Q....",".Q......",".......Q",".....Q.."],["..Q.....","....Q...",".Q......",".......Q",".....Q..","...Q....","......Q.","Q......."],["..Q.....","....Q...",".Q......",".......Q","Q.......","......Q.","...Q....",".....Q.."],["..Q.....","Q.......","......Q.","....Q...",".......Q",".Q......","...Q....",".....Q.."],[".Q......",".......Q",".....Q..","Q.......","..Q.....","....Q...","......Q.","...Q...."],[".Q......","......Q.","....Q...",".......Q","Q.......","...Q....",".....Q..","..Q....."],[".Q......","......Q.","..Q.....",".....Q..",".......Q","....Q...","Q.......","...Q...."],[".Q......",".....Q..",".......Q","..Q.....","Q.......","...Q....","......Q.","....Q..."],[".Q......",".....Q..","Q.......","......Q.","...Q....",".......Q","..Q.....","....Q..."],[".Q......","....Q...","......Q.","...Q....","Q.......",".......Q",".....Q..","..Q....."],[".Q......","....Q...","......Q.","Q.......","..Q.....",".......Q",".....Q..","...Q...."],[".Q......","...Q....",".....Q..",".......Q","..Q.....","Q.......","......Q.","....Q..."],["Q.......","......Q.","....Q...",".......Q",".Q......","...Q....",".....Q..","..Q....."],["Q.......","......Q.","...Q....",".....Q..",".......Q",".Q......","....Q...","..Q....."],["Q.......",".....Q..",".......Q","..Q.....","......Q.","...Q....",".Q......","....Q..."],["Q.......","....Q...",".......Q",".....Q..","..Q.....","......Q.",".Q......","...Q...."]]', FALSE, 8);

-- query-intervals
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'query-intervals')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'query-intervals')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,1]]\n[1]', '[1]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,10]]\n[5,11,1,10]', '[10,-1,10,10]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,2],[3,4],[5,6]]\n[1,3,5,7]', '[2,2,2,-1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,5],[2,3]]\n[2,3,4]', '[2,2,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,100],[50,60],[55,58]]\n[55,99,101]', '[4,100,-1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[2,2],[3,3],[4,4]]\n[2,3,4,5]', '[1,1,1,-1]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[1,3],[2,5],[4,7],[6,9]]\n[1,4,6,8,10]', '[3,4,4,4,-1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'query-intervals'), E'[[10,20],[15,25],[20,30]]\n[5,10,15,20,25,30,35]', '[-1,11,11,11,11,11,-1]', FALSE, 11);

-- rain-collector
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rain-collector')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rain-collector')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[]', '0', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[0]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[1,2,3,4,5]', '0', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[5,4,3,2,1]', '0', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[3,0,3]', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[5,2,1,2,1,5]', '14', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[1,0,1,0,1,0,1]', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[0,0,0,0,0]', '0', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[2,0,2]', '2', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'rain-collector'), '[1,7,5,2,4,6,3,1]', '7', FALSE, 12);

-- random-set
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'random-set')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'random-set')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","insert"]\n[[],[1],[2],[3]]', '[null,true,true,true]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","insert"]\n[[],[1],[1],[1]]', '[null,true,false,false]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","remove","remove"]\n[[],[1],[2]]', '[null,false,false]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","remove","insert"]\n[[],[5],[5],[5]]', '[null,true,true,true]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","getRandom","getRandom"]\n[[],[42],[],[]]', '[null,true,42,42]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","insert","remove","remove","getRandom"]\n[[],[1],[2],[3],[1],[2],[]]', '[null,true,true,true,true,true,3]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","remove","insert","getRandom"]\n[[],[100],[100],[200],[]]', '[null,true,true,true,200]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","insert","remove","getRandom"]\n[[],[-5],[-10],[-5],[]]', '[null,true,true,true,-10]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","insert","remove","insert","remove","insert","getRandom"]\n[[],[7],[7],[7],[7],[7],[]]', '[null,true,true,true,true,true,7]', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'random-set'), E'["RandomSet","remove","insert","remove","insert","getRandom"]\n[[],[1],[1],[1],[2],[]]', '[null,false,true,true,true,2]', FALSE, 13);

-- reach-the-end
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reach-the-end')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'reach-the-end')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[0]', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[1,0]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[0,1]', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[1,1,1,1,1]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[5,0,0,0,0,0]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[1,0,0,0]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[2,0,0]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[3,0,0,0,0,1,0]', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[1,2,3,4,5]', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'reach-the-end'), '[4,3,2,1,0,4]', 'false', FALSE, 12);

-- rearrange-letters
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rearrange-letters')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'rearrange-letters')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'a', 'valid', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aa', '', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'ab', 'valid', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aabb', 'valid', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaabbbccc', 'valid', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaaa', '', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aabbcc', 'valid', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaabbbc', 'valid', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'abcdef', 'valid', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaabc', 'valid', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaaabbc', 'valid', FALSE, 14),
    ((SELECT id FROM problems WHERE slug = 'rearrange-letters'), 'aaaaab', '', FALSE, 15);

-- recent-cache
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'recent-cache')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","get","put","get","get"]\n[[1],[1,10],[1],[2,20],[1],[2]]', '[null,null,10,null,-1,20]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","get","put","get"]\n[[2],[1,1],[2,2],[3,3],[2],[4,4],[1]]', '[null,null,null,null,2,null,-1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","get","put","get","get"]\n[[2],[1,1],[2,2],[2],[3,3],[1],[2]]', '[null,null,null,2,null,-1,2]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","get","put","get"]\n[[2],[1,10],[1,20],[1],[2,30],[1]]', '[null,null,null,20,null,20]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","put","get","get","get","get"]\n[[4],[1,1],[2,2],[3,3],[4,4],[1],[2],[3],[4]]', '[null,null,null,null,null,1,2,3,4]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","get","get"]\n[[2],[1,100],[2,200],[3,300],[1],[3]]', '[null,null,null,null,-1,300]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","get","get"]\n[[3],[1],[2]]', '[null,-1,-1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","get"]\n[[1],[1,1],[1,2],[1,3],[1]]', '[null,null,null,null,3]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'recent-cache'), E'["RecentCache","put","put","put","get","put","put","get","get","get"]\n[[3],[1,10],[2,20],[3,30],[1],[4,40],[5,50],[1],[2],[3]]', '[null,null,null,null,10,null,null,10,-1,-1]', FALSE, 12);
