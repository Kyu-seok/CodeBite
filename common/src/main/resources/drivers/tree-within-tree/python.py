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

arr1 = json.loads(input())
arr2 = json.loads(input())
root = _build_tree(arr1)
sub_root = _build_tree(arr2)
result = Solution().isSubtree(root, sub_root)
print(str(result).lower())
