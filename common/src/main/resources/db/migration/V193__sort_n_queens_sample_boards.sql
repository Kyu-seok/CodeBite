-- n-queens (#78): every driver sorts the boards (row by row, '.' before 'Q') before printing,
-- but V124 gave sample test case 1 (n = 5) its boards in backtracking order, so no language
-- could pass it. List the same ten boards in the drivers' order, as the hidden n = 5 case does.
UPDATE test_cases
SET expected_output = '[["....Q","..Q..","Q....","...Q.",".Q..."],["....Q",".Q...","...Q.","Q....","..Q.."],["...Q.",".Q...","....Q","..Q..","Q...."],["...Q.","Q....","..Q..","....Q",".Q..."],["..Q..","....Q",".Q...","...Q.","Q...."],["..Q..","Q....","...Q.",".Q...","....Q"],[".Q...","....Q","..Q..","Q....","...Q."],[".Q...","...Q.","Q....","..Q..","....Q"],["Q....","...Q.",".Q...","....Q","..Q.."],["Q....","..Q..","....Q",".Q...","...Q."]]'
WHERE problem_id = (SELECT id FROM problems WHERE slug = 'n-queens')
  AND is_sample = TRUE
  AND order_index = 1
  AND input = '5';
