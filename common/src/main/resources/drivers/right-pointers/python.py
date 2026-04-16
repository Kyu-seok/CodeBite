{USER_CODE}

import json
from collections import deque

def _build_tree(arr):
    if not arr:
        return None
    root = Node(arr[0])
    queue = deque([root])
    i = 1
    while queue and i < len(arr):
        node = queue.popleft()
        if i < len(arr) and arr[i] is not None:
            node.left = Node(arr[i])
            queue.append(node.left)
        i += 1
        if i < len(arr) and arr[i] is not None:
            node.right = Node(arr[i])
            queue.append(node.right)
        i += 1
    return root

def _serialize(root):
    if root is None:
        return '[]'
    parts = []
    level_start = root
    while level_start is not None:
        curr = level_start
        while curr is not None:
            parts.append(str(curr.val))
            curr = curr.next
        parts.append('#')
        level_start = level_start.left
    return '[' + ','.join(parts) + ']'

arr = json.loads(input())
root = _build_tree(arr)
result = Solution().connect(root)
print(_serialize(result))
