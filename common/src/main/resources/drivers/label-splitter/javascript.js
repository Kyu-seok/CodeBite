{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const s = input;
const result = new Solution().splitLabels(s);
console.log(JSON.stringify(result));
