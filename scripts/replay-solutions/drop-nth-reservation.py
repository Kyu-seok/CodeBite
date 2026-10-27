from typing import Optional


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def dropTailBooking(self, head: Optional[ListNode], n: int) -> Optional[ListNode]:
        dummy = ListNode(0, head)
        lead = trail = dummy
        for _ in range(n):
            lead = lead.next
        while lead.next:
            lead = lead.next
            trail = trail.next
        trail.next = trail.next.next
        return dummy.next
