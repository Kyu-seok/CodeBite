{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const beginWord = lines[0].trim();
const endWord = lines[1].trim();
const wordList = JSON.parse(lines[2].trim());
const result = new Solution().bridgeLabelChain(beginWord, endWord, wordList);
console.log(result);
