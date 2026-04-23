{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const graph = JSON.parse(input);
const result = new Solution().splitIntoTwoShifts(graph);
console.log(result);
