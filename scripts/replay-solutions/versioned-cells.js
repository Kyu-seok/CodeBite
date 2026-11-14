class VersionedCells {
    constructor(length) {
        this.snapId = 0;
        this.history = Array.from({ length }, () => [[-1, 0]]);
    }

    set(index, val) {
        const cell = this.history[index];
        const last = cell[cell.length - 1];
        if (last[0] === this.snapId) {
            last[1] = val;
        } else {
            cell.push([this.snapId, val]);
        }
    }

    commit() {
        return this.snapId++;
    }

    readAt(index, snapId) {
        const cell = this.history[index];
        let lo = 0, hi = cell.length - 1;
        while (lo < hi) {
            const mid = (lo + hi + 1) >> 1;
            if (cell[mid][0] <= snapId) lo = mid; else hi = mid - 1;
        }
        return cell[lo][1];
    }
}
