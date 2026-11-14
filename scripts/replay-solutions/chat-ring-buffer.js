class FixedRing {
    constructor(k) {
        this.slots = new Array(k).fill(0);
        this.head = 0;
        this.size = 0;
    }

    push(value) {
        if (this.isFull()) return false;
        this.slots[(this.head + this.size) % this.slots.length] = value;
        this.size++;
        return true;
    }

    pull() {
        if (this.isEmpty()) return false;
        this.head = (this.head + 1) % this.slots.length;
        this.size--;
        return true;
    }

    front() {
        return this.isEmpty() ? -1 : this.slots[this.head];
    }

    rear() {
        return this.isEmpty() ? -1 : this.slots[(this.head + this.size - 1) % this.slots.length];
    }

    isEmpty() {
        return this.size === 0;
    }

    isFull() {
        return this.size === this.slots.length;
    }
}
