{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const queue = lines[0].trim();
const k = parseInt(lines[1]);
const result = new Solution().longestKGenreWindow(queue, k);
console.log(result);
