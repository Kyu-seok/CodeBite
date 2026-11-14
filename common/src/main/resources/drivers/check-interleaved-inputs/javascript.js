{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').split('\n');
const controllerA = input[0] || '';
const controllerB = input[1] || '';
const merged = input[2] || '';
const result = new Solution().isInterleaving(controllerA, controllerB, merged);
console.log(result);
