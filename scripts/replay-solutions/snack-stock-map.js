class ChainedMap {
    constructor() {
        this.buckets = Array.from({ length: 2069 }, () => []);
    }

    bucket(key) {
        return this.buckets[key % this.buckets.length];
    }

    set(key, value) {
        const bucket = this.bucket(key);
        for (const entry of bucket) {
            if (entry[0] === key) {
                entry[1] = value;
                return;
            }
        }
        bucket.push([key, value]);
    }

    lookup(key) {
        for (const [k, v] of this.bucket(key)) {
            if (k === key) return v;
        }
        return -1;
    }

    erase(key) {
        const bucket = this.bucket(key);
        const i = bucket.findIndex((entry) => entry[0] === key);
        if (i >= 0) bucket.splice(i, 1);
    }
}
