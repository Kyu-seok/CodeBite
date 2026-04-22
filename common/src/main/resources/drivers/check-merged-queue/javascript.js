{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').split('\n');
const s1 = input[0] || '';
const s2 = input[1] || '';
const s3 = input[2] || '';
const result = new Solution().checkMergedQueue(s1, s2, s3);
console.log(result);
