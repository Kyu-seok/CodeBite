{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const maxJump = JSON.parse(input);
const result = new Solution().minJumps(maxJump);
console.log(result);
