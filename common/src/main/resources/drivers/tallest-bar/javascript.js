{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const heights = JSON.parse(input);
const result = new Solution().largestRectangle(heights);
console.log(result);
