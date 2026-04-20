-- V98: Regenerate hidden test cases for batch 1 (10 problems)
-- All test cases validated against Judge0 (Python 3.8.1, language_id=71)

-- ============================================================
-- #1 absent-number
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'absent-number')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'absent-number')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[1,2,3,4,5,6,7,8,9,10]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[0,1,2,3,5,6,7,8,9,10]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[2,0]', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[0,2,3,4,5,6,7,8,9,1]', '10', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[5,3,0,1,4]', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[0,1,2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,19,8]', '20', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'absent-number'), '[3,4,1,0]', '2', FALSE, 10);

-- ============================================================
-- #2 account-merger
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'account-merger')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'account-merger')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Alice","alice@mail.com"]]', '[["Alice","alice@mail.com"]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Alice","a@m.co"],["Bob","b@m.co"]]', '[["Alice","a@m.co"],["Bob","b@m.co"]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Alice","a@m.co","b@m.co"],["Alice","b@m.co","c@m.co"],["Alice","c@m.co","d@m.co"]]', '[["Alice","a@m.co","b@m.co","c@m.co","d@m.co"]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Bob","bob1@m.co"],["Bob","bob2@m.co"]]', '[["Bob","bob1@m.co"],["Bob","bob2@m.co"]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Amy","a@m.co","b@m.co"],["Amy","b@m.co","c@m.co"],["Amy","c@m.co","a@m.co"]]', '[["Amy","a@m.co","b@m.co","c@m.co"]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Alex","Alex5@m.co","Alex4@m.co","Alex0@m.co"],["Ethan","Ethan3@m.co","Ethan3@m.co","Ethan0@m.co"]]', '[["Alex","Alex0@m.co","Alex4@m.co","Alex5@m.co"],["Ethan","Ethan0@m.co","Ethan3@m.co"]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["A","a1@m.co","a2@m.co"],["B","b1@m.co"],["A","a2@m.co","a3@m.co"],["B","b2@m.co"],["C","c1@m.co"]]', '[["A","a1@m.co","a2@m.co","a3@m.co"],["B","b1@m.co"],["B","b2@m.co"],["C","c1@m.co"]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["X","e1@m.co","e2@m.co"],["X","e2@m.co","e3@m.co"],["X","e3@m.co","e4@m.co"],["X","e4@m.co","e5@m.co"],["X","e5@m.co","e6@m.co"]]', '[["X","e1@m.co","e2@m.co","e3@m.co","e4@m.co","e5@m.co","e6@m.co"]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'account-merger'), '[["Jo","j1@m.co"],["Jo","j2@m.co"],["Jo","j3@m.co"],["Jo","j1@m.co","j2@m.co"]]', '[["Jo","j1@m.co","j2@m.co"],["Jo","j3@m.co"]]', FALSE, 11);

-- ============================================================
-- #3 add-two-numbers
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'add-two-numbers')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'add-two-numbers')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[1]\n[2]', '[3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[5]\n[5]', '[0,1]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[1]\n[9,9]', '[0,0,1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[9,9,9]\n[9,9,9]', '[8,9,9,1]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[0]\n[1,2,3]', '[1,2,3]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[0]\n[0]', '[0]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]\n[5,6,4]', '[6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[9,9,9,9,9,9,9]\n[9,9,9,9]', '[8,9,9,9,0,0,0,1]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'add-two-numbers'), E'[2,4,3]\n[5,6,4]', '[7,0,8]', FALSE, 12);

