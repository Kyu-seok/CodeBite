{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const tastiness = JSON.parse(input);
const result = new Solution().maxTastiness(tastiness);
console.log(result);
