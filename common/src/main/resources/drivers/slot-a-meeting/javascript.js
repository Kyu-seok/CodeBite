{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const meetings = JSON.parse(lines[0]);
const newMeeting = JSON.parse(lines[1]);
const result = new Solution().insertMeeting(meetings, newMeeting);
console.log(JSON.stringify(result));
