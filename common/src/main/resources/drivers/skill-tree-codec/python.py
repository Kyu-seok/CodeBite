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

def _tree_to_array(root):
    if not root:
        return []
    result = []
    queue = deque([root])
    while queue:
        node = queue.popleft()
        if node:
            result.append(node.val)
            queue.append(node.left)
            queue.append(node.right)
        else:
            result.append(None)
    while result and result[-1] is None:
        result.pop()
    return result

def _format_tree(arr):
    if not arr:
        return '[]'
    parts = []
    for v in arr:
        parts.append('null' if v is None else str(v))
    return '[' + ','.join(parts) + ']'

arr = json.loads(input())
root = _build_tree(arr)
codec = TreeSerializer()
serialized = codec.pack(root)
result = codec.unpack(serialized)
print(_format_tree(_tree_to_array(result)))