-- ============================================================
-- #4 airport-route
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'airport-route')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'airport-route')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","ATL"]]', '["JFK","ATL"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","AAA"],["AAA","JFK"],["JFK","BBB"]]', '["JFK","AAA","JFK","BBB"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","SFO"],["SFO","JFK"]]', '["JFK","SFO","JFK"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","ZZZ"],["JFK","AAA"],["AAA","JFK"]]', '["JFK","AAA","JFK","ZZZ"]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","AAA"],["AAA","BBB"],["BBB","JFK"],["JFK","AAA"],["AAA","CCC"]]', '["JFK","AAA","BBB","JFK","AAA","CCC"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","LAX"],["LAX","SFO"],["SFO","JFK"],["JFK","DEN"]]', '["JFK","LAX","SFO","JFK","DEN"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","AAA"],["AAA","BBB"],["BBB","AAA"],["AAA","JFK"],["JFK","AAA"],["AAA","CCC"]]', '["JFK","AAA","BBB","AAA","JFK","AAA","CCC"]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'airport-route'), '[["JFK","A"],["A","B"],["B","C"],["C","D"],["D","E"]]', '["JFK","A","B","C","D","E"]', FALSE, 11);

-- ============================================================
-- #5 all-arrangements
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-arrangements')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-arrangements')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[]', '[[]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[1]', '[[1]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[0,1]', '[[0,1],[1,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[-1,0,1]', '[[-1,0,1],[-1,1,0],[0,-1,1],[0,1,-1],[1,-1,0],[1,0,-1]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[1,2,3,4]', '[[1,2,3,4],[1,2,4,3],[1,3,2,4],[1,3,4,2],[1,4,2,3],[1,4,3,2],[2,1,3,4],[2,1,4,3],[2,3,1,4],[2,3,4,1],[2,4,1,3],[2,4,3,1],[3,1,2,4],[3,1,4,2],[3,2,1,4],[3,2,4,1],[3,4,1,2],[3,4,2,1],[4,1,2,3],[4,1,3,2],[4,2,1,3],[4,2,3,1],[4,3,1,2],[4,3,2,1]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[10,20]', '[[10,20],[20,10]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'all-arrangements'), '[1,2,3,4,5]', '[[1,2,3,4,5],[1,2,3,5,4],[1,2,4,3,5],[1,2,4,5,3],[1,2,5,3,4],[1,2,5,4,3],[1,3,2,4,5],[1,3,2,5,4],[1,3,4,2,5],[1,3,4,5,2],[1,3,5,2,4],[1,3,5,4,2],[1,4,2,3,5],[1,4,2,5,3],[1,4,3,2,5],[1,4,3,5,2],[1,4,5,2,3],[1,4,5,3,2],[1,5,2,3,4],[1,5,2,4,3],[1,5,3,2,4],[1,5,3,4,2],[1,5,4,2,3],[1,5,4,3,2],[2,1,3,4,5],[2,1,3,5,4],[2,1,4,3,5],[2,1,4,5,3],[2,1,5,3,4],[2,1,5,4,3],[2,3,1,4,5],[2,3,1,5,4],[2,3,4,1,5],[2,3,4,5,1],[2,3,5,1,4],[2,3,5,4,1],[2,4,1,3,5],[2,4,1,5,3],[2,4,3,1,5],[2,4,3,5,1],[2,4,5,1,3],[2,4,5,3,1],[2,5,1,3,4],[2,5,1,4,3],[2,5,3,1,4],[2,5,3,4,1],[2,5,4,1,3],[2,5,4,3,1],[3,1,2,4,5],[3,1,2,5,4],[3,1,4,2,5],[3,1,4,5,2],[3,1,5,2,4],[3,1,5,4,2],[3,2,1,4,5],[3,2,1,5,4],[3,2,4,1,5],[3,2,4,5,1],[3,2,5,1,4],[3,2,5,4,1],[3,4,1,2,5],[3,4,1,5,2],[3,4,2,1,5],[3,4,2,5,1],[3,4,5,1,2],[3,4,5,2,1],[3,5,1,2,4],[3,5,1,4,2],[3,5,2,1,4],[3,5,2,4,1],[3,5,4,1,2],[3,5,4,2,1],[4,1,2,3,5],[4,1,2,5,3],[4,1,3,2,5],[4,1,3,5,2],[4,1,5,2,3],[4,1,5,3,2],[4,2,1,3,5],[4,2,1,5,3],[4,2,3,1,5],[4,2,3,5,1],[4,2,5,1,3],[4,2,5,3,1],[4,3,1,2,5],[4,3,1,5,2],[4,3,2,1,5],[4,3,2,5,1],[4,3,5,1,2],[4,3,5,2,1],[4,5,1,2,3],[4,5,1,3,2],[4,5,2,1,3],[4,5,2,3,1],[4,5,3,1,2],[4,5,3,2,1],[5,1,2,3,4],[5,1,2,4,3],[5,1,3,2,4],[5,1,3,4,2],[5,1,4,2,3],[5,1,4,3,2],[5,2,1,3,4],[5,2,1,4,3],[5,2,3,1,4],[5,2,3,4,1],[5,2,4,1,3],[5,2,4,3,1],[5,3,1,2,4],[5,3,1,4,2],[5,3,2,1,4],[5,3,2,4,1],[5,3,4,1,2],[5,3,4,2,1],[5,4,1,2,3],[5,4,1,3,2],[5,4,2,1,3],[5,4,2,3,1],[5,4,3,1,2],[5,4,3,2,1]]', FALSE, 9);

-- ============================================================
-- #6 all-subsets
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-subsets')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'all-subsets')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[]', '[[]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[1]', '[[],[1]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[1,2]', '[[],[1],[1,2],[2]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[-1,0,1]', '[[],[-1],[-1,0],[-1,0,1],[-1,1],[0],[0,1],[1]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[1,2,3,4]', '[[],[1],[1,2],[1,2,3],[1,2,3,4],[1,2,4],[1,3],[1,3,4],[1,4],[2],[2,3],[2,3,4],[2,4],[3],[3,4],[4]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[10,20,30]', '[[],[10],[10,20],[10,20,30],[10,30],[20],[20,30],[30]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'all-subsets'), '[1,2,3,4,5]', '[[],[1],[1,2],[1,2,3],[1,2,3,4],[1,2,3,4,5],[1,2,3,5],[1,2,4],[1,2,4,5],[1,2,5],[1,3],[1,3,4],[1,3,4,5],[1,3,5],[1,4],[1,4,5],[1,5],[2],[2,3],[2,3,4],[2,3,4,5],[2,3,5],[2,4],[2,4,5],[2,5],[3],[3,4],[3,4,5],[3,5],[4],[4,5],[5]]', FALSE, 9);

-- ============================================================
-- #7 almost-sorted
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'almost-sorted')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'almost-sorted')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1,2,3,4,5]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[5,1,2,3,4]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[3,4,1,2]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[2,1]', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1,2,3,1]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1,3,2,4]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[5,4,3,2,1]', 'false', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[10,1,2,3,4,5]', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'almost-sorted'), '[1,2,3,4,5,0]', 'true', FALSE, 13);

-- ============================================================
-- #8 anagram-check
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-check')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-check')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'a\na', 'true', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'a\nb', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'ab\nba', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'abc\nabd', 'false', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'aabb\nbbaa', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'aabb\naab', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'listen\nsilent', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'aaaaaaaaaa\naaaaaaaaaa', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'abcdefghij\njihgfedcba', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'aabbcc\nabcabc', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'anagram-check'), E'xyz\nxyz', 'true', FALSE, 13);

