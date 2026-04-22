{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const candidates = JSON.parse(lines[0]);
const target = parseInt(lines[1]);
const result = new Solution().listVoucherSums(candidates, target);
result.forEach(c => c.sort((a, b) => a - b));
result.sort((a, b) => {
    for (let i = 0; i < Math.min(a.length, b.length); i++) {
        if (a[i] !== b[i]) return a[i] - b[i];
    }
    return a.length - b.length;
});
console.log(JSON.stringify(result));
