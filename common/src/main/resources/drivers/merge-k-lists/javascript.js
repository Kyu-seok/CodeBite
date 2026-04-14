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

const input = require('fs').readFileSync('/dev/stdin', 'utf8').trim();
const data = JSON.parse(input);
const lists = data.map(arr => _buildList(arr));
const result = new Solution().mergeKLists(lists);
console.log(JSON.stringify(_listToArray(result)));
