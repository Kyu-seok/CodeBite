{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const numCourses = parseInt(lines[0]);
const prerequisites = JSON.parse(lines[1]);
const result = new Solution().canFinish(numCourses, prerequisites);
console.log(result);
