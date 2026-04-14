{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const stones = JSON.parse(input);
const result = new Solution().lastStoneWeight(stones);
console.log(result);
