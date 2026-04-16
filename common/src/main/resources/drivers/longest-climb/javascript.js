{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const matrix = JSON.parse(input);
console.log(new Solution().longestClimb(matrix));
