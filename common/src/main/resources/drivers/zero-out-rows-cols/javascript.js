{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const matrix = JSON.parse(input);
new Solution().clearDefectRows(matrix);
console.log(JSON.stringify(matrix));
