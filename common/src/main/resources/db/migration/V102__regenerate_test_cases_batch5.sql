-- Regenerate hidden test cases for Batch 5 problems
-- All test cases validated against Judge0 (Python, language_id=71)

------------------------------------------------------------
-- duplicate-finder (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-finder')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'duplicate-finder')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,2,3,4,5,6,7,8,9,10]', '[]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,1,2,2,3,3,4,4,5,5]', '[1,2,3,4,5]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[3,1,2,5,4,6,7,8,9,10,3,1]', '[1,3]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,2,3,4,5,5,6,6,7,7,8,8]', '[5,6,7,8]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[2,2,1,1]', '[1,2]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[10,2,5,10,9,1,8,7,3,4,6,5]', '[5,10]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,3,4,2,2,3]', '[2,3]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'duplicate-finder'), '[1,2,3,4,5,6,7,8,9,10,10,9]', '[9,10]', FALSE, 11);

------------------------------------------------------------
-- edit-distance (2 samples, hidden starts at 3)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'edit-distance')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'edit-distance')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'a\nb', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'abc\naxc', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'kitten\nsitting', '3', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'saturday\nsunday', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'ab\nba', '2', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'plasma\naltruism', '6', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'abc\ndef', '3', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'a\na', '0', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'edit-distance'), E'abcd\nabdc', '2', FALSE, 11);

------------------------------------------------------------
-- equal-partition (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equal-partition')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equal-partition')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[2,2,2,2]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,2,3,4,5,5]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,1,1,1,1,1,1,1,1,1]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[100,100]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,2,3,4,6]', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[23,13,11,7,6,5,5]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[1,1,2,2,3,3,4,4]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'equal-partition'), '[99,1]', 'false', FALSE, 11);

------------------------------------------------------------
-- equation-solver (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equation-solver')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'equation-solver')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["b","c"],["c","d"],["d","e"]]\n[2.0,3.0,4.0,5.0]\n[["a","e"],["e","a"],["a","a"],["f","f"]]', '[120.00000,0.00833,1.00000,-1.00000]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"]]\n[5.0]\n[["a","b"],["b","a"],["a","a"],["b","b"]]', '[5.00000,0.20000,1.00000,1.00000]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["c","d"],["e","f"],["a","c"]]\n[2.0,3.0,4.0,6.0]\n[["a","f"],["b","d"],["c","e"],["e","b"]]', '[-1.00000,9.00000,-1.00000,-1.00000]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["b","a"]]\n[2.0,0.5]\n[["a","b"],["b","a"],["a","a"]]', '[2.00000,0.50000,1.00000]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["a","b"],["b","c"]]\n[3.0,4.0]\n[["c","a"],["a","b"],["b","c"],["c","c"]]', '[0.08333,3.00000,4.00000,1.00000]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["x","y"]]\n[2.0]\n[["y","x"],["x","y"],["x","x"],["y","y"],["z","z"]]', '[0.50000,2.00000,1.00000,1.00000,-1.00000]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'equation-solver'), E'[["m","n"],["n","o"],["o","p"],["p","q"]]\n[1.5,2.5,3.5,4.5]\n[["m","q"],["q","m"],["n","p"]]', '[59.06250,0.01693,8.75000]', FALSE, 10);

------------------------------------------------------------
-- extra-edge (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'extra-edge')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'extra-edge')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[1,3],[1,4],[2,5],[2,3]]', '[2,3]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[3,4],[1,3],[2,4]]', '[2,4]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[2,3],[3,4],[4,1],[4,5],[5,6]]', '[4,1]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[2,3],[1,2],[1,3]]', '[1,3]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[3,4],[2,3],[5,6],[4,5],[6,1]]', '[6,1]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[2,3],[3,4],[4,2]]', '[4,2]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[1,2],[1,3],[2,3],[4,5],[3,4]]', '[2,3]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'extra-edge'), '[[5,1],[1,2],[2,3],[3,4],[4,5]]', '[4,5]', FALSE, 11);

