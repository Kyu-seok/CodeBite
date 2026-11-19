class Solution:
    def restoreIpAddresses(self, digits: str) -> list[str]:
        addresses: list[str] = []
        segments: list[str] = []

        def place(start: int) -> None:
            if len(segments) == 4:
                if start == len(digits):
                    addresses.append(".".join(segments))
                return
            for end in range(start + 1, min(start + 3, len(digits)) + 1):
                segment = digits[start:end]
                if (segment[0] == "0" and len(segment) > 1) or int(segment) > 255:
                    break  # a longer segment keeps the leading zero or grows past 255
                left, slots = len(digits) - end, 3 - len(segments)
                if left < slots or left > 3 * slots:
                    continue  # the digits left can't fill the segments left
                segments.append(segment)
                place(end)
                segments.pop()

        place(0)
        return addresses
