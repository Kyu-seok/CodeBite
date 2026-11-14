class PrefixIndex {
    constructor() {
        this.root = {};
    }

    insert(word) {
        let node = this.root;
        for (const c of word) node = node[c] || (node[c] = {});
        node.end = true;
    }

    search(word) {
        const node = this.find(word);
        return node !== null && node.end === true;
    }

    startsWith(prefix) {
        return this.find(prefix) !== null;
    }

    find(s) {
        let node = this.root;
        for (const c of s) {
            if (!node[c]) return null;
            node = node[c];
        }
        return node;
    }
}
