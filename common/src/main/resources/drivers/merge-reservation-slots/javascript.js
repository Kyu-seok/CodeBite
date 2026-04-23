{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const intervals = JSON.parse(input);
const result = new Solution().mergeSeatingWindows(intervals);
console.log(JSON.stringify(result));
