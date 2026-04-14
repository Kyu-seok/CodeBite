{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const heights = JSON.parse(input);
const result = new Solution().pacificAtlantic(heights);
result.sort((a, b) => a[0] !== b[0] ? a[0] - b[0] : a[1] - b[1]);
console.log(JSON.stringify(result));
