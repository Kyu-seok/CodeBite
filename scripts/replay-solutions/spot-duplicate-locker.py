class Solution:
    def detectClash(self, lockers: list[int]) -> bool:
        seen: set[int] = set()
        for number in lockers:
            if number in seen:
                return True
            seen.add(number)
        return False
