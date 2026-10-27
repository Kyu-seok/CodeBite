from typing import Optional


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def swapQueuePartners(self, head: Optional[ListNode]) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        before = dummy
        while before.next and before.next.next:
            first, second = before.next, before.next.next
            first.next = second.next
            second.next = first
            before.next = second
            before = first
        return dummy.next
