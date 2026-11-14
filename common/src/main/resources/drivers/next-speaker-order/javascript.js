{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lineup = JSON.parse(input);
new Solution().nextLineup(lineup);
console.log(JSON.stringify(lineup));
