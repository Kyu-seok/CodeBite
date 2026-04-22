{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const digits = JSON.parse(input);
const result = new Solution().bumpParcelCode(digits);
console.log(JSON.stringify(result));
