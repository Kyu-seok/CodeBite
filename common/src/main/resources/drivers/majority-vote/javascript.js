{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const votes = JSON.parse(lines[0]);
const result = new Solution().majorityVote(votes);
console.log(result);
