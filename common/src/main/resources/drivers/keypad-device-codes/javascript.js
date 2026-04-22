{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().mapKeypadCodes(input).sort();
console.log(JSON.stringify(result));
