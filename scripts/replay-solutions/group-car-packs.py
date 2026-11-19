class Solution:
    def countCarPacks(self, target: int, position: list[int], speed: list[int]) -> int:
        packs: list[float] = []  # each pack's arrival time at the booth, the nearest pack at the bottom
        for start, pace in sorted(zip(position, speed), reverse=True):
            arrival = (target - start) / pace
            if not packs or arrival > packs[-1]:
                packs.append(arrival)
            # else: it catches the pack on top before the booth and joins it
        return len(packs)
