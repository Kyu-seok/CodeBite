-- V117: Regenerate hidden test cases for batch 20 problems
-- Problems: valid-tree, water-container, window-maximum, word-chain, word-dictionary,
--           word-finder, word-search, word-segmentation, zero-matrix, zigzag-levels

-- valid-tree
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-tree')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'valid-tree')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'1\n[]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'2\n[[0,1]]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'6\n[[0,1],[1,2],[2,3],[3,4],[4,5]]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'5\n[[0,1],[0,2],[0,3],[2,4]]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'5\n[[0,1],[0,2],[0,3],[1,4],[2,4]]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'2\n[]', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'3\n[[0,1]]', 'false', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'4\n[[0,1],[1,2],[2,0]]', 'false', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'7\n[[0,1],[0,2],[1,3],[1,4],[2,5],[2,6]]', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'valid-tree'), E'3\n[[0,1],[0,2],[1,2]]', 'false', FALSE, 13);

-- water-container
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'water-container')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'water-container')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,2,4,3]', '4', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[2,3,4,5,18,17,6]', '17', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[10,9,8,7,6,5,4,3,2,1]', '25', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,2,3,4,5,6,7,8,9,10]', '25', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[5,5,5,5,5]', '20', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,1000,1000,1]', '1000', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[10000,1,10000]', '20000', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,2,1]', '2', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[3,1,2,4,5]', '12', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'water-container'), '[1,8,6,2,5,4,8,25,7]', '49', FALSE, 12);

-- window-maximum
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'window-maximum')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'window-maximum')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[9,8,7,6,5]\n2', '[9,8,7,6]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[1,2,3,4,5]\n3', '[3,4,5]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[5,5,5,5,5]\n2', '[5,5,5,5]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[-1,-3,-5,-2,0]\n2', '[-1,-3,-2,0]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[1,3,1,2,0,5]\n3', '[3,3,2,5]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[4,3,11]\n3', '[11]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[10,9,8,7,6,5,4,3,2,1]\n5', '[10,9,8,7,6,5]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[1,-1]\n1', '[1,-1]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[3,3,3,3]\n1', '[3,3,3,3]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'window-maximum'), E'[2,1,3,4,6,3,8,9,10,12,56]\n4', '[4,6,6,8,9,10,12,56]', FALSE, 12);

-- word-chain
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-chain')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-chain')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'cat\ndog\n["cot","dot","dog","cag","dag"]', '4', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'aaa\nbbb\n["aab","abb","bbb"]', '4', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'ab\ncd\n["ad","cd"]', '3', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'ab\nba\n["bb","ba"]', '3', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'hot\ndog\n["hot","dog"]', '0', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'abc\ndef\n["abc","dec","def"]', '0', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'aaa\nccc\n["aab","aac","bac","bcc","ccc"]', '5', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'leet\ncode\n["leet","code"]', '0', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'word-chain'), E'ab\nef\n["ac","ad","ed","ef"]', '4', FALSE, 12);

-- word-dictionary
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-dictionary')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","addWord","search","search","search"]\n[[],["hello"],["world"],["hello"],["worl."],["....d"]]', '[null,null,null,true,true,true]', FALSE, 2),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","search","search","search"]\n[[],["a"],["a"],["."],[".."]]', '[null,null,true,true,false]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","addWord","addWord","search","search","search","search"]\n[[],["at"],["and"],["an"],["a"],[".at"],[".an"],["a.d."]]', '[null,null,null,null,false,false,false,false]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","addWord","search","search","search","search"]\n[[],["ab"],["ac"],["a."],[".."],["b."],["a"]]', '[null,null,null,true,true,false,false]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","search"]\n[[],["abc"]]', '[null,false]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","addWord","addWord","search","search","search"]\n[[],["abc"],["abd"],["xyz"],["..."],["ab."],["a.."]]', '[null,null,null,null,true,true,true]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","addWord","search","search","search"]\n[[],["bat"],["bar"],["ba."],["b.."],["..."]]', '[null,null,null,true,true,true]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'word-dictionary'), E'["WordDictionary","addWord","addWord","addWord","search","search","search"]\n[[],["a"],["ab"],["abc"],["a"],["ab"],["abc"]]', '[null,null,null,null,true,true,true]', FALSE, 9);

