{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const edges = JSON.parse(input);
const result = new Solution().spotRedundantLink(edges);
console.log(JSON.stringify(result));
