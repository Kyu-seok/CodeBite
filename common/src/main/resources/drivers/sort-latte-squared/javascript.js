{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const drifts = JSON.parse(input);
const result = new Solution().sortedSquaredDrifts(drifts);
console.log(JSON.stringify(result));
