{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const readings = JSON.parse(input);
const result = new Solution().daysUntilWarmer(readings);
console.log(JSON.stringify(result));
