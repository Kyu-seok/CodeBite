{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const friendMask = parseInt(input);
const result = new Solution().countOnlineFriends(friendMask);
console.log(result);
