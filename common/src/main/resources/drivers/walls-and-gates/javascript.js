{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const rooms = JSON.parse(input);
new Solution().wallsAndGates(rooms);
console.log(JSON.stringify(rooms));
