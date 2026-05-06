{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const height = JSON.parse(input);
const result = new Solution().trap(height);
console.log(result);
