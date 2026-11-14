{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const board = JSON.parse(input);
new Solution().captureEnclosedTiles(board);
console.log(JSON.stringify(board));
