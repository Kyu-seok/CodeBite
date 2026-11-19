{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const balloons = JSON.parse(input);
const result = new Solution().maxPopPoints(balloons);
console.log(result);
