-- Regenerate hidden test cases for batch 12 problems
-- Problems: palindrome-count, palindrome-split, parentheses-generator, pattern-matcher,
--           perfect-sum, phone-combos, point-connector, polish-notation, popular-vote, power-check

-- palindrome-count
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-count')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-count')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abacaba', '12', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'aaaa', '10', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abcba', '7', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abcdefg', '7', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'aabbcc', '9', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abba', '6', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'aaaaa', '15', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'xyzyx', '7', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abcbaabc', '13', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'abab', '6', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'palindrome-count'), 'aabaa', '9', FALSE, 13);

-- palindrome-split
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-split')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'palindrome-split')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'abcba', '[["a","b","c","b","a"],["a","bcb","a"],["abcba"]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aabb', '[["a","a","b","b"],["a","a","bb"],["aa","b","b"],["aa","bb"]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'racecar', '[["r","a","c","e","c","a","r"],["r","a","cec","a","r"],["r","aceca","r"],["racecar"]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aaaa', '[["a","a","a","a"],["a","a","aa"],["a","aa","a"],["a","aaa"],["aa","a","a"],["aa","aa"],["aaa","a"],["aaaa"]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'abcd', '[["a","b","c","d"]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'bb', '[["b","b"],["bb"]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'abba', '[["a","b","b","a"],["a","bb","a"],["abba"]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'palindrome-split'), 'aaa', '[["a","a","a"],["a","aa"],["aa","a"],["aaa"]]', FALSE, 11);

-- parentheses-generator
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'parentheses-generator')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'parentheses-generator')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '2', '["(())","()()"]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '4', '["(((())))","((()()))","((())())","((()))()","(()(()))","(()()())","(()())()","(())(())","(())()()","()((()))","()(()())","()(())()","()()(())","()()()()"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'parentheses-generator'), '5', '["((((()))))","(((()())))","(((())()))","(((()))())","(((())))()","((()(())))","((()()()))","((()())())","((()()))()","((())(()))","((())()())","((())())()","((()))(())","((()))()()","(()((())))","(()(()()))","(()(())())","(()(()))()","(()()(()))","(()()()())","(()()())()","(()())(())","(()())()()","(())((()))","(())(()())","(())(())()","(())()(())","(())()()()","()(((())))","()((()()))","()((())())","()((()))()","()(()(()))","()(()()())","()(()())()","()(())(())","()(())()()","()()((()))","()()(()())","()()(())()","()()()(())","()()()()()"]', FALSE, 5);

-- pattern-matcher
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pattern-matcher')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'pattern-matcher')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aab\nc*a*b', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'mississippi\nmis*is*ip*.', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'ab\n.*c', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'a\na*a', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aaa\na*a', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'b\na*b', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'abc\na.c', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'abcdef\na.*f', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aaaa\na*', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'aaa\naaaa', 'false', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'a\n.', 'true', FALSE, 14),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'abcd\na.*d', 'true', FALSE, 15),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'abcd\na.*e', 'false', FALSE, 16),
    ((SELECT id FROM problems WHERE slug = 'pattern-matcher'), E'a\nab*', 'true', FALSE, 17);

-- perfect-sum
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'perfect-sum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'perfect-sum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '7', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '100', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '99', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '48', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '2', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '4', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '5', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '25', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '50', '2', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '9', '1', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '3', '3', FALSE, 14),
    ((SELECT id FROM problems WHERE slug = 'perfect-sum'), '17', '2', FALSE, 15);

-- phone-combos
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'phone-combos')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'phone-combos')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '79', '["pw","px","py","pz","qw","qx","qy","qz","rw","rx","ry","rz","sw","sx","sy","sz"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '234', '["adg","adh","adi","aeg","aeh","aei","afg","afh","afi","bdg","bdh","bdi","beg","beh","bei","bfg","bfh","bfi","cdg","cdh","cdi","ceg","ceh","cei","cfg","cfh","cfi"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '9', '["w","x","y","z"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '77', '["pp","pq","pr","ps","qp","qq","qr","qs","rp","rq","rr","rs","sp","sq","sr","ss"]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '22', '["aa","ab","ac","ba","bb","bc","ca","cb","cc"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '456', '["gjm","gjn","gjo","gkm","gkn","gko","glm","gln","glo","hjm","hjn","hjo","hkm","hkn","hko","hlm","hln","hlo","ijm","ijn","ijo","ikm","ikn","iko","ilm","iln","ilo"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '8', '["t","u","v"]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '39', '["dw","dx","dy","dz","ew","ex","ey","ez","fw","fx","fy","fz"]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'phone-combos'), '27', '["ap","aq","ar","as","bp","bq","br","bs","cp","cq","cr","cs"]', FALSE, 12);

-- point-connector
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'point-connector')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'point-connector')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[1,1],[1,0],[-1,1]]', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[5,5]]', '10', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[1,1],[2,2]]', '4', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[100,100],[-100,-100],[100,-100],[-100,100]]', '800', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[1,1],[2,2],[3,3],[4,4]]', '6', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[0,0],[0,1],[1,0],[1,1]]', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[10,10],[20,20],[30,30]]', '40', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'point-connector'), '[[-5,-5],[5,5],[0,0]]', '20', FALSE, 11);

-- polish-notation
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'polish-notation')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'polish-notation')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["3"]', '3', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["5","2","-"]', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["0","1","+"]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["15","7","/"]', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["6","3","/","2","*"]', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["4","2","+","3","*","6","-"]', '12', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["-1","2","*"]', '-2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["100","200","+","2","/"]', '150', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'polish-notation'), '["7","2","-","3","*"]', '15', FALSE, 12);

-- popular-vote
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'popular-vote')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'popular-vote')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[6,5,5]', '5', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[1,1,1,2,2,2,2]', '2', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[3,3,3,1,2]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[7]', '7', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[1,1,2,2,1]', '1', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[4,4,4,4,3,3,3]', '4', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[9,9,8,9,8]', '9', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[1,2,3,1,1]', '1', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[5,5,5,5,5,5]', '5', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[2,1,2,1,2,1,2]', '2', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'popular-vote'), '[10,10,20,10,20]', '10', FALSE, 14);

-- power-check
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-check')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'power-check')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'power-check'), '0', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '-16', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '1024', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '2147483647', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '2', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '3', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '64', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '128', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '256', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '1000', 'false', FALSE, 13),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '536870912', 'true', FALSE, 14),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '-1', 'false', FALSE, 15),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '4096', 'true', FALSE, 16),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '8', 'true', FALSE, 17),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '32', 'true', FALSE, 18),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '1048576', 'true', FALSE, 19),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '2048', 'true', FALSE, 20),
    ((SELECT id FROM problems WHERE slug = 'power-check'), '15', 'false', FALSE, 21);

