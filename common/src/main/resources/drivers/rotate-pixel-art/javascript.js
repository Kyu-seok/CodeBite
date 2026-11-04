{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const image = JSON.parse(input);
new Solution().rotateImage(image);
console.log(JSON.stringify(image));
