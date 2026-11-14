{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const bags = JSON.parse(lines[0]);
const target = JSON.parse(lines[1]);
const result = new Solution().canMatchTarget(bags, target);
console.log(result);
