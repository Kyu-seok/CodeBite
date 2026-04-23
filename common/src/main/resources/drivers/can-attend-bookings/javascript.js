{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const intervals = JSON.parse(input);
const result = new Solution().verifyTableBookings(intervals);
console.log(result);
