class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}

class Codec {
    serialize(root) {
        const parts = [];
        const write = node => {
            if (!node) { parts.push('#'); return; }
            parts.push(String(node.val));
            write(node.left);
            write(node.right);
        };
        write(root);
        return parts.join(',');
    }

    deserialize(data) {
        const tokens = data.split(',');
        let i = 0;
        const read = () => {
            const t = tokens[i++];
            if (t === undefined || t === '#') return null;
            const node = new TreeNode(Number(t));
            node.left = read();
            node.right = read();
            return node;
        };
        return read();
    }
}
