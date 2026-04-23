{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const lines = input.split('\n');
const nums1 = JSON.parse(lines[0]);
const nums2 = JSON.parse(lines[1]);
const result = new Solution().mergedZoneMedian(nums1, nums2);
console.log(result.toFixed(1));
