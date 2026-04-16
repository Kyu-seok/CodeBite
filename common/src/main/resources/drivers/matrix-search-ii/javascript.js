{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const matrix = JSON.parse(lines[0]);
const target = parseInt(lines[1]);
const result = new Solution().searchMatrix(matrix, target);
console.log(result);
