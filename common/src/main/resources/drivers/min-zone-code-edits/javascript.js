{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const result = new Solution().minZoneEdits(lines[0], lines[1]);
console.log(result);
