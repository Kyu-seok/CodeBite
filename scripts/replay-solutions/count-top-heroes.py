from typing import Optional


class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def countDominantHeroes(self, root: Optional[TreeNode]) -> int:
        # Each call carries the highest number above its node; the node is dominant when it reaches that number.
        def count(node: Optional[TreeNode], best: float) -> int:
            if node is None:
                return 0
            dominant = node.val >= best
            best = max(best, node.val)
            return int(dominant) + count(node.left, best) + count(node.right, best)

        return count(root, float("-inf"))
