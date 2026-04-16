{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const items = JSON.parse(input);
const result = new Solution().fruitPicker(items);
console.log(result);
