{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const reading = parseInt(input);
const result = new Solution().isCalm(reading);
console.log(JSON.stringify(result));
