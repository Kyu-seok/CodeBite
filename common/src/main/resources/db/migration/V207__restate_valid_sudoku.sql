-- V207: restate valid-sudoku (#167). The English constraints named the board `grid`
-- while the statement, the examples, the Korean constraints and the Starter Code
-- (isValidSudoku(board)) name it `board`. Slug, title, description, Test Cases,
-- Starter Code and Drivers are unchanged.

UPDATE problems SET
    constraints = $$- `board.length == 9`
- `board[i].length == 9`
- Each `board[i][j]` is a digit `'1'`–`'9'` or the character `'.'`.$$
WHERE slug = $$valid-sudoku$$;
