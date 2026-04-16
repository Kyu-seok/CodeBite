{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const rooms = JSON.parse(input);
const result = new Solution().canVisitAllRooms(rooms);
console.log(result);
