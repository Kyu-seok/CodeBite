{USER_CODE}

import json
from collections import deque

def _build_tree(arr):
    if not arr:
        return None
    root = TreeNode(arr[0])
    queue = deque([root])
    i = 1
    while queue and i < len(arr):
        node = queue.popleft()
        if i < len(arr) and arr[i] is not None:
            node.left = TreeNode(arr[i])
            queue.append(node.left)
        i += 1
        if i < len(arr) and arr[i] is not None:
            node.right = TreeNode(arr[i])
            queue.append(node.right)
        i += 1
    return root

arr = json.loads(input())
root = _build_tree(arr)
Solution().flatten(root)
result = []
curr = root
while curr:
    result.append(curr.val)
    curr = curr.right
print(json.dumps(result, separators=(',', ':')))
