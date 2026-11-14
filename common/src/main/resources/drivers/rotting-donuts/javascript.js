{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const tray = JSON.parse(input);
const result = new Solution().minutesUntilStale(tray);
console.log(result);