-- ============================================================
-- #9 anagram-groups
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-groups')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'anagram-groups')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '[""]', '[[""]]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["a"]', '[["a"]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["abc","def","ghi"]', '[["abc"],["def"],["ghi"]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["abc","bca","cab"]', '[["abc","bca","cab"]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["",""]', '[["",""]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["a","b","a","c","b"]', '[["a","a"],["b","b"],["c"]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["listen","silent","hello","enlist"]', '[["enlist","listen","silent"],["hello"]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'anagram-groups'), '["aaa","aaa","aaa"]', '[["aaa","aaa","aaa"]]', FALSE, 10);

-- ============================================================
-- #10 array-kth-largest
-- ============================================================
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-kth-largest')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'array-kth-largest')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[7,7,7,7,7]\n3', '7', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[-1,2,0,-3,5]\n1', '5', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[5,3,1,6,4,2]\n6', '1', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[-1,-2,-3,-4,-5]\n1', '-1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[-1,-2,-3,-4,-5]\n5', '-5', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[1,2,3,4,5,6,7,8,9,10]\n5', '6', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[10,9,8,7,6,5,4,3,2,1]\n5', '6', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[100]\n1', '100', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[1,1,1,2,2,2,3,3,3]\n4', '2', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'array-kth-largest'), E'[0,0,0,0,0]\n3', '0', FALSE, 13);
