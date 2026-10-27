class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


class Solution:
    def captureDockSilhouette(self, root: TreeNode | None) -> list[int]:
        view: list[int] = []
        level = [root] if root else []
        while level:
            view.append(level[-1].val)
            level = [child for node in level for child in (node.left, node.right) if child]
        return view
