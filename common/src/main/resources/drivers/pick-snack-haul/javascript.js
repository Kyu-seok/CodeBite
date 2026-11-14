{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const snacks = JSON.parse(input);
const result = new Solution().maxSnackHaul(snacks);
console.log(result);
