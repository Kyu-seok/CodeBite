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

def _find_node(root, val):
    if root is None:
        return None
    if root.val == val:
        return root
    left = _find_node(root.left, val)
    if left is not None:
        return left
    return _find_node(root.right, val)

arr = json.loads(input())
p_val = int(input())
q_val = int(input())
root = _build_tree(arr)
p = _find_node(root, p_val)
q = _find_node(root, q_val)
result = Solution().findSharedAssembly(root, p, q)
print(result.val)
