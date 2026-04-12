{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const grid = JSON.parse(input);
const result = new Solution().numIslands(grid);
console.log(result);
