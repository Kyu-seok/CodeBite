{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const people = JSON.parse(input);
const result = new Solution().orderTicketHolders(people);
console.log(JSON.stringify(result));
