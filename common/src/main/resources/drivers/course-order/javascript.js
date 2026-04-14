{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const numCourses = parseInt(lines[0]);
const prerequisites = JSON.parse(lines[1]);
const result = new Solution().findOrder(numCourses, prerequisites);
console.log(JSON.stringify(result));
