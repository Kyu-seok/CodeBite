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

data = json.loads(input())
lists = [_build_list(arr) for arr in data]
result = Solution().merge_k_lists(lists)
print(json.dumps(_list_to_array(result), separators=(',', ':')))
