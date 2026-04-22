from typing import Optional

class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class TreeSerializer:
    def pack(self, root: Optional[TreeNode]) -> str:
        # Write your solution here
        pass

    def unpack(self, data: str) -> Optional[TreeNode]:
        # Write your solution here
        pass
