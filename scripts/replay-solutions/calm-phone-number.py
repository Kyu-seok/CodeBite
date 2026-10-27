class Solution:
    def is_joyful(self, reading: int) -> bool:
        seen: set[int] = set()
        while reading != 1 and reading not in seen:
            seen.add(reading)
            reading = sum(int(digit) ** 2 for digit in str(reading))
        return reading == 1
