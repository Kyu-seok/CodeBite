{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const grid = JSON.parse(input);
const result = new Solution().tallyPlantedRegions(grid);
console.log(result);
