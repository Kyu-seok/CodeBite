class Solution {
    captureEnclosedTiles(board) {
        const rows = board.length, cols = board[0].length;
        const stack = [];
        for (let r = 0; r < rows; r++)
            for (let c = 0; c < cols; c++)
                if ((r === 0 || r === rows - 1 || c === 0 || c === cols - 1) && board[r][c] === 'O')
                    stack.push([r, c]);
        while (stack.length) {
            const [r, c] = stack.pop();
            if (r < 0 || r >= rows || c < 0 || c >= cols || board[r][c] !== 'O') continue;
            board[r][c] = 'S';
            stack.push([r + 1, c], [r - 1, c], [r, c + 1], [r, c - 1]);
        }
        for (const row of board)
            for (let c = 0; c < cols; c++)
                row[c] = row[c] === 'S' ? 'O' : 'X';
    }
}
