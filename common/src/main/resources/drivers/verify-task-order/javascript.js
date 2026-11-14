{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const numTasks = parseInt(lines[0]);
const prereqs = JSON.parse(lines[1]);
const result = new Solution().canFinishAllTasks(numTasks, prereqs);
console.log(result);
