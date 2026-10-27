class Solution:
    def smallestFlowRate(self, volumes: list[int], days: int) -> int:
        def days_needed(capacity: int) -> int:
            used, load = 1, 0
            for volume in volumes:
                if load + volume > capacity:
                    used += 1
                    load = 0
                load += volume
            return used

        low, high = max(volumes), sum(volumes)
        while low < high:
            mid = (low + high) // 2
            if days_needed(mid) <= days:
                high = mid
            else:
                low = mid + 1
        return low
