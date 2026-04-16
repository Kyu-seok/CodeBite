{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const x = parseInt(input);
const result = new Solution().isMirror(x);
console.log(result);
