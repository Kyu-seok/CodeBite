{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const prevRoom = JSON.parse(input);
const result = new Solution().waysToBuildRooms(prevRoom);
console.log(result);
