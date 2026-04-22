{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const stones = JSON.parse(input);
const result = new Solution().crushHeaviestBales(stones);
console.log(result);
