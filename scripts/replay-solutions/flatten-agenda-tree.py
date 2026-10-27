from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def unrollSchedule(self, root: Optional[TreeNode]) -> None:
        node = root
        while node:
            if node.left:
                # Hang the right subtree off the left subtree's last preorder node.
                tail = node.left
                while tail.right:
                    tail = tail.right
                tail.right = node.right
                node.right, node.left = node.left, None
            node = node.right
