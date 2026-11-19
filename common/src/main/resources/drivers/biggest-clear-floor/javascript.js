{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const matrix = JSON.parse(input);
const result = new Solution().biggestClearFloor(matrix);
console.log(result);
