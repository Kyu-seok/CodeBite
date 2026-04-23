{USER_CODE}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const arr = JSON.parse(lines[0]);
const pos = parseInt(lines[1]);

const nodes = [];
let dummy = new ListNode(0);
let curr = dummy;
for (const v of arr) {
    curr.next = new ListNode(v);
    curr = curr.next;
    nodes.push(curr);
}

const head = dummy.next;
if (pos >= 0 && nodes.length > 0) {
    nodes[nodes.length - 1].next = nodes[pos];
}

const result = new Solution().detectTransferLoop(head);
console.log(JSON.stringify(result));
