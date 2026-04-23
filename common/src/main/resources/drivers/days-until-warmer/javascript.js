{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const temperatures = JSON.parse(input);
const result = new Solution().daysToUpgrade(temperatures);
console.log(JSON.stringify(result));
