{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const stickers = input;
const result = new Solution().splitStickerRuns(stickers);
console.log(JSON.stringify(result));
