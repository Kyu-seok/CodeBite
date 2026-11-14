{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const notes = lines[0].trim();
const target = lines[1].trim();
const result = new Solution().countHintMatches(notes, target);
console.log(result);