------------------------------------------------------------
-- feed-designer (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'feed-designer')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","follow","postMessage","getNewsFeed","unfollow","getNewsFeed","follow","getNewsFeed"]\n[[],[1,2],[2,100],[1],[1,2],[1],[1,2],[1]]', '[null,null,null,[100],null,[],null,[100]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","postMessage","postMessage","follow","follow","follow","getNewsFeed"]\n[[],[1,1],[2,2],[3,3],[4,1],[4,2],[4,3],[4]]', '[null,null,null,null,null,null,null,[3,2,1]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","getNewsFeed"]\n[[],[1]]', '[null,[]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","follow","postMessage","postMessage","getNewsFeed"]\n[[],[1,2],[2,50],[2,60],[1]]', '[null,null,null,null,[60,50]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","follow","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","postMessage","getNewsFeed"]\n[[],[1,2],[1,1],[2,2],[1,3],[2,4],[1,5],[2,6],[1,7],[2,8],[1,9],[2,10],[1,11],[2,12],[1]]', '[null,null,null,null,null,null,null,null,null,null,null,null,null,null,[12,11,10,9,8,7,6,5,4,3]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","follow","getNewsFeed"]\n[[],[1,99],[1,1],[1]]', '[null,null,null,[99]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'feed-designer'), E'["FeedDesigner","postMessage","unfollow","getNewsFeed"]\n[[],[1,42],[1,2],[1]]', '[null,null,null,[42]]', FALSE, 10);

------------------------------------------------------------
-- find-duplicates (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-duplicates')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-duplicates')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[-1,0,1]', 'false', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1,1]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1000000000,1000000000]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[1,2,3,4,5,6,7,8,9,10]', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[-1000000000,1000000000]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[0,0,0,0]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[5]', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'find-duplicates'), '[2,14,18,22,22]', 'true', FALSE, 11);

------------------------------------------------------------
-- find-peak (2 samples, hidden starts at 3)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-peak')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'find-peak')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2]', '1', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[2,1]', '0', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,3,1]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2,3,4,5,6,7,8,9,10]', '9', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[10,9,8,7,6,5,4,3,2,1]', '0', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2,3,4,5,4,3,2,1]', '4', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[1,2,3,2,1]', '2', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'find-peak'), '[5,10,5]', '1', FALSE, 10);

------------------------------------------------------------
-- first-missing-positive (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'first-missing-positive')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'first-missing-positive')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[2]', '1', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[-1,-2,-3]', '1', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[1,2,3,4,5,6,7,8,9,10,11,12]', '13', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[2,3,4,5,6,7]', '1', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[1,1,1,1]', '2', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[0,0,0]', '1', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[2,1]', '3', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'first-missing-positive'), '[100,200,300]', '1', FALSE, 11);

------------------------------------------------------------
-- fizz-buzz-game (3 samples, hidden starts at 4)
------------------------------------------------------------
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fizz-buzz-game')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'fizz-buzz-game')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '2', '["1","2"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '4', '["1","2","Fizz","4"]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '6', '["1","2","Fizz","4","Buzz","Fizz"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '10', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz"]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '20', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz","16","17","Fizz","19","Buzz"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '45', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz","16","17","Fizz","19","Buzz","Fizz","22","23","Fizz","Buzz","26","Fizz","28","29","FizzBuzz","31","32","Fizz","34","Buzz","Fizz","37","38","Fizz","Buzz","41","Fizz","43","44","FizzBuzz"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'fizz-buzz-game'), '50', '["1","2","Fizz","4","Buzz","Fizz","7","8","Fizz","Buzz","11","Fizz","13","14","FizzBuzz","16","17","Fizz","19","Buzz","Fizz","22","23","Fizz","Buzz","26","Fizz","28","29","FizzBuzz","31","32","Fizz","34","Buzz","Fizz","37","38","Fizz","Buzz","41","Fizz","43","44","FizzBuzz","46","47","Fizz","49","Buzz"]', FALSE, 10);
