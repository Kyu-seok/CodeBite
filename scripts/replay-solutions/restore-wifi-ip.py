class Solution:
    def splitZoneCodes(self, digits: str) -> list[str]:
        def valid(segment: str) -> bool:
            return 0 < len(segment) <= 3 and (segment == "0" or segment[0] != "0") and int(segment) <= 255

        addresses = []
        for a in range(1, 4):
            for b in range(a + 1, a + 4):
                for c in range(b + 1, b + 4):
                    if c >= len(digits):
                        continue
                    segments = [digits[:a], digits[a:b], digits[b:c], digits[c:]]
                    if all(valid(segment) for segment in segments):
                        addresses.append(".".join(segments))
        return sorted(addresses)
