{USER_CODE}

const feed = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().longestGenreWindow(feed);
console.log(result);
