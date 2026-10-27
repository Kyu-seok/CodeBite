class Solution:
    def voidEmptyScans(self, scans: list[int]) -> None:
        # Keep the non-zero scans in order at the front, then fill the rest with zeros.
        write = 0
        for scan in scans:
            if scan != 0:
                scans[write] = scan
                write += 1
        for i in range(write, len(scans)):
            scans[i] = 0
