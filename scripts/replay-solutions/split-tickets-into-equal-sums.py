class Solution:
    def canSplitEqually(self, tickets: list[int]) -> bool:
        total = sum(tickets)
        if total % 2:
            return False
        reachable = {0}  # sums some subset of the tickets seen so far adds up to
        for ticket in tickets:
            reachable |= {s + ticket for s in reachable}
        return total // 2 in reachable
