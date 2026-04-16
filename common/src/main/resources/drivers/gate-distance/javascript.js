{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const grid = JSON.parse(input);
new Solution().gateDistance(grid);
console.log(JSON.stringify(grid));
