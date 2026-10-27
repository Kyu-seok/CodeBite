class Solution:
    def hamming_weight(self, sensorMask: int) -> int:
        return (sensorMask & 0xFFFFFFFF).bit_count()
