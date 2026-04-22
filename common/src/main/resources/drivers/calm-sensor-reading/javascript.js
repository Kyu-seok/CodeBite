{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const n = parseInt(input);
const result = new Solution().isCalmReading(n);
console.log(JSON.stringify(result));
