{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const intervals = JSON.parse(lines[0]);
const queries = JSON.parse(lines[1]);
const result = new Solution().findTightestBooking(intervals, queries);
console.log(JSON.stringify(result));
