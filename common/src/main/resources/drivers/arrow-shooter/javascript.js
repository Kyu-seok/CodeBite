{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const targets = JSON.parse(input);
const result = new Solution().findMinArrows(targets);
console.log(result);
