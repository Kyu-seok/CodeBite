from typing import Optional


class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class Solution:
    def add_two_numbers(self, score1: Optional[ListNode], score2: Optional[ListNode]) -> Optional[ListNode]:
        dummy = tail = ListNode()
        carry = 0
        while score1 or score2 or carry:
            total = carry
            if score1:
                total += score1.val
                score1 = score1.next
            if score2:
                total += score2.val
                score2 = score2.next
            carry, digit = divmod(total, 10)
            tail.next = ListNode(digit)
            tail = tail.next
        return dummy.next
