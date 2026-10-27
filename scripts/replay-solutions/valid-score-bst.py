from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def verifyWardOrder(self, root: Optional[TreeNode]) -> bool:
        stack = [(root, float("-inf"), float("inf"))]
        while stack:
            node, low, high = stack.pop()
            if node is None:
                continue
            if not low < node.val < high:
                return False
            stack += [(node.left, low, node.val), (node.right, node.val, high)]
        return True
