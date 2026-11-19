class LowTrackStack {
    constructor() {
        this.entries = [];
    }

    push(val) {
        const low = this.entries.length ? Math.min(val, this.entries[this.entries.length - 1][1]) : val;
        this.entries.push([val, low]);
    }

    pop() {
        this.entries.pop();
    }

    top() {
        return this.entries[this.entries.length - 1][0];
    }

    getMin() {
        return this.entries[this.entries.length - 1][1];
    }
}
