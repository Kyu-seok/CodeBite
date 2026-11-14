{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const pricesA = JSON.parse(lines[0]);
const pricesB = JSON.parse(lines[1]);
const result = new Solution().mergedPriceMedian(pricesA, pricesB);
console.log(result.toFixed(1));
