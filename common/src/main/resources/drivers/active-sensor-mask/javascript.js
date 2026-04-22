{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const n = parseInt(input);
const result = new Solution().countActiveSensors(n);
console.log(result);
