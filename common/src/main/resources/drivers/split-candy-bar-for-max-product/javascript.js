{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const length = parseInt(input);
const result = new Solution().maxSplitProduct(length);
console.log(result);
