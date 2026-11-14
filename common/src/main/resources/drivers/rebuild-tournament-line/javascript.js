{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const players = JSON.parse(input);
const result = new Solution().rebuildLine(players);
console.log(JSON.stringify(result));
