{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const shelf = JSON.parse(input);
const result = new Solution().spiralOrder(shelf);
console.log(JSON.stringify(result));
