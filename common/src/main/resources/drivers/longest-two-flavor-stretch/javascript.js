{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const treats = JSON.parse(input);
const result = new Solution().longestTwoFlavorStretch(treats);
console.log(result);
