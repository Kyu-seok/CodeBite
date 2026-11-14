{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const zones = JSON.parse(input);
const result = new Solution().minPellets(zones);
console.log(result);
