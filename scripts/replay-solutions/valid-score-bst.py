import sys
from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def isValidBST(self, root: Optional[TreeNode]) -> bool:
        # A tree may be one path 2 * 10^5 deep; Python 3.12 recurses that far once the limit allows it.
        sys.setrecursionlimit(max(sys.getrecursionlimit(), 400_000))

        def valid(node, low, high):
            # Every node must fall inside the open range (low, high) its ancestors leave it.
            if node is None:
                return True
            if (low is not None and node.val <= low) or (high is not None and node.val >= high):
                return False
            return valid(node.left, low, node.val) and valid(node.right, node.val, high)

        return valid(root, None, None)
