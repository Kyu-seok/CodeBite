{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const grid = JSON.parse(input);
const result = new Solution().minWaitRoute(grid);
console.log(result);
