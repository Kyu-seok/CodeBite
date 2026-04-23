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

arr1 = json.loads(input())
arr2 = json.loads(input())
list1 = _build_list(arr1)
list2 = _build_list(arr2)
result = Solution().combineOvenRotations(list1, list2)
print(json.dumps(_list_to_array(result), separators=(',', ':')))
