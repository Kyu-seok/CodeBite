{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().countScanDecodings(input);
console.log(result);
