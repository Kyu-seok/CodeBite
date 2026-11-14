class StreamMedian {
    constructor() {
        this.values = [];
    }

    record(num) {
        let lo = 0, hi = this.values.length;
        while (lo < hi) {
            const mid = (lo + hi) >> 1;
            if (this.values[mid] < num) lo = mid + 1; else hi = mid;
        }
        this.values.splice(lo, 0, num);
    }

    median() {
        const n = this.values.length;
        if (n % 2 === 1) return this.values[(n - 1) / 2];
        return (this.values[n / 2 - 1] + this.values[n / 2]) / 2;
    }
}
