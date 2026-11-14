{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const cards = JSON.parse(lines[0]);
const groupSize = parseInt(lines[1]);
const result = new Solution().canGroupCards(cards, groupSize);
console.log(result);
