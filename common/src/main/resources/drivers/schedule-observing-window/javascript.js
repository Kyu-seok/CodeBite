{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const intervals = JSON.parse(lines[0]);
const newInterval = JSON.parse(lines[1]);
const result = new Solution().scheduleObservingWindow(intervals, newInterval);
console.log(JSON.stringify(result));
