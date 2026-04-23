{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const grid = JSON.parse(input);
console.log(new Solution().crossFloodedCorridors(grid));
