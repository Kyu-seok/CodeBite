{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const bowls = JSON.parse(lines[0]);
const result = new Solution().minHoseLength(bowls);
console.log(result);
