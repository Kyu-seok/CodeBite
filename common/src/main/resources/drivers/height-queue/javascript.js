{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const people = JSON.parse(input);
const result = new Solution().reconstructQueue(people);
console.log(JSON.stringify(result));
