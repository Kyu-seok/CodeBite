class TimestampedStore {
    constructor() {
        this.history = new Map();
    }

    write(key, value, timestamp) {
        if (!this.history.has(key)) this.history.set(key, []);
        this.history.get(key).push([timestamp, value]);
    }

    readAt(key, timestamp) {
        const writes = this.history.get(key) || [];
        let lo = 0, hi = writes.length;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (writes[mid][0] <= timestamp) lo = mid + 1; else hi = mid;
        }
        return lo === 0 ? "" : writes[lo - 1][1];
    }
}
