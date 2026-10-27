import bisect


class VersionedCells:
    def __init__(self, length: int) -> None:
        self.snap_id = 0
        self.history: list[list[tuple[int, int]]] = [[(-1, 0)] for _ in range(length)]

    def set(self, index: int, val: int) -> None:
        cell = self.history[index]
        if cell[-1][0] == self.snap_id:
            cell[-1] = (self.snap_id, val)
        else:
            cell.append((self.snap_id, val))

    def commit(self) -> int:
        self.snap_id += 1
        return self.snap_id - 1

    def readAt(self, index: int, snapId: int) -> int:
        cell = self.history[index]
        i = bisect.bisect_right(cell, (snapId, float("inf")))
        return cell[i - 1][1]
