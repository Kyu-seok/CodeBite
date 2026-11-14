{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const codes = JSON.parse(input);
const result = new Solution().listRepeatedCodes(codes);
result.sort((a, b) => a - b);
console.log(JSON.stringify(result));
