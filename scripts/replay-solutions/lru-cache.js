class LRUCache {
    constructor(capacity) {
        this.capacity = capacity;
        this.entries = new Map();
    }

    get(key) {
        if (!this.entries.has(key)) return -1;
        const value = this.entries.get(key);
        this.entries.delete(key);
        this.entries.set(key, value);
        return value;
    }

    put(key, value) {
        this.entries.delete(key);
        this.entries.set(key, value);
        if (this.entries.size > this.capacity) {
            this.entries.delete(this.entries.keys().next().value);
        }
    }
}
