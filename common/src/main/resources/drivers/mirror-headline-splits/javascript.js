{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const result = new Solution().splitMirrorPhrases(input);
result.sort((a, b) => {
    for (let i = 0; i < Math.min(a.length, b.length); i++) {
        if (a[i] < b[i]) return -1;
        if (a[i] > b[i]) return 1;
    }
    return a.length - b.length;
});
console.log(JSON.stringify(result));
