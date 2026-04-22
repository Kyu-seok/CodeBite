from typing import Optional

class Node:
    def __init__(self, val: int = 0, left: 'Node' = None,
                 right: 'Node' = None, next: 'Node' = None):
        self.val = val
        self.left = left
        self.right = right
        self.next = next

class Solution:
    def wireSiblingHubs(self, root: Optional[Node]) -> Optional[Node]:
        # Write your solution here
        pass
