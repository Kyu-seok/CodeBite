from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def containsSubBranch(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        # A preorder walk with "#" for missing children identifies a subtree's shape and values,
        # so subRoot is a subtree of root exactly when its walk appears whole in root's walk.
        def walk(node: Optional[TreeNode]) -> str:
            parts: list[str] = []
            stack = [node]
            while stack:
                current = stack.pop()
                if current is None:
                    parts.append("#")
                else:
                    parts.append(str(current.val))
                    stack += [current.right, current.left]
            return "," + ",".join(parts) + ","

        return walk(subRoot) in walk(root)
