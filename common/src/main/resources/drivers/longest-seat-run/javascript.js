{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const seatIds = JSON.parse(input);
const result = new Solution().longestSeatRun(seatIds);
console.log(result);