-- word-finder
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-finder')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-finder')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["a"]]\n["a"]', '["a"]', FALSE, 3),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["a","b"],["c","d"]]\n["ab","ac","ca"]', '["ab","ac","ca"]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["a","a"]]\n["aaa"]', '[]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["a","b","c"],["d","e","f"],["g","h","i"]]\n["abc","cfi","beh","defi","gh"]', '["abc","beh","cfi","defi","gh"]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["x","y"],["z","w"]]\n["xy","xz","yw"]', '["xy","xz","yw"]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["a","b"],["c","d"]]\n["abdc","acdb"]', '["abdc","acdb"]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["z"]]\n["z","zz"]', '["z"]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'word-finder'), E'[["a","a"],["a","a"]]\n["a","aa"]', '["a","aa"]', FALSE, 10);

-- word-search
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-search')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-search')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A"]]\nA', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A"]]\nB', 'false', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A","B"],["C","D"]]\nABDC', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A","B"],["C","D"]]\nABCD', 'false', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A","A","A"],["A","A","A"],["A","A","A"]]\nAAAAAAAAA', 'true', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A","B","C"],["D","E","F"],["G","H","I"]]\nAEI', 'false', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["C","A","A"],["A","A","A"],["B","C","D"]]\nAAB', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'word-search'), E'[["A","B","C","E"],["S","F","E","S"],["A","D","E","E"]]\nABCESEEEFS', 'true', FALSE, 11);

-- word-segmentation
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-segmentation')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'word-segmentation')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'a\n["a"]', 'true', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'ab\n["a","b"]', 'true', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'abcd\n["a","abc","b","cd"]', 'true', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'aaaaaaa\n["aaa","aaaa"]', 'true', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'aaaaaab\n["aaa","aaaa"]', 'false', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'leetcode\n["leet","code"]', 'true', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'goalspecial\n["go","goal","goals","special"]', 'true', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'catsanddog\n["cats","dog","sand","and","cat"]', 'true', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'aaaa\n["aa"]', 'true', FALSE, 12),
    ((SELECT id FROM problems WHERE slug = 'word-segmentation'), E'bb\n["a","b","bbb","bbbb"]', 'true', FALSE, 13);

-- zero-matrix
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zero-matrix')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zero-matrix')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[0]]', '[[0]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,0],[0,1]]', '[[0,0],[0,0]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,2,3],[4,0,6],[7,8,9]]', '[[1,0,3],[0,0,0],[7,0,9]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[0,0,0],[0,0,0]]', '[[0,0,0],[0,0,0]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,2,3,4],[5,0,7,8],[9,10,11,12],[13,14,15,0]]', '[[1,0,3,0],[0,0,0,0],[9,0,11,0],[0,0,0,0]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,0,3],[0,5,6]]', '[[0,0,0],[0,0,0]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[5]]', '[[5]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[1,2],[3,4],[5,0]]', '[[1,0],[3,0],[0,0]]', FALSE, 11),
    ((SELECT id FROM problems WHERE slug = 'zero-matrix'), '[[0,1,2,0],[3,4,5,2],[1,3,1,5]]', '[[0,0,0,0],[0,4,5,0],[0,3,1,0]]', FALSE, 12);

-- zigzag-levels
DELETE FROM submission_results
WHERE test_case_id IN (
    SELECT id FROM test_cases
    WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zigzag-levels')
      AND is_sample = FALSE
);

DELETE FROM test_cases
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'zigzag-levels')
  AND is_sample = FALSE;

INSERT INTO test_cases (problem_id, input, expected_output, is_sample, order_index)
VALUES
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,2,3,4,5,6,7]', '[[1],[3,2],[4,5,6,7]]', FALSE, 4),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,2,null,3,null,4]', '[[1],[2],[3],[4]]', FALSE, 5),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[5,1,4,null,null,3,6]', '[[5],[4,1],[3,6]]', FALSE, 6),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,2,3,null,null,4,5]', '[[1],[3,2],[4,5]]', FALSE, 7),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[0,-1,1]', '[[0],[1,-1]]', FALSE, 8),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,2,3,4,null,null,5]', '[[1],[3,2],[4,5]]', FALSE, 9),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[10,20,30,40,50,60,70,80]', '[[10],[30,20],[40,50,60,70],[80]]', FALSE, 10),
    ((SELECT id FROM problems WHERE slug = 'zigzag-levels'), '[1,null,2,null,3,null,4]', '[[1],[2],[3],[4]]', FALSE, 11);
