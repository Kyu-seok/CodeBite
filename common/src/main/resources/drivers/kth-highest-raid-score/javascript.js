{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const scores = JSON.parse(lines[0]);
const k = parseInt(lines[1]);
const result = new Solution().kthHighestScore(scores, k);
console.log(result);
