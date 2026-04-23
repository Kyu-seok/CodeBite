{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const target = parseInt(lines[0]);
const position = JSON.parse(lines[1]);
const speed = JSON.parse(lines[2]);
const result = new Solution().groupTrainPacks(target, position, speed);
console.log(result);
