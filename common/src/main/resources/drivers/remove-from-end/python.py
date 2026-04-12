{USER_CODE}

import json

def _build_list(arr):
    dummy = ListNode(0)
    curr = dummy
    for v in arr:
        curr.next = ListNode(v)
        curr = curr.next
    return dummy.next

def _list_to_array(head):
    result = []
    while head:
        result.append(head.val)
        head = head.next
    return result

arr = json.loads(input())
n = int(input())
head = _build_list(arr)
head = Solution().remove_nth_from_end(head, n)
print(json.dumps(_list_to_array(head), separators=(',', ':')))
