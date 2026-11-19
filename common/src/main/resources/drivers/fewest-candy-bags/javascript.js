{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const bagSizes = JSON.parse(lines[0]);
const quota = parseInt(lines[1]);
console.log(new Solution().fewestBags(bagSizes, quota));
