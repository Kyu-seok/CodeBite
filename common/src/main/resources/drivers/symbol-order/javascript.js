{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const words = JSON.parse(input);
const result = new Solution().symbolOrder(words);
console.log(result);
