{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const matrix = JSON.parse(input);
new Solution().rotateParkMap(matrix);
console.log(JSON.stringify(matrix));
