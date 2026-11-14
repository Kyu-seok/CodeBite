{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const message = lines[0];
const words = JSON.parse(lines[1]);
console.log(new Solution().canSplitMessage(message, words));
