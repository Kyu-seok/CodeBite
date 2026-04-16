{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const rocks = JSON.parse(input);
const result = new Solution().spaceRocks(rocks);
console.log(JSON.stringify(result));
