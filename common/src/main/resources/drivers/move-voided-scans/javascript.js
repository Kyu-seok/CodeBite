{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const scans = JSON.parse(input);
new Solution().moveVoidsToEnd(scans);
console.log(JSON.stringify(scans));
