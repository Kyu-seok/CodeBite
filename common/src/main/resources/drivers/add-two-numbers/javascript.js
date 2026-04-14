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
const arr1 = JSON.parse(lines[0]);
const arr2 = JSON.parse(lines[1]);
const l1 = _buildList(arr1);
const l2 = _buildList(arr2);
const result = new Solution().addTwoNumbers(l1, l2);
console.log(JSON.stringify(_listToArray(result)));
