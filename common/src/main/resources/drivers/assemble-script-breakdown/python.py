{USER_CODE}

import json
from collections import deque

def _tree_to_array(root):
    if not root:
        return []
    result = []
    queue = deque([root])
    while queue:
        node = queue.popleft()
        if node is None:
            result.append(None)
        else:
            result.append(node.val)
            queue.append(node.left)
            queue.append(node.right)
    while result and result[-1] is None:
        result.pop()
    return result

preorder = json.loads(input())
inorder = json.loads(input())
result = Solution().assembleBreakdown(preorder, inorder)
print(json.dumps(_tree_to_array(result), separators=(',', ':')))
