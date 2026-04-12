{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const board = JSON.parse(input);
const result = new Solution().isValidSudoku(board);
console.log(result);
