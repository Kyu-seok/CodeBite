{USER_CODE}

function _buildList(arr) {
    let dummy = new ListNode(0);
    let curr = dummy;
    for (const v of arr) {
        curr.next = new ListNode(v);
        curr = curr.next;
    }
    return dummy.next;
}

function _listToArray(head) {
    const result = [];
    while (head) {
        result.push(head.val);
        head = head.next;
    }
    return result;
}

const lines = require('fs').readFileSync('/dev/stdin', 'utf8').trim().split('\n');
const arr = JSON.parse(lines[0]);
const k = parseInt(lines[1]);
const head = _buildList(arr);
const result = new Solution().flipSorterSegments(head, k);
console.log(JSON.stringify(_listToArray(result)));
