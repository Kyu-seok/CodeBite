{USER_CODE}

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const accounts = JSON.parse(input);
const result = new Solution().accountsMerge(accounts);
// Sort emails within each account, then sort by first email
result.forEach(account => {
    const name = account[0];
    const emails = account.slice(1).sort();
    account.length = 1;
    account.push(...emails);
});
result.sort((a, b) => a[1] < b[1] ? -1 : a[1] > b[1] ? 1 : 0);
console.log(JSON.stringify(result));
