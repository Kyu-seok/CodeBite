{USER_CODE}

import json

arr = json.loads(input())
pos = int(input())

nodes = []
dummy = ListNode(0)
curr = dummy
for v in arr:
    curr.next = ListNode(v)
    curr = curr.next
    nodes.append(curr)

head = dummy.next
if pos >= 0 and nodes:
    nodes[-1].next = nodes[pos]

result = Solution().has_cycle(head)
print(json.dumps(result))
