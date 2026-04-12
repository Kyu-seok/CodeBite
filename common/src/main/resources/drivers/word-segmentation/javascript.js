{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const s = lines[0];
const wordDict = JSON.parse(lines[1]);
console.log(new Solution().wordBreak(s, wordDict));
