{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const points = JSON.parse(lines[0]);
const k = parseInt(lines[1]);
const result = new Solution().kClosest(points, k);
result.sort((a, b) => a[0] !== b[0] ? a[0] - b[0] : a[1] - b[1]);
console.log(JSON.stringify(result));
