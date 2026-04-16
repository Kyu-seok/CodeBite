{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const s = input.split('\n')[0];
const result = new Solution().rearrangeLetters(s);
if (!result || result.length === 0) {
    console.log("");
} else {
    const freqOk = [...s].sort().join('') === [...result].sort().join('');
    let noAdj = true;
    for (let i = 1; i < result.length; i++) {
        if (result[i] === result[i - 1]) { noAdj = false; break; }
    }
    if (freqOk && noAdj) {
        console.log("valid");
    } else {
        console.log("INVALID:" + result);
    }
}
