{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const numRows = parseInt(input);
const result = new Solution().generate(numRows);
console.log(JSON.stringify(result));
