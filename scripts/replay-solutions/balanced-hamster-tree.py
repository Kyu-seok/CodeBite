from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def checkHubEvenness(self, root: Optional[TreeNode]) -> bool:
        # Post-order without recursion: a node's height once both children are known.
        height: dict[TreeNode | None, int] = {None: 0}
        stack = [(root, False)] if root else []
        while stack:
            node, children_done = stack.pop()
            if children_done:
                left, right = height[node.left], height[node.right]
                if abs(left - right) > 1:
                    return False
                height[node] = 1 + max(left, right)
            else:
                stack.append((node, True))
                for child in (node.left, node.right):
                    if child:
                        stack.append((child, False))
        return True
