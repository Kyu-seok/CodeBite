{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const pairCount = parseInt(input);
const result = new Solution().listBracketPairings(pairCount);
result.sort();
console.log(JSON.stringify(result));
