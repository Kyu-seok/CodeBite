{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const tags = JSON.parse(input);
const result = new Solution().recoverTierOrder(tags);
console.log(result);
