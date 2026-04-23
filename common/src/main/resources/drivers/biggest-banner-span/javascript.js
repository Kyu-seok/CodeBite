{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const heights = JSON.parse(input);
const result = new Solution().widestVineBlock(heights);
console.log(result);
