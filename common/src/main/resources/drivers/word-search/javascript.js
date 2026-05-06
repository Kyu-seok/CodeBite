{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const board = JSON.parse(lines[0]);
const word = lines[1];
const result = new Solution().exist(board, word);
console.log(JSON.stringify(result));
