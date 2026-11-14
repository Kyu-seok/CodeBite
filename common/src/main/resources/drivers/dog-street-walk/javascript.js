{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const routes = JSON.parse(input);
const result = new Solution().planWalk(routes);
console.log(JSON.stringify(result));
