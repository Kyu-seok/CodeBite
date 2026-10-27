class Solution:
    def find_min_arrows(self, targets: list[list[int]]) -> int:
        # Drop each pellet as late as possible: at the end of the earliest-ending zone not yet fed.
        pellets = 0
        last_drop: int | None = None
        for start, end in sorted(targets, key=lambda zone: zone[1]):
            if last_drop is None or start > last_drop:
                pellets += 1
                last_drop = end
        return pellets
