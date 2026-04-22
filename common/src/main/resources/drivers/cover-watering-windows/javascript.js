{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const targets = JSON.parse(input);
const result = new Solution().coverAllWindows(targets);
console.log(result);
