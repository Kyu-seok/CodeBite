{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const board = JSON.parse(lines[0]);
const words = JSON.parse(lines[1]);
const result = new Solution().flagMaterialCodes(board, words).sort();
console.log(JSON.stringify(result));
