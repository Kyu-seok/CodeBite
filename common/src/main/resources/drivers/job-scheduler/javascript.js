{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const jobs = JSON.parse(lines[0]);
const n = parseInt(lines[1]);
const result = new Solution().scheduleJobs(jobs, n);
console.log(result);
