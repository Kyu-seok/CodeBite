class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def reverseList(self, head: ListNode | None) -> ListNode | None:
        previous = None
        while head:
            head.next, previous, head = previous, head, head.next
        return previous
