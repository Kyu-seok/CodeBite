{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const parent = JSON.parse(input);
const result = new Solution().countTaskOrders(parent);
console.log(result);
