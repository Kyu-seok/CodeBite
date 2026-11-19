{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const visits = JSON.parse(input);
const result = new Solution().minTables(visits);
console.log(result);
