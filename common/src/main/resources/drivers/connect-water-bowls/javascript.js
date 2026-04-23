{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const points = JSON.parse(lines[0]);
const result = new Solution().layPipeNetwork(points);
console.log(result);
