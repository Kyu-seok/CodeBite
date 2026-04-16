{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const matrix = JSON.parse(input);
const result = new Solution().largestSquare(matrix);
console.log(result);
