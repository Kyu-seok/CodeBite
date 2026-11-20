{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const nums = JSON.parse(input);
const result = new Solution().pinpointPeak(nums.slice());

function isReturnedPeak(readings, i) {
    const n = readings.length;
    if (!Number.isInteger(i) || i < 0 || i >= n) return false;
    return (i === 0 || readings[i] > readings[i - 1]) && (i === n - 1 || readings[i] > readings[i + 1]);
}

console.log(isReturnedPeak(nums, result) ? "VALID" : "INVALID:" + result);
